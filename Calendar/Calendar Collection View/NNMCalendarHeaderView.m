//
//  NNMCalendarHeaderView.m
//  Calendar
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMCalendarHeaderView.h"

@interface NNMCalendarHeaderView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation NNMCalendarHeaderView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.textLabel = [UILabel autolayoutView];
    self.textLabel.font = [UIFont systemFontOfSize:13.0f];
    self.textLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    [self addSubview:self.textLabel];
    [self pin:@[@"H:|-30.0-[textLabel]-(>=0)-|"] owner:self];
    [self.textLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
  }
  return self;
}

@end
