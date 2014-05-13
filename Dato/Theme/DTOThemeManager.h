//
//  DTOThemeManager.h
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import Foundation;

@class DTOTheme;

@interface DTOThemeManager : NSObject

+ (void)setTheme:(DTOTheme *)theme;
+ (DTOTheme *)theme;

@end
