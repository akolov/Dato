//
//  DTONewEventDataSource.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTONewEventDataSource.h"

#import "DTOCheckmarkCell.h"
#import "DTODatePickerCell.h"
#import "DTOForwardingCell.h"
#import "DTOReminderCell.h"
#import "DTORepeatCell.h"
#import "DTOTextField.h"
#import "DTOTextFieldCell.h"

#import "DTOTheme.h"
#import "DTOThemeManager.h"

@interface DTONewEventDataSource () <UITextFieldDelegate>

@property (nonatomic, strong) DTOTextFieldCell *titleCell;
@property (nonatomic, strong) DTOCheckmarkCell *allDayCell;
@property (nonatomic, strong) DTODatePickerCell *startDateCell;
@property (nonatomic, strong) DTODatePickerCell *endDateCell;
@property (nonatomic, strong) DTOForwardingCell *locationCell;
@property (nonatomic, strong) DTOForwardingCell *calendarCell;
@property (nonatomic, strong) DTOForwardingCell *inviteesCell;
@property (nonatomic, strong) DTOReminderCell *reminderCell;
@property (nonatomic, strong) DTORepeatCell *repeatCell;
@property (nonatomic, strong) EKEvent *event;

- (void)datePickerDidChangeDate:(id)sender;

@end

@implementation DTONewEventDataSource

- (instancetype)initWithEvent:(EKEvent *)event {
  self = [super init];
  if (self) {
    self.event = event;
  }
  return self;
}

