//
//  NNMCalendarViewCell.m
//  Calendar
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMCalendarViewCell.h"

@interface NNMCalendarViewCell ()

@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation NNMCalendarViewCell

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.dateLabel = [UILabel autolayoutView];
    self.dateLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel pinToCenter];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.dateLabel.textColor = [UIColor whiteColor];
}

@end
