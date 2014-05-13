//
//  DTODarkTheme.m
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTODarkTheme.h"

@implementation DTODarkTheme

- (NSString *)themeName {
  return @"dark";
}

- (UIColor *)windowBackgroundColor {
  return [DTOStyleKit backgroundBlackColor];
}

- (UIColor *)viewBackgroundColor {
  return [DTOStyleKit backgroundDarkGrayColor];
}

- (UIColor *)separatorColor {
  return [DTOStyleKit separatorDarkGrayColor];
}

- (UIColor *)primaryTextColor {
  return [UIColor whiteColor];
}

- (UIColor *)secondaryTextColor {
  return [DTOStyleKit foregroundSilverColor];
}

@end
