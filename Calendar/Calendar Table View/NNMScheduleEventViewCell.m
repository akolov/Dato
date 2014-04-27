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
@property (nonatomic, strong) UIView *calendarOuterKnob;
@property (nonatomic, strong) UIView *calendarKnob;

@end

@implementation NNMScheduleEventViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.125f];
    self.indentationLevel = 0;
    self.indentationWidth = 30.0f;
    self.opaque = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.eventLabel = [UILabel autolayoutView];
    self.eventLabel.font = [UIFont systemFontOfSize:16.0f];
    self.eventLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.eventLabel];

    self.timeLabel = [UILabel autolayoutView];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.timeLabel];

    self.calendarOuterKnob = [UIView autolayoutView];
    self.calendarOuterKnob.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.calendarOuterKnob.layer.cornerRadius = 6.0f;
    [self.contentView addSubview:self.calendarOuterKnob];

    self.calendarKnob = [UIView autolayoutView];
    self.calendarKnob.layer.cornerRadius = 5.0f;
    [self.calendarOuterKnob addSubview:self.calendarKnob];

    // Constraints

    [self.contentView pin:@[@"H:|-10.0-[calendarOuterKnob]-10.0-[eventLabel]-[timeLabel]-10.0-|"] owner:self];
    [self.eventLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.timeLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
    [self.calendarOuterKnob pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.calendarKnob pinToCenter];
    [self.calendarOuterKnob pinSize:CGSizeMake(12.0f, 12.0f) withRelation:NSLayoutRelationEqual];
    [self.calendarKnob pinSize:CGSizeMake(10.0f, 10.0f) withRelation:NSLayoutRelationEqual];
  }
  return self;
}

@end
