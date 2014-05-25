//
//  DTOCalendarListController.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOCalendarListController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "DTOEventViewCell.h"
#import "DTOTheme.h"
#import "DTOThemeManager.h"

@interface DTOCalendarListController ()

@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) NSArray *calendars;

@end

@implementation DTOCalendarListController

- (instancetype)initWithEvent:(EKEvent *)event inStore:(EKEventStore *)eventStore {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.event = event;
    self.eventStore = eventStore;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Calendar";

  self.tableView.backgroundColor = [DTOThemeManager theme].windowBackgroundColor;
  self.tableView.separatorColor = [DTOThemeManager theme].separatorColor;
  self.tableView.separatorInset = UIEdgeInsetsMake(0, 30.0f, 0, 0);
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.showsHorizontalScrollIndicator = NO;
  [self.tableView registerClassForCellReuse:[DTOEventViewCell class]];
}

#pragma mark - Properties

- (NSArray *)calendars {
  if (!_calendars) {
    _calendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
  }
  return _calendars;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger)[self.calendars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  DTOEventViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DTOEventViewCell reuseIdentifier]
                                                           forIndexPath:indexPath];

  EKCalendar *calendar = self.calendars[(NSUInteger)indexPath.row];
  cell.textLabel.text = calendar.title;
  cell.calendarKnob.backgroundColor = [UIColor colorWithCGColor:calendar.CGColor];

  BOOL selected = [self.event.calendar isEqual:calendar];

  cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  EKCalendar *calendar = self.calendars[(NSUInteger)indexPath.row];
  self.event.calendar = calendar;

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
