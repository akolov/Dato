//
//  NNMCalendarViewController.m
//  Calendar
//
//  Created by Alexander Kolov on 13/02/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

@import EventKit;

#import "NNMConfig.h"
#import "NNMCalendarViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "NNMCalendarHeaderView.h"
#import "NNMCalendarLayout.h"
#import "NNMCalendarViewCell.h"
#import "NNMScheduleDayViewCell.h"
#import "NNMScheduleEventViewCell.h"
#import "NNMScheduleHeaderView.h"
#import "NSCalendar+STYHelpers.h"

@interface NNMCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
                                         UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSArray *nextDayEvents;
@property (nonatomic, strong) NSDateFormatter *dayFormatter;
@property (nonatomic, strong) NSDateFormatter *monthFormatter;
@property (nonatomic, strong) NSDateFormatter *relativeFormatter;
@property (nonatomic, strong) NSDateFormatter *weekdayFormatter;
@property (nonatomic, strong) NSDateFormatter *headerFormatter;
@property (nonatomic, strong) NSDateFormatter *titleFormatter;
@property (nonatomic, strong) NSDateFormatter *timeFormatter;
@property (nonatomic, strong) NNMCalendarLayout *layout;
@property (nonatomic, strong) UICollectionView *calendarView;
@property (nonatomic, strong) UITableView *scheduleView;

- (NSArray *)eventsForDate:(NSDate *)date;
- (NNMScheduleEventViewCell *)eventCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)expandSchedule:(UITableView *)scheduleView forDate:(NSDate *)date;

- (void)sizeScheduleToFit;
- (void)scrollCalendarToScheduleRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

@end

