//
//  DTOScheduleEventViewCell.m
//  Dato
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOScheduleEventViewCell.h"
#import "DTOTheme.h"
#import "DTOThemeManager.h"

@interface DTOScheduleEventViewCell ()

@property (nonatomic, strong) UILabel *eventLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *calendarKnob;

@end

@implementation DTOScheduleEventViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
    self.indentationLevel = 0;
    self.indentationWidth = 30.0f;
    self.opaque = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.eventLabel = [UILabel autolayoutView];
    self.eventLabel.font = [UIFont lightOpenSansFontOfSize:16.0f];
    self.eventLabel.textColor = [DTOThemeManager theme].primaryTextColor;
    [self.contentView addSubview:self.eventLabel];

    self.timeLabel = [UILabel autolayoutView];
    self.timeLabel.font = [UIFont lightOpenSansFontOfSize:13.0f];
    self.timeLabel.textColor = [DTOThemeManager theme].secondaryTextColor;
    [self.contentView addSubview:self.timeLabel];

    self.calendarKnob = [UIView autolayoutView];
    self.calendarKnob.layer.cornerRadius = 4.0f;
    [self.contentView addSubview:self.calendarKnob];

    // Constraints

    [self.contentView pin:@[@"H:|-10.0-[calendarKnob]-10.0-[eventLabel]-[timeLabel]-10.0-|"] owner:self];
    [self.eventLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.timeLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
    [[self.calendarKnob pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical] setConstant:1.0f];
    [self.calendarKnob pinSize:CGSizeMake(8.0f, 8.0f) withRelation:NSLayoutRelationEqual];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  self.eventLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  self.timeLabel.textColor = [DTOThemeManager theme].secondaryTextColor;
}

@end
