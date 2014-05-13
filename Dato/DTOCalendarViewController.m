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
#import <AXKRACExtensions/NSNotificationCenter+AXKRACExtensions.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "DTOCalendarBackgroundView.h"
#import "DTOCalendarHeaderView.h"
#import "DTOCalendarLayout.h"
#import "DTOCalendarViewCell.h"
#import "DTOScheduleDayViewCell.h"
#import "DTOScheduleEventViewCell.h"
#import "DTOScheduleGradient.h"
#import "DTOScheduleHeaderView.h"
#import "DTOTheme.h"
#import "DTODarkTheme.h"
#import "DTOLightTheme.h"
#import "DTOThemeManager.h"
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
@property (nonatomic, assign) BOOL shouldGoBack;

- (void)didTapLeftBarButton:(id)sender;

- (DTODateBusyness)dateBusyness:(NSDate *)date events:(out NSArray **)events;

- (NSArray *)eventsForDate:(NSDate *)date;
- (DTOScheduleEventViewCell *)eventCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)configureScheduleCell:(DTOScheduleDayViewCell *)cell forDate:(NSDate *)date;
- (void)expandSchedule:(UITableView *)scheduleView forDate:(NSDate *)date;

- (UIColor *)interfaceColorForDate:(NSDate *)date;

