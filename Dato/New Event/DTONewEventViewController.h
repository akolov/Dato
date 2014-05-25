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

@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) EKEventStore *eventStore;

@end
