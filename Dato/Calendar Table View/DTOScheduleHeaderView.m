//
//  DTOScheduleHeaderView.m
//  Dato
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOScheduleHeaderView.h"

@interface DTOScheduleHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DTOScheduleHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:reuseIdentifier];
  if (self) {
    self.titleLabel = [UILabel autolayoutView];
    self.titleLabel.font = [UIFont lightClavoFontOfSize:13.0f];
    self.titleLabel.textColor = [UIColor textGrayColor];
    [self.contentView addSubview:self.titleLabel];

    [self pin:@[@"H:|-30.0-[titleLabel]"] owner:self];
    [self.titleLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
  }
  return self;
}

@end