@implementation NNMCalendarViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  @weakify(self);

  self.automaticallyAdjustsScrollViewInsets = NO;

  self.calendar = [NSCalendar autoupdatingCurrentCalendar];
  self.today = ({
    NSDateComponents *components =
      [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [self.calendar dateFromComponents:components];
  });

  self.eventStore = [[EKEventStore alloc] init];
  [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
    @strongify(self);

    if (granted) {
      self.events = [self eventsForDate:self.today];
      [self.scheduleView reloadData];
      [self sizeScheduleToFit];
    }
    else {
      ErrorLog(@"WTF!");
    }

    if (error) {
      ErrorLog(error.localizedDescription);
    }
  }];

  // Formatters

  self.dayFormatter = [[NSDateFormatter alloc] init];
  self.dayFormatter.dateFormat =
    [NSDateFormatter dateFormatFromTemplate:@"d" options:0 locale:[NSLocale autoupdatingCurrentLocale]];

  self.monthFormatter = [[NSDateFormatter alloc] init];
  self.monthFormatter.dateFormat =
    [NSDateFormatter dateFormatFromTemplate:@"MMMM" options:0 locale:[NSLocale autoupdatingCurrentLocale]];

  self.relativeFormatter = [[NSDateFormatter alloc] init];
  self.relativeFormatter.timeStyle = NSDateFormatterNoStyle;
  self.relativeFormatter.dateStyle = NSDateFormatterMediumStyle;
  self.relativeFormatter.doesRelativeDateFormatting = YES;

  self.weekdayFormatter = [[NSDateFormatter alloc] init];
  self.weekdayFormatter.dateFormat =
    [NSDateFormatter dateFormatFromTemplate:@"cccc" options:0 locale:[NSLocale autoupdatingCurrentLocale]];

  self.headerFormatter = [[NSDateFormatter alloc] init];
  self.headerFormatter.dateFormat =
    [NSDateFormatter dateFormatFromTemplate:@"MMMMd" options:0 locale:[NSLocale autoupdatingCurrentLocale]];

  self.titleFormatter = [[NSDateFormatter alloc] init];
  self.titleFormatter.dateFormat =
    [NSDateFormatter dateFormatFromTemplate:@"MMMMdy" options:0 locale:[NSLocale autoupdatingCurrentLocale]];;

  self.timeFormatter = [[NSDateFormatter alloc] init];
  self.timeFormatter.timeStyle = NSDateFormatterShortStyle;
  self.timeFormatter.dateStyle = NSDateFormatterNoStyle;

  // View

  self.title = [self.titleFormatter stringFromDate:[NSDate date]];
  self.navigationController.navigationBar.barTintColor = [UIColor calendarBackgroundGreenColor];
  self.view.backgroundColor = [UIColor calendarBackgroundGreenColor];

  // Calendar View

  self.layout = [[NNMCalendarLayout alloc] init];
  self.layout.calendar = self.calendar;
  self.layout.startDate = self.today;

  self.calendarView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
  self.calendarView.backgroundColor = [UIColor calendarBackgroundGreenColor];
  self.calendarView.dataSource = self;
  self.calendarView.delegate = self;
  self.calendarView.showsHorizontalScrollIndicator = NO;
  self.calendarView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:self.calendarView];

  [self.calendarView registerClass:[NNMCalendarViewCell class]
        forCellWithReuseIdentifier:[NNMCalendarViewCell reuseIdentifier]];
  [self.calendarView registerClass:[NNMCalendarHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:[NNMCalendarHeaderView reuseIdentifier]];

  // Schedule View

  CGRect scheduleFrame = self.view.bounds;

  self.scheduleView = [[UITableView alloc] initWithFrame:scheduleFrame style:UITableViewStyleGrouped];
  self.scheduleView.backgroundColor = [UIColor calendarBackgroundGreenColor];
  self.scheduleView.dataSource = self;
  self.scheduleView.delegate = self;
  self.scheduleView.rowHeight = 60.0f;
  self.scheduleView.scrollEnabled = NO;
  self.scheduleView.sectionFooterHeight = 0;
  self.scheduleView.sectionHeaderHeight = 0;
  self.scheduleView.separatorColor = [UIColor calendarSeparatorGreenColor];
  self.scheduleView.separatorInset = UIEdgeInsetsMake(0, 30.0f, 0, 0);
  [self.calendarView addSubview:self.scheduleView];

  [self.scheduleView registerClass:[NNMScheduleDayViewCell class]
            forCellReuseIdentifier:[NNMScheduleDayViewCell reuseIdentifier]];
  [self.scheduleView registerClass:[NNMScheduleEventViewCell class]
            forCellReuseIdentifier:[NNMScheduleEventViewCell reuseIdentifier]];
  [self.scheduleView registerClass:[NNMScheduleHeaderView class]
forHeaderFooterViewReuseIdentifier:[NNMScheduleHeaderView reuseIdentifier]];

  self.events = [self eventsForDate:self.today];
  [self.scheduleView reloadData];
  [self sizeScheduleToFit];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 12;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.month = section;
  NSDate *date = [self.calendar dateByAddingComponents:components toDate:self.today options:0];
  return [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  NNMCalendarViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:[NNMCalendarViewCell reuseIdentifier]
                                              forIndexPath:indexPath];

  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.day = indexPath.item;
  components.month = indexPath.section;
  NSDate *date = [self.calendar dateByAddingComponents:components toDate:self.layout.startDate options:0];

  cell.dateLabel.text = [self.dayFormatter stringFromDate:date];

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    NNMCalendarHeaderView *header =
      [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                         withReuseIdentifier:[NNMCalendarHeaderView reuseIdentifier]
                                                forIndexPath:indexPath];

    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = indexPath.item;
    components.month = indexPath.section;
    NSDate *date = [self.calendar dateByAddingComponents:components toDate:self.layout.startDate options:0];

    header.textLabel.text = [self.monthFormatter stringFromDate:date];

    return header;
  }

  return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSDateComponents *referenceComponents = [self.calendar components:NSMonthCalendarUnit | NSYearCalendarUnit
                                                           fromDate:self.today];
  referenceComponents.day = 1;
  NSDate *referenceDate = [self.calendar dateFromComponents:referenceComponents];

  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.month = indexPath.section;
  components.day = indexPath.item;

  NSDate *date = [self.calendar dateByAddingComponents:components toDate:referenceDate options:0];
  [self expandSchedule:self.scheduleView forDate:date];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.nextDayEvents) {
    return 4;
  }
  else {
    return 3;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return [self.events count] != 0 ? [self.events count] : 1;
    case 1:
      if (self.nextDayEvents) {
        return [self.nextDayEvents count] != 0 ? [self.nextDayEvents count] : 1;
      }
      else {
        return 1;
      }
    default:
      return 1;
  }

  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0: {
      if ([self.events count] != 0) {
        return [self eventCellForTableView:tableView atIndexPath:indexPath];
      }
      else {
        NNMScheduleDayViewCell *cell =
          [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                          forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"No events today", nil);
        return cell;
      }
    }
    case 1: {
      if (self.nextDayEvents) {
        if ([self.nextDayEvents count] != 0) {
          return [self eventCellForTableView:tableView atIndexPath:indexPath];
        }
        else {
          NNMScheduleDayViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                            forIndexPath:indexPath];
          cell.textLabel.text = NSLocalizedString(@"No events today", nil);
          return cell;
        }
      }
      else {
        NNMScheduleDayViewCell *cell =
          [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                          forIndexPath:indexPath];
        NSDate *date = [self.calendar nextDate:[NSDate date]];
        cell.textLabel.text = [self.relativeFormatter stringFromDate:date];
        return cell;
      }
    }
    case 2: {
      NNMScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                        forIndexPath:indexPath];
      NSDate *date = [self.calendar nextNextDate:[NSDate date]];
      cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      return cell;
    }
    case 3: {
      NNMScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                        forIndexPath:indexPath];
      NSDate *date = [self.calendar nextDate:[self.calendar nextNextDate:[NSDate date]]];
      cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      return cell;
    }
  }

  return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 1: {
      NNMScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NNMScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextDate:self.today];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 2: {
      NNMScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NNMScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextNextDate:self.today];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 3: {
      NNMScheduleHeaderView *view =
      [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NNMScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextDate:[self.calendar nextNextDate:self.today] ];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    default:
      return nil;
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 0.01f;
    default:
      return 35.0f;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.day = indexPath.section;

  NSDate *date = [self.calendar dateByAddingComponents:components toDate:self.today options:0];
  [self expandSchedule:tableView forDate:date];
}

