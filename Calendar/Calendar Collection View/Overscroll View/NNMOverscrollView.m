//
//  NNMOverscrollView.m
//  Calendar
//
//  Created by Alexander Kolov on 27/04/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMOverscrollView.h"

@interface NNMOverscrollView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation NNMOverscrollView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.titleLabel = [UILabel autolayoutView];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self pin:@"H:|-8.0-[titleLabel]" options:0 owner:self];
    [self.titleLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
  }
  return self;
}

@end
