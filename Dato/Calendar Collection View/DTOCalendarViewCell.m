//
//  DTOCalendarViewCell.m
//  Dato
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOCalendarViewCell.h"
#import "DTOTheme.h"
#import "DTOThemeManager.h"

@interface DTOCalendarViewCell ()

@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation DTOCalendarViewCell

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.dateLabel = [UILabel autolayoutView];
    self.dateLabel.font = [UIFont lightOpenSansFontOfSize:16.0f];
    self.dateLabel.textColor = [DTOThemeManager theme].primaryTextColor;
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel pinToCenter];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.dateLabel.textColor = [DTOThemeManager theme].primaryTextColor;
}

@end
