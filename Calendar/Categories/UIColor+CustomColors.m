//
//  UIColor+CustomColors.m
//  Calendar
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

- (CGFloat)alpha {
  return CGColorGetAlpha(self.CGColor);
}

+ (instancetype)calendarGreenColor {
  return [UIColor colorWithRed:0.153f green:0.404f blue:0.286f alpha:1.000f];
}

+ (instancetype)calendarOrangeColor {
  return [UIColor colorWithRed:0.992f green:0.804f blue:0.071f alpha:1.000f];
}

+ (instancetype)calendarRedColor {
  return [UIColor colorWithRed:0.796f green:0.000f blue:0.102f alpha:1.000f];
}

+ (instancetype)calendarBackgroundGreenColor {
  return [UIColor colorWithRed:0.424f green:0.694f blue:0.624f alpha:1.000f];
}

+ (instancetype)calendarBackgroundOrangeColor {
  return [UIColor colorWithRed:0.949f green:0.525f blue:0.216f alpha:1.000f];
}

+ (instancetype)calendarBackgroundRedColor {
  return [UIColor colorWithRed:0.843f green:0.384f blue:0.345f alpha:1.000f];
}

@end