#pragma mark - Private Methods

- (NSArray *)eventsForDate:(NSDate *)date {
  if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] != EKAuthorizationStatusAuthorized) {
    return nil;
  }

  NSDate *nextDay = [self.calendar nextDate:date];
  NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:date endDate:nextDay calendars:nil];
  NSArray *events = [[self.eventStore eventsMatchingPredicate:predicate]
                     sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
  return events ?: @[];
}

- (NNMScheduleEventViewCell *)eventCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
  NNMScheduleEventViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:[NNMScheduleEventViewCell reuseIdentifier] forIndexPath:indexPath];
  EKEvent *event = indexPath.section == 0 ? self.events[indexPath.row] : self.nextDayEvents[indexPath.row];
  EKCalendar *calendar = event.calendar;
  cell.eventLabel.text = event.title;

  if (event.allDay) {
    cell.timeLabel.text = NSLocalizedString(@"All Day", nil);
  }
  else {
    NSString *start = [self.timeFormatter stringFromDate:event.startDate];
    NSString *end = [self.timeFormatter stringFromDate:event.endDate];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ — %@", start, end];
  }

  cell.calendarKnob.backgroundColor = [UIColor colorWithCGColor:calendar.CGColor];
  return cell;
}

- (void)expandSchedule:(UITableView *)scheduleView forDate:(NSDate *)date {
  if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] != EKAuthorizationStatusAuthorized) {
    return;
  }

  self.title = [self.titleFormatter stringFromDate:date];
  self.nextDayEvents = [self eventsForDate:date];

  __block CGRect frame;
  __block CGFloat offsetY;

  CGFloat height = 0;
  for (NSInteger i = 0; i < self.scheduleView.numberOfSections; ++i) {
    if (i == 1) {
      height += [self.nextDayEvents count] * self.scheduleView.rowHeight;
    }
    else {
      height += [self.scheduleView numberOfRowsInSection:i] * self.scheduleView.rowHeight;
    }

    height += CGRectGetHeight([self.scheduleView rectForHeaderInSection:i]);
  }

  height += 35.0f + self.scheduleView.rowHeight;

  CGRect scheduleFrame = self.scheduleView.frame;
  scheduleFrame.origin.y = -height;
  scheduleFrame.size.height = height;
  self.scheduleView.frame = scheduleFrame;

  offsetY = height + 66.0f;
  self.calendarView.contentInset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
  [self.calendarView setContentOffset:CGPointMake(0, -offsetY) animated:NO];

  [CATransaction begin];
  [CATransaction setCompletionBlock:^{
    self.today = date;
    self.events = [self eventsForDate:self.today];
    self.nextDayEvents = nil;
    [self.scheduleView reloadData];
    [self sizeScheduleToFit];
    [self scrollCalendarToScheduleRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];
  }];

  [scheduleView beginUpdates];
  [scheduleView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
  [scheduleView insertSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
  [scheduleView endUpdates];

  frame = [scheduleView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
  offsetY = -self.calendarView.contentInset.top + frame.origin.y;
  [self.calendarView setContentOffset:CGPointMake(0, offsetY) animated:YES];

  [CATransaction commit];
}

- (void)sizeScheduleToFit {
  CGFloat height = 0;
  for (NSInteger i = 0; i < self.scheduleView.numberOfSections; ++i) {
    height += [self.scheduleView numberOfRowsInSection:i] * self.scheduleView.rowHeight;
    height += CGRectGetHeight([self.scheduleView rectForHeaderInSection:i]);
  }

  CGRect scheduleFrame = self.scheduleView.frame;
  scheduleFrame.origin.y = -height;
  scheduleFrame.size.height = height;
  self.scheduleView.frame = scheduleFrame;
  self.calendarView.contentInset = UIEdgeInsetsMake(height + 66.0f, 0, 0, 0);
}

- (void)scrollCalendarToScheduleRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
  CGRect rect = [self.scheduleView rectForRowAtIndexPath:indexPath];
  CGFloat height = CGRectGetHeight(self.scheduleView.frame);
  [self.calendarView setContentOffset:CGPointMake(0, -height + CGRectGetMinY(rect) - 66.0f) animated:animated];
}

@end
