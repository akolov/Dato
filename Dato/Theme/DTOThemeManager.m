//
//  DTOThemeManager.m
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOThemeManager.h"

#import "DTOTheme.h"

static DTOTheme *__theme;

@implementation DTOThemeManager

+ (void)setTheme:(DTOTheme *)theme {
  if (__theme == theme) {
    return;
  }

  __theme = theme;

  [[NSNotificationCenter defaultCenter] postNotificationName:DTOApplicationThemeChangedNotification object:__theme];
}

+ (DTOTheme *)theme {
  return __theme;
}

@end