- (void)sizeScheduleToFit;
- (void)scrollCalendarToScheduleRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

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
      [self.calendarView reloadData];
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

  // Navigation

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[DTOStyleKit imageOfCogwheel]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(didTapLeftBarButton:)];
  self.navigationItem.leftBarButtonItem.tintColor = [DTOStyleKit translucentForegroundWhite];
  self.navigationController.navigationBar.barTintColor = [self interfaceColorForDate:self.today];

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
  self.calendarView.backgroundColor = [DTOThemeManager theme].windowBackgroundColor;
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
  self.scheduleView.separatorColor = [DTOThemeManager theme].separatorColor;
  self.scheduleView.separatorInset = UIEdgeInsetsMake(0, 30.0f, 0, 0);
  [self.calendarView addSubview:self.scheduleView];

  [self.scheduleView registerClass:[DTOScheduleDayViewCell class]
            forCellReuseIdentifier:[DTOScheduleDayViewCell reuseIdentifier]];
  [self.scheduleView registerClass:[DTOScheduleEventViewCell class]
            forCellReuseIdentifier:[DTOScheduleEventViewCell reuseIdentifier]];
  [self.scheduleView registerClass:[DTOScheduleHeaderView class]
forHeaderFooterViewReuseIdentifier:[DTOScheduleHeaderView reuseIdentifier]];

  self.events = [self eventsForDate:self.today];
  [self.scheduleView reloadData];

  [self sizeScheduleToFit];

  // Notifications

  [RACObserveNotificationUntilDealloc(DTOApplicationThemeChangedNotification) subscribeNext:^(NSNotification *note) {
    @strongify(self);
    self.calendarView.backgroundColor = [DTOThemeManager theme].windowBackgroundColor;
    self.scheduleView.separatorColor = [DTOThemeManager theme].separatorColor;

    [self.calendarView reloadData];
    [self.scheduleView reloadData];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)didTapLeftBarButton:(id)sender {
  if ([[DTOThemeManager theme].themeName isEqualToString:@"light"]) {
    [DTOThemeManager setTheme:[DTODarkTheme theme]];
  }
  else {
    [DTOThemeManager setTheme:[DTOLightTheme theme]];
  }
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
      cell.dateLabel.textColor = [DTOStyleKit foregroundRedColor];
      break;
    case DTODateBusy:
      cell.dateLabel.textColor = [DTOStyleKit foregroundOrangeColor];
      break;
    case DTODateNotBusy:
      cell.dateLabel.textColor = [DTOStyleKit foregroundYellowColor];
      break;
    default:
      cell.dateLabel.textColor = [DTOThemeManager theme].primaryTextColor;
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
  return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return [self.events count] != 0 ? (NSInteger)[self.events count] + 1 : 2;
    default:
      return 1;
  }

  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
          DTOScheduleDayViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
                                            forIndexPath:indexPath];
          cell.textLabel.text = @"Yesterday";
          cell.showsFullSeparator = YES;
          [self configureScheduleCell:cell forDate:[self.calendar previousDate:self.today]];
          return cell;
        }
        default: {
          if ([self.events count] != 0) {
            return [self eventCellForTableView:tableView atIndexPath:indexPath];
          }
          else {
            DTOScheduleDayViewCell *cell =
              [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
                                              forIndexPath:indexPath];
            cell.textLabel.font = [UIFont lightItalicOpenSansFontOfSize:16.0f];
            cell.textLabel.text = NSLocalizedString(@"You have no dates today...", nil);
            cell.textLabel.textColor = [DTOThemeManager theme].secondaryTextColor;
            return cell;
          }
        }
      }
    }
    case 1: {
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
    case 2: {
      DTOScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
                                        forIndexPath:indexPath];
      NSDate *date = [self.calendar nextNextDate:self.today];
      cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      [self configureScheduleCell:cell forDate:date];
      return cell;
    }
    case 3: {
      DTOScheduleDayViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[DTOScheduleDayViewCell reuseIdentifier]
                                        forIndexPath:indexPath];
      NSDate *date = [self.calendar dateWithOffset:3 fromDate:self.today];
      cell.textLabel.text = [self.weekdayFormatter stringFromDate:date];
      [self configureScheduleCell:cell forDate:date];
      return cell;
    }
    case 4: {
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
    case 1: {
      DTOScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DTOScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextDate:self.today];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 2: {
      DTOScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DTOScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextNextDate:self.today];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 3: {
      DTOScheduleHeaderView *view =
        [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DTOScheduleHeaderView reuseIdentifier]];
      NSDate *date = [self.calendar nextDate:[self.calendar nextNextDate:self.today]];
      view.titleLabel.text = [self.headerFormatter stringFromDate:date];
      return view;
    }
    case 4: {
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
    case 1:
    case 2:
    case 3:
    case 4:
      return 35.0f;
    default:
      return 0;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1 || indexPath.section == 2) {
    self.today = [self.calendar dateWithOffset:indexPath.section fromDate:self.today];

    [self.scheduleView beginUpdates];
    {
      NSArray *reload = @[[NSIndexPath indexPathForRow:1 inSection:0]];
      NSMutableArray *delete = [NSMutableArray array];
      for (NSInteger i = 2; i < [self.scheduleView numberOfRowsInSection:0]; ++i) {
        [delete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
      }

      self.events = nil;

      [self.scheduleView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationFade];
      [self.scheduleView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.scheduleView endUpdates];

    CGFloat offset = 0;
    for (NSInteger i = 1; i < 2; ++i) {
      offset += self.scheduleView.rowHeight;
      offset += CGRectGetHeight([self.scheduleView rectForHeaderInSection:i]);
      offset += CGRectGetHeight([self.scheduleView rectForFooterInSection:i]);
    }

    offset *= indexPath.section;

    [UIView animateWithDuration:0.25 animations:^{
      [self.scheduleView setContentOffset:CGPointMake(0, offset) animated:NO];
    } completion:^(BOOL finished) {
      self.title = [self.titleFormatter stringFromDate:self.today];

      [self.scheduleView setContentOffset:CGPointZero animated:NO];
      [self.scheduleView beginUpdates];
      {
        self.events = [self eventsForDate:self.today];

        NSArray *reload = @[[NSIndexPath indexPathForRow:1 inSection:0]];
        NSMutableArray *insert = [NSMutableArray array];
        for (NSUInteger i = 2; i < [self.events count]; ++i) {
          [insert addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:0]];
        }

        [self.scheduleView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationFade];
        [self.scheduleView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
      }
      [self.scheduleView endUpdates];

      [self.scheduleView reloadData];

      [UIView animateWithDuration:0.25 animations:^{
        [self sizeScheduleToFit];
        [self.calendarView setContentOffset:CGPointMake(0, -self.calendarView.contentInset.top) animated:NO];
        self.navigationController.navigationBar.barTintColor = [self interfaceColorForDate:self.today];
      }];
    }];
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView != self.calendarView) {
    return;
  }

  if (self.shouldGoBack) {
    return;
  }

  CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
  if (offset < 0) {
    UITableViewCell *cell = [self.scheduleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    CGFloat fraction = -offset / CGRectGetHeight(cell.frame);
    fraction = MAX(MIN(1, fraction), 0);
    CGFloat angle = (M_PI / 2) - ASIN(fraction);

    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0f / -500.0f;
    transform = CATransform3DRotate(transform, angle, 1, 0, 0);
    cell.contentView.layer.anchorPoint = CGPointMake(0.5, 1.0);

    CGPoint position = cell.layer.position;

    cell.contentView.layer.position = CGPointMake(position.x, position.y * 2.0f);
    cell.contentView.layer.transform = transform;

    UIColor *todayColor = [self interfaceColorForDate:self.today];
    UIColor *yesterdayColor = [self interfaceColorForDate:[self.calendar previousDate:self.today]];
    UIColor *color = [UIColor colorForFadeBetweenFirstColor:todayColor secondColor:yesterdayColor atRatio:fraction];

    self.navigationController.navigationBar.barTintColor = color;
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (scrollView != self.calendarView) {
    return;
  }

  CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;

  if (decelerate && offset <= -self.scheduleView.rowHeight) {
    self.shouldGoBack = YES;
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView != self.calendarView) {
    return;
  }

  if (self.animating) {
    return;
  }

  if (!self.shouldGoBack) {
    return;
  }

  self.shouldGoBack = NO;
  self.animating = YES;
  self.today = [self.calendar dateWithOffset:-1 fromDate:self.today];

  [self.scheduleView beginUpdates];
  {
    NSArray *reload = @[[NSIndexPath indexPathForRow:1 inSection:0]];
    NSMutableArray *delete = [NSMutableArray array];
    for (NSInteger i = 2; i < [self.scheduleView numberOfRowsInSection:0]; ++i) {
      [delete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    self.events = nil;

    [self.scheduleView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationFade];
    [self.scheduleView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationTop];
  }
  [self.scheduleView endUpdates];

  self.title = [self.titleFormatter stringFromDate:self.today];

  [self.scheduleView setContentOffset:CGPointZero animated:NO];
  [self.scheduleView beginUpdates];
  {
    self.events = [self eventsForDate:self.today];

    NSArray *reload = @[[NSIndexPath indexPathForRow:1 inSection:0]];
    NSMutableArray *insert = [NSMutableArray array];
    for (NSUInteger i = 2; i < [self.events count] + 1; ++i) {
      [insert addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:0]];
    }

    [self.scheduleView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationFade];
    [self.scheduleView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
  }
  [self.scheduleView endUpdates];

  [self.scheduleView reloadData];

  [UIView animateWithDuration:0.25 animations:^{
    [self sizeScheduleToFit];
    [self.calendarView setContentOffset:CGPointMake(0, -self.calendarView.contentInset.top) animated:NO];
    self.navigationController.navigationBar.barTintColor = [self interfaceColorForDate:self.today];
  } completion:^(BOOL innerFinished) {
    self.animating = NO;
  }];
}

#pragma mark - Private Methods

- (UIColor *)interfaceColorForDate:(NSDate *)date {
  UIColor *color;

  switch ([self dateBusyness:date events:NULL]) {
    case DTODateVeryBusy:
      color = [DTOStyleKit foregroundRedColor];
      break;
    case DTODateBusy:
      color = [DTOStyleKit foregroundOrangeColor];
      break;
    case DTODateNotBusy:
      color = [DTOStyleKit foregroundYellowColor];
      break;
    default:
      color = [DTOStyleKit foregroundBlueColor];
      break;
  }
  return color;
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
  EKEvent *event = self.events[(NSUInteger)indexPath.row - 1];
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
      color = [DTOStyleKit foregroundRedColor];
      break;
    case DTODateBusy:
      color = [DTOStyleKit foregroundOrangeColor];
      break;
    case DTODateNotBusy:
      color = [DTOStyleKit foregroundYellowColor];
      break;
    case DTODateFree:
      color = [DTOStyleKit foregroundBlueColor];
      break;
  }

  cell.textLabel.textColor = color;
  cell.gradientView.tintColor = color;
  cell.gradientView.numberOfComponents = [events count];
}

- (void)expandSchedule:(UITableView *)scheduleView forDate:(NSDate *)date {
  if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] != EKAuthorizationStatusAuthorized) {
    return;
  }

  self.today = date;
  NSArray *events = [self eventsForDate:self.today];
  NSUInteger count = (NSUInteger)[self.scheduleView numberOfRowsInSection:0];

  [self.scheduleView beginUpdates];
  {
    NSMutableArray *insert = [NSMutableArray array];
    NSMutableArray *reload = [NSMutableArray array];
    NSMutableArray *delete = [NSMutableArray array];

    [reload addObject:[NSIndexPath indexPathForRow:1 inSection:0]];

    for (NSUInteger i = 2; i < [events count] && i < count; ++i) {
      [reload addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:0]];
    }

    if (count > 0 && count < [events count]) {
      for (NSUInteger i = count; i < [events count]; ++i) {
        [insert addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:0]];
      }
    }
    else if ([events count] < count) {
      for (NSUInteger i = 2; i < count; ++i) {
        [delete addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:0]];
      }
    }

    self.events = events;

    [self.scheduleView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationBottom];
    [self.scheduleView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationFade];
    [self.scheduleView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationTop];
  }
  [self.scheduleView endUpdates];

  CGFloat offset = 0;
  for (NSInteger i = 1; i < 2; ++i) {
    offset += self.scheduleView.rowHeight;
    offset += CGRectGetHeight([self.scheduleView rectForHeaderInSection:i]);
    offset += CGRectGetHeight([self.scheduleView rectForFooterInSection:i]);
  }
  self.title = [self.titleFormatter stringFromDate:self.today];

  [self.scheduleView reloadData];

  [UIView animateWithDuration:0.25 animations:^{
    [self sizeScheduleToFit];
    [self.calendarView setContentOffset:CGPointMake(0, -self.calendarView.contentInset.top) animated:YES];
    self.navigationController.navigationBar.barTintColor = [self interfaceColorForDate:self.today];
  }];
}

- (void)sizeScheduleToFit {
  CGFloat height = 0;
  for (NSInteger i = 0; i < [self.scheduleView numberOfSections] - 2; ++i) {
    height += [self.scheduleView numberOfRowsInSection:i] * self.scheduleView.rowHeight;
    height += CGRectGetHeight([self.scheduleView rectForHeaderInSection:i]);
    height += CGRectGetHeight([self.scheduleView rectForFooterInSection:i]);
  }

  CGRect scheduleFrame = self.scheduleView.frame;
  scheduleFrame.size.height = height;
  scheduleFrame.origin.y = -scheduleFrame.size.height;
  self.scheduleView.frame = scheduleFrame;

  self.calendarView.contentInset = UIEdgeInsetsMake(scheduleFrame.size.height, 0, 0, 0);
}

- (void)scrollCalendarToScheduleRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
  CGRect rect = [self.scheduleView rectForRowAtIndexPath:indexPath];
  CGFloat height = CGRectGetHeight(self.scheduleView.frame);
  [self.calendarView setContentOffset:CGPointMake(0, -height + CGRectGetMinY(rect) - 66.0f) animated:animated];
}

@end
