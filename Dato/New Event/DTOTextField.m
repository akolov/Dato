//
//  DTOTextField.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOTextField.h"

@implementation DTOTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
  [self.placeholder drawInRect:rect withAttributes:@{NSFontAttributeName: self.placeholderFont,
                                                     NSForegroundColorAttributeName: self.placeholderColor}];
}

@end
