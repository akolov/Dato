//
//  NNMScheduleHeaderView.m
//  Calendar
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMScheduleHeaderView.h"

@interface NNMScheduleHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation NNMScheduleHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:reuseIdentifier];
  if (self) {
    self.titleLabel = [UILabel autolayoutView];
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    [self.contentView addSubview:self.titleLabel];

    [self pin:@[@"H:|-30.0-[titleLabel]"] owner:self];
    [self.titleLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
  }
  return self;
}

@end
