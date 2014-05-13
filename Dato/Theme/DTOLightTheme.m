//
//  DTOLightTheme.m
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOLightTheme.h"

@implementation DTOLightTheme

- (NSString *)themeName {
  return @"light";
}

- (UIColor *)windowBackgroundColor {
  return [DTOStyleKit backgroundGrayColor];
}

- (UIColor *)viewBackgroundColor {
  return [DTOStyleKit backgroundWhiteColor];
}

- (UIColor *)separatorColor {
  return [DTOStyleKit separatorGrayColor];
}

- (UIColor *)primaryTextColor {
  return [UIColor blackColor];
}

- (UIColor *)secondaryTextColor {
  return [DTOStyleKit foregroundGrayColor];
}

@end
