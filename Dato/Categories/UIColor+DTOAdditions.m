//
//  UIColor+DTOAdditions.m
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "UIColor+DTOAdditions.h"

@implementation UIColor (DTOAdditions)

- (CGFloat)alpha {
  return CGColorGetAlpha(self.CGColor);
}

@end
