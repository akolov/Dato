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
    self.textLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.textLabel];
    [self pin:@[@"H:|-[textLabel]-(>=0)-|"] owner:self];
    [self.textLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.textLabel.textColor = [UIColor whiteColor];
}

@end
