//
//  UILabel+DTOAdditions.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "UILabel+DTOAdditions.h"

#import <JRSwizzle/JRSwizzle.h>

#import "UIView+DTOAdditions.h"

#import "DTOTheme.h"
#import "DTOThemeManager.h"

@implementation UILabel (DTOAdditions)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSError *error;

    if (![self jr_swizzleMethod:@selector(setFont:) withMethod:@selector(dto_setFont:) error:&error]) {
      ErrorLog(error.localizedDescription);
    }

    if (![self jr_swizzleMethod:@selector(setTextColor:) withMethod:@selector(dto_setTextColor:) error:&error]) {
      ErrorLog(error.localizedDescription);
    }

    if (![self jr_swizzleMethod:@selector(willMoveToSuperview:) withMethod:@selector(dto_willMoveToSuperview:) error:&error]) {
      ErrorLog(error.localizedDescription);
    }
  });
}

- (void)dto_setFont:(UIFont *)font {
  if ([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
      [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
      [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")]) {
    [self dto_setFont:[UIFont lightOpenSansFontOfSize:18.0f]];
  }
  else {
    [self dto_setFont:font];
  }
}

- (void)dto_setTextColor:(UIColor *)textColor {
  if ([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
     [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
     [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")]) {
    [self dto_setTextColor:[DTOThemeManager theme].primaryTextColor];
  }
  else {
    [self dto_setTextColor:textColor];
  }
}

- (void)dto_willMoveToSuperview:(UIView *)newSuperview {
  [self dto_setFont:self.font];
  [self dto_setTextColor:self.textColor];
  [self dto_willMoveToSuperview:newSuperview];
}

@end
