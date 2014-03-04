//
//  NNMScheduleEventViewCell.h
//  Calendar
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

@import UIKit;

@interface NNMScheduleEventViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *eventLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIView *calendarKnob;

@end
