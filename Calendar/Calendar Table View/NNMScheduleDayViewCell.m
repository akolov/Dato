//
//  NNMScheduleDayViewCell.m
//  Calendar
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMScheduleDayViewCell.h"

static CGFloat NNMGradientComponentWidth = 10.0f;

@implementation NNMScheduleDayViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.125f];
    self.opaque = NO;
    self.indentationLevel = 0;
    self.indentationWidth = 30.0f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.textColor = [UIColor whiteColor];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.gradientBaseColor = nil;
  self.gradientComponents = 0;
}

- (void)drawRect:(CGRect)rect {
  if (!self.gradientBaseColor || self.gradientBaseColor.alpha == 0 || self.gradientComponents == 0) {
    return;
  }

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGFloat alphaStep = 0.8f / self.gradientComponents;

  for (NSUInteger i = 0; i <= self.gradientComponents; ++i) {
    CGRect frame;
    frame.origin.x = CGRectGetMaxX(rect) - NNMGradientComponentWidth * i;
    frame.origin.y = CGRectGetMinY(rect);
    frame.size.width = NNMGradientComponentWidth;
    frame.size.height = CGRectGetHeight(rect);

    UIColor *color = [self.gradientBaseColor colorWithAlphaComponent:1.0f - alphaStep * i];
    [color setFill];

    CGContextFillRect(context, frame);
  }
}

@end
