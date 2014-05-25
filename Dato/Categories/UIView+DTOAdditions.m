//
//  UIView+DTOAdditions.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "UIView+DTOAdditions.h"

@implementation UIView (DTOAdditions)

- (BOOL)view:(UIView *)view hasSuperviewOfClass:(Class)class {
  if (view.superview) {
    if ([view.superview isKindOfClass:class]) {
      return YES;
    }
    return [self view:view.superview hasSuperviewOfClass:class];
  }
  return NO;
}

@end
