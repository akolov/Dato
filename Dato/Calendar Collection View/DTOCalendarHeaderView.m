//
//  DTOCalendarHeaderView.m
//  Dato
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOCalendarHeaderView.h"

@interface DTOCalendarHeaderView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation DTOCalendarHeaderView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.textLabel = [UILabel autolayoutView];
    self.textLabel.font = [UIFont lightClavoFontOfSize:13.0f];
    self.textLabel.textColor = [UIColor textGrayColor];
    [self addSubview:self.textLabel];

    [self pin:@[@"H:|-30.0-[textLabel]-(>=0)-|"] owner:self];
    [self.textLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
  }
  return self;
}

@end
