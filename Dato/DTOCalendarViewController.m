//
//  DTOCalendarViewController.m
//  Dato
//
//  Created by Alexander Kolov on 13/02/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import EventKit;

#import "DTOConfig.h"
#import "DTOCalendarViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "DTOCalendarHeaderView.h"
#import "DTOCalendarLayout.h"
#import "DTOCalendarViewCell.h"
#import "DTOScheduleDayViewCell.h"
#import "DTOScheduleEventViewCell.h"
#import "DTOScheduleHeaderView.h"
#import "NSCalendar+DTOAdditions.h"

static CGFloat DTOWorkHoursPerDay = 8.0f;

typedef NS_ENUM(NSInteger, DTODateBusyness) {
  DTODateFree,
  DTODateNotBusy,
  DTODateBusy,
  DTODateVeryBusy
};

@interface DTOCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
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
@property (nonatomic, strong) DTOCalendarLayout *layout;
@property (nonatomic, strong) UICollectionView *calendarView;
@property (nonatomic, strong) UITableView *scheduleView;
@property (nonatomic, assign) BOOL animating;

- (DTODateBusyness)dateBusyness:(NSDate *)date events:(out NSArray **)events;

- (NSArray *)eventsForDate:(NSDate *)date;
- (DTOScheduleEventViewCell *)eventCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)configureScheduleCell:(DTOScheduleDayViewCell *)cell forDate:(NSDate *)date;
- (void)expandSchedule:(UITableView *)scheduleView forDate:(NSDate *)date;

- (void)sizeScheduleToFit;
- (void)scrollCalendarToScheduleRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void)reloadCalendarWithDate:(NSDate *)date;

@end

@implementation DTOCalendarViewController

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

  self.layout = [[DTOCalendarLayout alloc] init];
  self.layout.calendar = self.calendar;
  self.layout.startDate = self.today;

  self.calendarView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
  self.calendarView.backgroundColor = [UIColor backgroundGrayColor];
  self.calendarView.dataSource = self;
  self.calendarView.delegate = self;
  self.calendarView.opaque = YES;
  self.calendarView.showsHorizontalScrollIndicator = NO;
  self.calendarView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:self.calendarView];

  [self.calendarView registerClass:[DTOCalendarViewCell class]
        forCellWithReuseIdentifier:[DTOCalendarViewCell reuseIdentifier]];
  [self.calendarView registerClass:[DTOCalendarHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:[DTOCalendarHeaderView reuseIdentifier]];

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
  self.scheduleView.separatorColor = [UIColor separatorGrayColor];
  self.scheduleView.separatorInset = UIEdgeInsetsMake(0, 30.0f, 0, 0);
  [self.calendarView addSubview:self.scheduleView];

  [self changeInterfaceColorForDate:self.today];

  [self.scheduleView registerClass:[DTOScheduleDayViewCell class]
            forCellReuseIdentifier:[DTOScheduleDayViewCell reuseIdentifier]];
  [self.scheduleView registerClass:[DTOScheduleEventViewCell class]
            forCellReuseIdentifier:[DTOScheduleEventViewCell reuseIdentifier]];
  [self.scheduleView registerClass:[DTOScheduleHeaderView class]
forHeaderFooterViewReuseIdentifier:[DTOScheduleHeaderView reuseIdentifier]];

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
  return (NSInteger)[self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  DTOCalendarViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:[DTOCalendarViewCell reuseIdentifier]
                                              forIndexPath:indexPath];

  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.day = indexPath.item;
  components.month = indexPath.section;
  NSDate *date = [self.calendar dateByAddingComponents:components toDate:self.layout.startDate options:0];

  cell.dateLabel.text = [self.dayFormatter stringFromDate:date];

  switch ([self dateBusyness:date events:NULL]) {
    case DTODateVeryBusy:
      cell.dateLabel.textColor = [UIColor calendarRedColor];
      break;
    case DTODateBusy:
      cell.dateLabel.textColor = [UIColor calendarOrangeColor];
      break;
    case DTODateNotBusy:
      cell.dateLabel.textColor = [UIColor calendarYellowColor];
      break;
    default:
      cell.dateLabel.textColor = [UIColor textDarkGrayColor];
      break;
  }

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    DTOCalendarHeaderView *header =
      [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                         withReuseIdentifier:[DTOCalendarHeaderView reuseIdentifier]
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
      return [self.events count] != 0 ? (NSInteger)[self.events count] : 1;
    default:
      return 1;
  }

  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0: {
      DTOScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
                                      forIndexPath:indexPath];
      cell.textLabel.text = @"Today";
      [self configureScheduleCell:cell forDate:nil];
      return cell;
    }
    case 1: {
      DTOScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
                                        forIndexPath:indexPath];
      cell.textLabel.text = @"Yesterday";
      [self configureScheduleCell:cell forDate:nil];
      return cell;
    }
    case 2: {
      if ([self.events count] != 0) {
        return [self eventCellForTableView:tableView atIndexPath:indexPath];
      }
      else {
        DTOScheduleDayViewCell *cell =
          [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
                                          forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"You have no dates today...", nil);
        return cell;
      }
    }
    case 3: {
      DTOScheduleDayViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
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
      DTOScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
                                        forIndexPath:indexPath];
      NSDate *date = [self.calendar nextNextDate:self.today];
      cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      [self configureScheduleCell:cell forDate:date];
      return cell;
    }
    case 5: {
      DTOScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
                                        forIndexPath:indexPath];
      NSDate *date = [self.calendar dateWithOffset:3 fromDate:self.today];
      cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      [self configureScheduleCell:cell forDate:date];
      return cell;
    }
    case 6: {
      DTOScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
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
      DTOScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DTOScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextDate:self.today];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 4: {
      DTOScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DTOScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextNextDate:self.today];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 5: {
      DTOScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DTOScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextDate:[self.calendar nextNextDate:self.today]];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 6: {
      DTOScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DTOScheduleHeaderView reuseIdentifier]];
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

    offset *= indexPath.section - 2;

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
        for (NSUInteger i = 1; i < [self.events count]; ++i) {
          [insert addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:2]];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView != self.calendarView) {
    return;
  }

  if (self.animating) {
    return;
  }

  CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
  if (offset <= -self.scheduleView.rowHeight) {

    self.animating = YES;
    self.today = [self.calendar dateWithOffset:-1 fromDate:self.today];

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
        for (NSUInteger i = 1; i < [self.events count]; ++i) {
          [insert addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:2]];
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
      } completion:^(BOOL innerFinished) {
        self.animating = NO;
      }];
    }];
  }
}

