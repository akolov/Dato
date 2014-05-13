//
//  DTOScheduleDayViewCell.m
//  Dato
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOScheduleDayViewCell.h"
#import "DTOScheduleGradient.h"
#import "DTOTheme.h"
#import "DTOThemeManager.h"

@implementation DTOScheduleDayViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = nil;
    self.contentView.clipsToBounds = YES;
    self.contentView.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
    self.opaque = NO;
    self.indentationLevel = 0;
    self.indentationWidth = 30.0f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font = [UIFont lightOpenSansFontOfSize:16.0f];
    self.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;

    self.gradientView = [DTOScheduleGradient autolayoutView];
    [self.contentView addSubview:self.gradientView];

    [self.contentView pin:@"H:[gradientView(80.0)]|" options:0 owner:self];
    [self.gradientView pinToFillContainerOnAxis:UILayoutConstraintAxisVertical];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.gradientView setNeedsDisplay];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.gradientView.tintColor = nil;
  self.gradientView.numberOfComponents = 0;
  self.contentView.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  self.textLabel.font = [UIFont lightOpenSansFontOfSize:16.0f];
  self.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;
}

@end
