//
//  UIColor+CustomColors.h
//  Calendar
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

@import UIKit;

@interface UIColor (CustomColors)

@property (readonly) CGFloat alpha;

+ (instancetype)calendarGreenColor;
+ (instancetype)calendarOrangeColor;
+ (instancetype)calendarRedColor;
+ (instancetype)calendarBackgroundGreenColor;
+ (instancetype)calendarBackgroundOrangeColor;
+ (instancetype)calendarBackgroundRedColor;

@end