#pragma mark - Private Methods

- (void)changeInterfaceColorForDate:(NSDate *)date {
  UIColor *color;

  switch ([self dateBusyness:date events:NULL]) {
    case DTODateVeryBusy:
      color = [UIColor calendarRedColor];
      break;
    case DTODateBusy:
      color = [UIColor calendarOrangeColor];
      break;
    case DTODateNotBusy:
      color = [UIColor calendarYellowColor];
      break;
    default:
      color = [UIColor calendarBlueColor];
      break;
  }

  self.navigationController.navigationBar.barTintColor = color;
}

- (DTODateBusyness)dateBusyness:(NSDate *)date events:(out NSArray * __autoreleasing *)events {
  NSArray *dateEvents = [self eventsForDate:date];
  CGFloat hoursLeft = DTOWorkHoursPerDay;
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

  if (hoursLeft >= DTOWorkHoursPerDay) {
    return DTODateFree;
  }
  else if (hoursLeft >= DTOWorkHoursPerDay - 1.0f) {
    return DTODateNotBusy;
  }
  else if (hoursLeft >= DTOWorkHoursPerDay - 2.0f) {
    return DTODateBusy;
  }
  else {
    return DTODateVeryBusy;
  }
}

- (NSArray *)eventsForDate:(NSDate *)date {
  if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] != EKAuthorizationStatusAuthorized) {
    return nil;
  }

  if (!date) {
    return nil;
  }

  NSDate *nextDay = [self.calendar nextDate:date];
  NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:date endDate:nextDay calendars:nil];
  NSArray *events = [[self.eventStore eventsMatchingPredicate:predicate]
                     sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
  return events ?: @[];
}

- (DTOScheduleEventViewCell *)eventCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
  DTOScheduleEventViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:[DTOScheduleEventViewCell reuseIdentifier] forIndexPath:indexPath];
  EKEvent *event = self.events[(NSUInteger)indexPath.row];
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

- (void)configureScheduleCell:(DTOScheduleDayViewCell *)cell forDate:(NSDate *)date {
  UIColor *color;
  NSArray *events;

  switch ([self dateBusyness:date events:&events]) {
    case DTODateVeryBusy:
      color = [UIColor calendarRedColor];
      break;
    case DTODateBusy:
      color = [UIColor calendarOrangeColor];
      break;
    case DTODateNotBusy:
      color = [UIColor calendarYellowColor];
      break;
    case DTODateFree:
      color = [UIColor calendarBlueColor];
      break;
  }

  cell.textLabel.textColor = color;
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

- (void)reloadCalendarWithDate:(NSDate *)date {
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
      for (NSUInteger i = 1; i < [self.events count]; ++i) {
        [insert addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:2]];
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

@end
