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

@interface DTOScheduleDayViewCell ()

@property (nonatomic, weak) UIView *separator;

@end

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
  [self.separator removeFromSuperview];
  self.gradientView.tintColor = nil;
  self.gradientView.numberOfComponents = 0;
  self.contentView.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  self.textLabel.font = [UIFont lightOpenSansFontOfSize:16.0f];
  self.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;
}

- (void)setShowsFullSeparator:(BOOL)showsFullSeparator {
  if (_showsFullSeparator == showsFullSeparator) {
    return;
  }

  _showsFullSeparator = showsFullSeparator;

  if (_showsFullSeparator) {
    if (self.separator) {
      return;
    }

    UIView *separator = [UIView autolayoutView];
    separator.backgroundColor = [DTOThemeManager theme].separatorColor;
    [self addSubview:separator];

    self.separator = separator;

    [self.separator pinEdge:NSLayoutAttributeLeading toView:self.contentView];
    [self.separator pinEdge:NSLayoutAttributeTrailing toView:self.contentView];
    [[self.separator pinEdge:NSLayoutAttributeBottom toView:self.contentView] setConstant:0.5f];
    [self.separator pinHeight:0.5f withRelation:NSLayoutRelationEqual];
  }
  else {
    [self.separator removeFromSuperview];
  }
}

@end
