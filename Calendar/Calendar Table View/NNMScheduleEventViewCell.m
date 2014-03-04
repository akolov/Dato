//
//  NNMScheduleEventViewCell.m
//  Calendar
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMScheduleEventViewCell.h"

@interface NNMScheduleEventViewCell ()

@property (nonatomic, strong) UILabel *eventLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *calendarKnob;

@end

@implementation NNMScheduleEventViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor calendarGreenColor];
    self.indentationLevel = 0;
    self.indentationWidth = 30.0f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.eventLabel = [UILabel autolayoutView];
    self.eventLabel.font = [UIFont systemFontOfSize:16.0f];
    self.eventLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.eventLabel];

    self.timeLabel = [UILabel autolayoutView];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.timeLabel];

    self.calendarKnob = [UIView autolayoutView];
    self.calendarKnob.layer.cornerRadius = 5.0f;
    self.calendarKnob.layer.borderWidth = 1.0f;
    self.calendarKnob.layer.borderColor = [UIColor calendarSeparatorGreenColor].CGColor;
    [self.contentView addSubview:self.calendarKnob];

    // Constraints

    [self.contentView pin:@[@"H:|-10.0-[calendarKnob]-10.0-[eventLabel]-[timeLabel]-10.0-|"] owner:self];
    [self.eventLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.timeLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
    [self.calendarKnob pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.calendarKnob pinSize:CGSizeMake(10.0f, 10.0f) withRelation:NSLayoutRelationEqual];
  }
  return self;
}

@end
