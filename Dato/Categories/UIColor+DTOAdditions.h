//
//  UIColor+DTOAdditions.h
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

@import UIKit;

@interface UIColor (DTOAdditions)

@property (readonly) CGFloat alpha;

+ (instancetype)colorForFadeBetweenFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor
                                      atRatio:(CGFloat)ratio;

@end
