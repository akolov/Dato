//
//  UIColor+DTOAdditions.h
//  Dato
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import UIKit;

@interface UIColor (DTOAdditions)

@property (readonly) CGFloat alpha;

+ (instancetype)calendarBlueColor;
+ (instancetype)calendarYellowColor;
+ (instancetype)calendarOrangeColor;
+ (instancetype)calendarRedColor;
+ (instancetype)backgroundGrayColor;
+ (instancetype)calendarBackgroundGrayColor;
+ (instancetype)textGrayColor;
+ (instancetype)textDarkGrayColor;
+ (instancetype)separatorGrayColor;

@end
