//
//  DTONewEventViewController.h
//  Dato
//
//  Created by Alexander Kolov on 14/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import EventKit;
@import UIKit;

@interface DTONewEventViewController : UITableViewController

- (instancetype)initWithEvent:(EKEvent *)event inStore:(EKEventStore *)eventStore calendar:(NSCalendar *)calendar;

@end
