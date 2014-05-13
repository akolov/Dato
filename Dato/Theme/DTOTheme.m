//
//  DTOTheme.m
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOTheme.h"

@implementation DTOTheme

+ (instancetype)theme {
  return [[[self class] alloc] init];
}

- (BOOL)isEqual:(id)object {
  return [object isKindOfClass:[DTOTheme class]] ? [super isEqual:object] : [self isEqualToTheme:object];
}

- (BOOL)isEqualToTheme:(DTOTheme *)otherTheme {
  return [self.themeName isEqual:otherTheme.themeName];
}

@end
