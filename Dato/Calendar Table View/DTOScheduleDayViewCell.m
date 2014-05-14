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

    CGRect frame = self.bounds;
    frame.origin.x = CGRectGetMaxX(frame) - 80.0f;
    frame.size.width = 80.0f;

    self.gradientView = [[DTOScheduleGradient alloc] initWithFrame:frame];
    self.gradientView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self.contentView addSubview:self.gradientView];
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
