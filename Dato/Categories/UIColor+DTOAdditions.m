//
//  UIColor+DTOAdditions.m
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "UIColor+DTOAdditions.h"

@implementation UIColor (DTOAdditions)

- (CGFloat)alpha {
  return CGColorGetAlpha(self.CGColor);
}

+ (instancetype)colorForFadeBetweenFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor
                                      atRatio:(CGFloat)ratio {
  ratio = MIN(MAX(0, ratio), 1);

  const CGFloat *firstColorComponents = CGColorGetComponents(firstColor.CGColor);
  const CGFloat *secondColorComponents = CGColorGetComponents(secondColor.CGColor);

  CGFloat interpolatedComponents[CGColorGetNumberOfComponents(firstColor.CGColor)] ;
  for (NSUInteger i = 0; i < CGColorGetNumberOfComponents(firstColor.CGColor); i++) {
    interpolatedComponents[i] = firstColorComponents[i] * (1.0f - ratio) + secondColorComponents[i] * ratio;
  }

  CGColorRef interpolatedCGColor = CGColorCreate(CGColorGetColorSpace(firstColor.CGColor), interpolatedComponents);
  UIColor *interpolatedColor = [UIColor colorWithCGColor:interpolatedCGColor];
  CGColorRelease(interpolatedCGColor);

  return interpolatedColor;
}

@end
