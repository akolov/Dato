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

static CGFloat NNMWorkHoursPerDay = 8.0f;

typedef NS_ENUM(NSInteger, NNMDateBusyness) {
  NNMDateFree,
  NNMDateNotBusy,
  NNMDateBusy,
  NNMDateVeryBusy
};

@interface NNMCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
                                         UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) NSArray *events;
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
@property (nonatomic, assign) BOOL calendarDidScroll;

- (NNMDateBusyness)dateBusyness:(NSDate *)date events:(out NSArray **)events;

- (NSArray *)eventsForDate:(NSDate *)date;
- (NNMScheduleEventViewCell *)eventCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)configureScheduleCell:(NNMScheduleDayViewCell *)cell forDate:(NSDate *)date;
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
    [NSDateFormatter dateFormatFromTemplate:@"MMMMdy" options:0 locale:[NSLocale autoupdatingCurrentLocale]];

  self.timeFormatter = [[NSDateFormatter alloc] init];
  self.timeFormatter.timeStyle = NSDateFormatterShortStyle;
  self.timeFormatter.dateStyle = NSDateFormatterNoStyle;

  // View

  self.title = [self.titleFormatter stringFromDate:self.today];

  // Calendar View

  self.layout = [[NNMCalendarLayout alloc] init];
  self.layout.calendar = self.calendar;
  self.layout.startDate = self.today;

  self.calendarView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
  self.calendarView.backgroundColor = nil;
  self.calendarView.dataSource = self;
  self.calendarView.delegate = self;
  self.calendarView.opaque = YES;
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
  self.scheduleView.backgroundColor = nil;
  self.scheduleView.clipsToBounds = YES;
  self.scheduleView.dataSource = self;
  self.scheduleView.delegate = self;
  self.scheduleView.opaque = YES;
  self.scheduleView.rowHeight = 60.0f;
  self.scheduleView.scrollEnabled = NO;
  self.scheduleView.sectionFooterHeight = 0;
  self.scheduleView.sectionHeaderHeight = 0;
  self.scheduleView.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
  self.scheduleView.separatorInset = UIEdgeInsetsMake(0, 30.0f, 0, 0);
  [self.calendarView addSubview:self.scheduleView];

  [self changeInterfaceColorForDate:self.today];

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

  switch ([self dateBusyness:date events:NULL]) {
    case NNMDateVeryBusy:
      cell.dateLabel.textColor = [UIColor calendarRedColor];
      break;
    case NNMDateBusy:
      cell.dateLabel.textColor = [UIColor calendarOrangeColor];
      break;
    case NNMDateNotBusy:
      cell.dateLabel.textColor = [UIColor calendarGreenColor];
      break;
    default:
      cell.dateLabel.textColor = [UIColor whiteColor];
      break;
  }

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
  return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 2:
      return [self.events count] != 0 ? [self.events count] : 1;
    default:
      return 1;
  }

  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0: {
      NNMScheduleDayViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                      forIndexPath:indexPath];
      cell.textLabel.text = [self.relativeFormatter stringFromDate:self.today];
      [self configureScheduleCell:cell forDate:self.today];
      return cell;
    }
    case 1: {
      NNMScheduleDayViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                      forIndexPath:indexPath];
      NSDate *date = [self.calendar previousDate:self.today];
      NSDateComponents *components =
        [self.calendar components:NSDayCalendarUnit fromDate:date toDate:[self.calendar today] options:0];
      if (ABS(components.day) > 1) {
        cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      }
      else {
        cell.textLabel.text = [self.relativeFormatter stringFromDate:date];
      }

      [self configureScheduleCell:cell forDate:date];
      return cell;
    }
    case 2: {
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
    case 3: {
      NNMScheduleDayViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                      forIndexPath:indexPath];
      NSDate *date = [self.calendar nextDate:self.today];
      NSDateComponents *components =
      [self.calendar components:NSDayCalendarUnit fromDate:date toDate:[self.calendar today] options:0];
      if (ABS(components.day) > 1) {
        cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      }
      else {
        cell.textLabel.text = [self.relativeFormatter stringFromDate:date];
      }

      [self configureScheduleCell:cell forDate:date];
      return cell;
    }
    case 4: {
      NNMScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                        forIndexPath:indexPath];
      NSDate *date = [self.calendar nextNextDate:self.today];
      cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      [self configureScheduleCell:cell forDate:date];
      return cell;
    }
    case 5: {
      NNMScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                        forIndexPath:indexPath];
      NSDate *date = [self.calendar dateWithOffset:3 fromDate:self.today];
      cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      [self configureScheduleCell:cell forDate:date];
      return cell;
    }
    case 6: {
      NNMScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[NNMScheduleDayViewCell reuseIdentifier]
                                      forIndexPath:indexPath];
      NSDate *date = [self.calendar dateWithOffset:4 fromDate:self.today];;
      cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      [self configureScheduleCell:cell forDate:date];
      return cell;
    }
  }

  return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 3: {
      NNMScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NNMScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextDate:self.today];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 4: {
      NNMScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NNMScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextNextDate:self.today];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 5: {
      NNMScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NNMScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextDate:[self.calendar nextNextDate:self.today]];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 6: {
      NNMScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NNMScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextDate:[self.calendar dateWithOffset:3 fromDate:self.today]];
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
    case 3:
    case 4:
    case 5:
    case 6:
      return 35.0f;
    default:
      return 0;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 3 || indexPath.section == 4) {
    self.today = [self.calendar dateWithOffset:indexPath.section - 2 fromDate:self.today];

    [self.scheduleView beginUpdates];
    {
      NSArray *reload = @[[NSIndexPath indexPathForRow:0 inSection:2]];
      NSMutableArray *delete = [NSMutableArray array];
      for (NSInteger i = 1; i < [self.scheduleView numberOfRowsInSection:2]; ++i) {
        [delete addObject:[NSIndexPath indexPathForRow:i inSection:2]];
      }

      self.events = nil;

      [self.scheduleView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationFade];
      [self.scheduleView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.scheduleView endUpdates];

    CGFloat offset = 0;
    for (NSInteger i = 3; i < 4; ++i) {
      offset += self.scheduleView.rowHeight;
      offset += CGRectGetHeight([self.scheduleView rectForHeaderInSection:i]);
      offset += CGRectGetHeight([self.scheduleView rectForFooterInSection:i]);
    }

    [UIView animateWithDuration:0.25 animations:^{
      [self.scheduleView setContentOffset:CGPointMake(0, offset) animated:NO];
    } completion:^(BOOL finished) {
      self.title = [self.titleFormatter stringFromDate:self.today];

      [self.scheduleView setContentOffset:CGPointZero animated:NO];
      [self.scheduleView beginUpdates];
      {
        self.events = [self eventsForDate:self.today];

        NSArray *reload = @[[NSIndexPath indexPathForRow:0 inSection:2]];
        NSMutableArray *insert = [NSMutableArray array];
        for (NSInteger i = 1; i < [self.events count]; ++i) {
          [insert addObject:[NSIndexPath indexPathForRow:i inSection:2]];
        }

        [self.scheduleView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationFade];
        [self.scheduleView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
      }
      [self.scheduleView endUpdates];

      [self.scheduleView reloadData];

      [UIView animateWithDuration:0.25 animations:^{
        [self sizeScheduleToFit];
        [self.calendarView setContentOffset:CGPointMake(0, -self.calendarView.contentInset.top) animated:NO];
        [self changeInterfaceColorForDate:self.today];
      }];
    }];
  }
}

#pragma mark - Private Methods

- (void)changeInterfaceColorForDate:(NSDate *)date {
  UIColor *color;

  switch ([self dateBusyness:date events:NULL]) {
    case NNMDateVeryBusy:
      color = [UIColor calendarBackgroundRedColor];
      break;
    case NNMDateBusy:
      color = [UIColor calendarBackgroundOrangeColor];
      break;
    default:
      color = [UIColor calendarBackgroundGreenColor];
      break;
  }

  self.navigationController.navigationBar.barTintColor = color;
  self.view.backgroundColor = color;
}

- (NNMDateBusyness)dateBusyness:(NSDate *)date events:(out NSArray **)events {
  NSArray *dateEvents = [self eventsForDate:date];
  CGFloat hoursLeft = NNMWorkHoursPerDay;
  for (EKEvent *event in dateEvents) {
    if (event.allDay) {
      continue;
    }

    NSDateComponents *components = [self.calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit
                                                    fromDate:event.startDate toDate:event.endDate options:0];
    hoursLeft -= components.hour + components.minute / 60.0f;
  }

  if (events) {
    *events = dateEvents;
  }

  if (hoursLeft >= NNMWorkHoursPerDay) {
    return NNMDateFree;
  }
  else if (hoursLeft >= NNMWorkHoursPerDay - 1.0f) {
    return NNMDateNotBusy;
  }
  else if (hoursLeft >= NNMWorkHoursPerDay - 2.0f) {
    return NNMDateBusy;
  }
  else {
    return NNMDateVeryBusy;
  }
}

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
  EKEvent *event = self.events[indexPath.row];
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

- (void)configureScheduleCell:(NNMScheduleDayViewCell *)cell forDate:(NSDate *)date {
  UIColor *color;
  NSArray *events;

  switch ([self dateBusyness:date events:&events]) {
    case NNMDateVeryBusy:
      color = [UIColor calendarRedColor];
      break;
    case NNMDateBusy:
      color = [UIColor calendarOrangeColor];
      break;
    case NNMDateNotBusy:
      color = [UIColor calendarGreenColor];
      break;
    case NNMDateFree:
      color = nil;
      break;
  }

  cell.gradientBaseColor = color;
  cell.gradientComponents = [events count];
}

- (void)expandSchedule:(UITableView *)scheduleView forDate:(NSDate *)date {
  if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] != EKAuthorizationStatusAuthorized) {
    return;
  }

  self.today = date;
  [self.calendarView setContentOffset:CGPointMake(0, -self.calendarView.contentInset.top) animated:YES];
}

