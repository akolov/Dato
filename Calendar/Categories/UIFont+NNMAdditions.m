//
//  UIFont+NNMAdditions.m
//  Calendar
//
//  Created by Alexander Kolov on 11/05/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "UIFont+NNMAdditions.h"

@implementation UIFont (NNMAdditions)

+ (instancetype)lightClavoFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"Clavo-Light" size:size];
}

+ (instancetype)lightOpenSansFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans-Light" size:size];
}

+ (instancetype)semiBoldOpenSansFontOfSize:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans-Semibold" size:size];
}

@end
