//
//  UIFont+DTOAdditions.m
//  Dato
//
//  Created by Alexander Kolov on 11/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "UIFont+DTOAdditions.h"

@implementation UIFont (DTOAdditions)

+ (instancetype)lightClavoFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"Clavo-Light" size:size];
}

+ (instancetype)lightOpenSansFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans-Light" size:size];
}

+ (instancetype)lightItalicOpenSansFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSansLight-Italic" size:size];
}

+ (instancetype)semiBoldOpenSansFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans-Semibold" size:size];
}

@end