- (void)sizeScheduleToFit {
  NSInteger last = [self.scheduleView numberOfSections] - 1;
  CGFloat substraction = 0;
  for (NSInteger i = last; i > last - 2; --i) {
    substraction += [self.scheduleView numberOfRowsInSection:last] * self.scheduleView.rowHeight;
    substraction += CGRectGetHeight([self.scheduleView rectForHeaderInSection:last]);
    substraction += CGRectGetHeight([self.scheduleView rectForFooterInSection:last]);
  }

  CGRect scheduleFrame = self.scheduleView.frame;
  scheduleFrame.origin.y = -self.scheduleView.contentSize.height + substraction;
  scheduleFrame.size.height = self.scheduleView.contentSize.height - substraction;
  self.scheduleView.frame = scheduleFrame;

  self.calendarView.contentInset = UIEdgeInsetsMake(scheduleFrame.size.height - 56.0f, 0, 0, 0);
}

- (void)scrollCalendarToScheduleRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
  CGRect rect = [self.scheduleView rectForRowAtIndexPath:indexPath];
  CGFloat height = CGRectGetHeight(self.scheduleView.frame);
  [self.calendarView setContentOffset:CGPointMake(0, -height + CGRectGetMinY(rect) - 66.0f) animated:animated];
}

@end
