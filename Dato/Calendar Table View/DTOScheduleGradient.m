//
//  DTOScheduleGradient.m
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOScheduleGradient.h"

static NSUInteger DTOMaxComponentsNumber = 8;

@implementation DTOScheduleGradient

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  if (!self.tintColor || self.tintColor.alpha == 0 || self.numberOfComponents == 0) {
    return;
  }

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGFloat const alphaStep = 0.8f / DTOMaxComponentsNumber;
  CGFloat const barWidth = CGRectGetWidth(rect) / DTOMaxComponentsNumber;

  for (NSUInteger i = 0; i <= self.numberOfComponents; ++i) {
    CGRect frame;
    frame.origin.x = CGRectGetMaxX(rect) - barWidth * i;
    frame.origin.y = CGRectGetMinY(rect);
    frame.size.width = barWidth;
    frame.size.height = CGRectGetHeight(rect);

    UIColor *color = [self.tintColor colorWithAlphaComponent:1.0f - alphaStep * i];
    [color setFill];

    CGContextFillRect(context, frame);
  }
}

- (NSUInteger)numberOfComponents {
  return MIN(_numberOfComponents, DTOMaxComponentsNumber);
}

@end
