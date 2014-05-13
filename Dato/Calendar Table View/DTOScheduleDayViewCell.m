//
//  DTOScheduleDayViewCell.m
//  Dato
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOScheduleDayViewCell.h"

static CGFloat DTOGradientComponentWidth = 10.0f;

@implementation DTOScheduleDayViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [DTOStyleKit backgroundWhiteColor];
    self.opaque = NO;
    self.indentationLevel = 0;
    self.indentationWidth = 30.0f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font = [UIFont lightOpenSansFontOfSize:16.0f];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.gradientBaseColor = nil;
  self.gradientComponents = 0;
  self.textLabel.textColor = [UIColor blackColor];
}

- (void)drawRect:(CGRect)rect {
  if (!self.gradientBaseColor || self.gradientBaseColor.alpha == 0 || self.gradientComponents == 0) {
    return;
  }

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGFloat alphaStep = 0.8f / self.gradientComponents;

  for (NSUInteger i = 0; i <= self.gradientComponents; ++i) {
    CGRect frame;
    frame.origin.x = CGRectGetMaxX(rect) - DTOGradientComponentWidth * i;
    frame.origin.y = CGRectGetMinY(rect);
    frame.size.width = DTOGradientComponentWidth;
    frame.size.height = CGRectGetHeight(rect);

    UIColor *color = [self.gradientBaseColor colorWithAlphaComponent:1.0f - alphaStep * i];
    [color setFill];

    CGContextFillRect(context, frame);
  }
}

@end
