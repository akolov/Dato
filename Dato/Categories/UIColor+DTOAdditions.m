//
//  UIColor+DTOAdditions.m
//  Dato
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "UIColor+DTOAdditions.h"

@implementation UIColor (DTOAdditions)

- (CGFloat)alpha {
  return CGColorGetAlpha(self.CGColor);
}

+ (instancetype)calendarBlueColor {
  return [UIColor colorWithRed:0.078f green:0.506f blue:0.984f alpha:1.000f];
}

+ (instancetype)calendarYellowColor {
  return [UIColor colorWithRed:0.992f green:0.745f blue:0.196f alpha:1.000f];
}

+ (instancetype)calendarOrangeColor {
  return [UIColor colorWithRed:0.988f green:0.502f blue:0.239f alpha:1.000f];
}

+ (instancetype)calendarRedColor {
  return [UIColor colorWithRed:0.984f green:0.333f blue:0.345f alpha:1.000f];
}

+ (instancetype)backgroundGrayColor {
  return [UIColor colorWithWhite:0.929f alpha:1.000f];
}

+ (instancetype)calendarBackgroundGrayColor {
  return [UIColor colorWithWhite:0.988f alpha:1.000f];
}

+ (instancetype)textGrayColor {
  return [UIColor colorWithWhite:0.506f alpha:1.000f];
}

+ (instancetype)textDarkGrayColor {
  return [UIColor colorWithWhite:0.224f alpha:1.000f];
}

+ (instancetype)separatorGrayColor {
  return [UIColor colorWithWhite:0.878f alpha:1.000f];
}

@end
