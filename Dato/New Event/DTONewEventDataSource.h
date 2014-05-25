//
//  DTONewEventDataSource.h
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import Foundation;

@class DTOCheckmarkCell;
@class DTODatePickerCell;
@class DTOForwardingCell;
@class DTOReminderCell;
@class DTORepeatCell;
@class DTOTextFieldCell;

@interface DTONewEventDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong, readonly) DTOTextFieldCell *titleCell;
@property (nonatomic, strong, readonly) DTOCheckmarkCell *allDayCell;
@property (nonatomic, strong, readonly) DTODatePickerCell *startDateCell;
@property (nonatomic, strong, readonly) DTODatePickerCell *endDateCell;
@property (nonatomic, strong, readonly) DTOForwardingCell *locationCell;
@property (nonatomic, strong, readonly) DTOForwardingCell *calendarCell;
@property (nonatomic, strong, readonly) DTOForwardingCell *inviteesCell;
@property (nonatomic, strong, readonly) DTOReminderCell *reminderCell;
@property (nonatomic, strong, readonly) DTORepeatCell *repeatCell;
@property (nonatomic, strong, readonly) NSArray *cells;

@end