- (DTOTextFieldCell *)titleCell {
  if (!_titleCell) {
    _titleCell = [[DTOTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  }

  _titleCell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  _titleCell.textField.delegate = self;
  _titleCell.textField.font = [UIFont semiBoldOpenSansFontOfSize:16.0];
  _titleCell.textField.textColor = [DTOThemeManager theme].tretiaryTextColor;
  _titleCell.indentationLevel = 1;
  _titleCell.indentationWidth = 15.0f;
  _titleCell.textField.placeholder = @"Add a title...";
  _titleCell.textField.placeholderColor = [DTOThemeManager theme].secondaryTextColor;
  _titleCell.textField.placeholderFont = [UIFont lightOpenSansFontOfSize:16.0f];

  _titleCell.textField.text = self.event.title;

  return _titleCell;
}

- (DTOCheckmarkCell *)allDayCell {
  if (!_allDayCell) {
    _allDayCell = [[DTOCheckmarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  }

  _allDayCell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  _allDayCell.textLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _allDayCell.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _allDayCell.textLabel.text = @"All-Day";

  _allDayCell.checked = self.event.allDay;

  return _allDayCell;
}

- (DTODatePickerCell *)startDateCell {
  if (!_startDateCell) {
    _startDateCell = [[DTODatePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [_startDateCell.datePicker addTarget:self action:@selector(datePickerDidChangeDate:)
                        forControlEvents:UIControlEventValueChanged];
  }

  _startDateCell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  _startDateCell.dateSelectionView.tintColor = [DTOThemeManager theme].separatorColor;
  _startDateCell.textLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _startDateCell.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _startDateCell.textLabel.text = @"Start";
  _startDateCell.indentationLevel = 1;
  _startDateCell.indentationWidth = 15.0f;

  if (self.event.startDate) {
    _startDateCell.datePicker.date = self.event.startDate;
  }

  return _startDateCell;
}

- (DTODatePickerCell *)endDateCell {
  if (!_endDateCell) {
    _endDateCell = [[DTODatePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [_endDateCell.datePicker addTarget:self action:@selector(datePickerDidChangeDate:)
                      forControlEvents:UIControlEventValueChanged];
  }

  _endDateCell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  _endDateCell.dateSelectionView.tintColor = [DTOThemeManager theme].separatorColor;
  _endDateCell.textLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _endDateCell.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _endDateCell.textLabel.text = @"End";
  _endDateCell.indentationLevel = 1;
  _endDateCell.indentationWidth = 15.0f;

  if (self.event.endDate) {
    _endDateCell.datePicker.date = self.event.endDate;
  }

  return _endDateCell;
}

- (DTOForwardingCell *)locationCell {
  if (!_locationCell) {
    _locationCell = [[DTOForwardingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
  }

  _locationCell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  _locationCell.textLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _locationCell.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _locationCell.textLabel.text = @"Location";
  _locationCell.detailTextLabel.font = [UIFont semiBoldOpenSansFontOfSize:14.0];
  _locationCell.detailTextLabel.textColor = [DTOThemeManager theme].tretiaryTextColor;

  _locationCell.detailTextLabel.text = self.event.location;

  return _locationCell;
}

- (DTOForwardingCell *)calendarCell {
  if (!_calendarCell) {
    _calendarCell = [[DTOForwardingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
  }

  _calendarCell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  _calendarCell.textLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _calendarCell.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _calendarCell.textLabel.text = @"Calendar";
  _calendarCell.detailTextLabel.font = [UIFont semiBoldOpenSansFontOfSize:14.0];
  _calendarCell.detailTextLabel.textColor = [DTOThemeManager theme].tretiaryTextColor;
  _calendarCell.knob.backgroundColor = [UIColor colorWithCGColor:self.event.calendar.CGColor];

  _calendarCell.detailTextLabel.text = self.event.calendar.title;

  return _calendarCell;
}

- (DTOForwardingCell *)inviteesCell {
  if (!_inviteesCell) {
    _inviteesCell = [[DTOForwardingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
  }

  _inviteesCell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  _inviteesCell.textLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _inviteesCell.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _inviteesCell.textLabel.text = @"Invitees";
  _inviteesCell.detailTextLabel.font = [UIFont semiBoldOpenSansFontOfSize:14.0];
  _inviteesCell.detailTextLabel.textColor = [DTOThemeManager theme].tretiaryTextColor;

  _inviteesCell.detailTextLabel.text = [self.event.attendees componentsJoinedByString:@", "];

  return _inviteesCell;
}

- (DTOReminderCell *)reminderCell {
  if (!_reminderCell) {
    _reminderCell = [[DTOReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  }

  _reminderCell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  _reminderCell.indentationLevel = 1;
  _reminderCell.indentationWidth = 15.0f;

  _reminderCell.fiveMinutesLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _reminderCell.fiveMinutesLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _reminderCell.fiveMinutesLabel.text = @"05";

  _reminderCell.tenMinutesLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _reminderCell.tenMinutesLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _reminderCell.tenMinutesLabel.text = @"10";

  _reminderCell.fifteenMinutesLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _reminderCell.fifteenMinutesLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _reminderCell.fifteenMinutesLabel.text = @"15";

  _reminderCell.thirtyMinutesLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _reminderCell.thirtyMinutesLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _reminderCell.thirtyMinutesLabel.text = @"30";

  _reminderCell.fortyFiveMinutesLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _reminderCell.fortyFiveMinutesLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _reminderCell.fortyFiveMinutesLabel.text = @"45";

  _reminderCell.sixtyMinutesLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _reminderCell.sixtyMinutesLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _reminderCell.sixtyMinutesLabel.text = @"60";

  _reminderCell.oneDayLabel.font = [UIFont lightOpenSansFontOfSize:14.0];
  _reminderCell.oneDayLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _reminderCell.oneDayLabel.text = @"1d";

  return _reminderCell;
}

- (DTORepeatCell *)repeatCell {
  if (!_repeatCell) {
    _repeatCell = [[DTORepeatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  }

  _repeatCell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  _repeatCell.indentationLevel = 1;
  _repeatCell.indentationWidth = 15.0f;

  _repeatCell.dayLabel.font = [UIFont lightOpenSansFontOfSize:14.0f];
  _repeatCell.dayLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _repeatCell.dayLabel.text = @"Day";

  _repeatCell.weekLabel.font = [UIFont lightOpenSansFontOfSize:14.0f];
  _repeatCell.weekLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _repeatCell.weekLabel.text = @"Week";

  _repeatCell.monthLabel.font = [UIFont lightOpenSansFontOfSize:14.0f];
  _repeatCell.monthLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _repeatCell.monthLabel.text = @"Month";

  _repeatCell.yearLabel.font = [UIFont lightOpenSansFontOfSize:14.0f];
  _repeatCell.yearLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  _repeatCell.yearLabel.text = @"Year";

  return _repeatCell;
}

- (NSArray *)cells {
  return @[@[self.titleCell],
           @[self.allDayCell, self.startDateCell, self.endDateCell],
           @[self.locationCell, self.calendarCell, self.inviteesCell],
           @[self.reminderCell],
           @[self.repeatCell]];
}

#pragma mark - Actions

- (void)datePickerDidChangeDate:(id)sender {
  if ([sender isEqual:self.startDateCell.datePicker]) {
    self.event.startDate = self.startDateCell.datePicker.date;
  }
  else if ([sender isEqual:self.endDateCell.datePicker]) {
    self.event.startDate = self.endDateCell.datePicker.date;
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return (NSInteger)[self.cells count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger)[self.cells[(NSUInteger)section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.cells[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
  self.event.title = textField.text;
}

@end
