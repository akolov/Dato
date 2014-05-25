//
//  DTOCalendarListController.h
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import EventKit;
@import UIKit;

@interface DTOCalendarListController : UITableViewController

- (instancetype)initWithEvent:(EKEvent *)event inStore:(EKEventStore *)eventStore;

@end
