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

+ (instancetype)calendarBlueColor;
+ (instancetype)calendarYellowColor;
+ (instancetype)calendarOrangeColor;
+ (instancetype)calendarRedColor;
+ (instancetype)backgroundGrayColor;
+ (instancetype)calendarBackgroundGrayColor;
+ (instancetype)textGrayColor;
+ (instancetype)textDarkGrayColor;

@end
