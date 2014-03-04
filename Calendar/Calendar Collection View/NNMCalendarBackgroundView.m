//
//  NNMCalendarBackgroundView.m
//  Calendar
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMCalendarBackgroundView.h"

@interface NNMCalendarBackgroundView ()

@property (nonatomic, strong) UIView *separatorTop;
@property (nonatomic, strong) UIView *separatorBottom;

@end

@implementation NNMCalendarBackgroundView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor calendarGreenColor];

    self.separatorTop = [UIView autolayoutView];
    self.separatorTop.backgroundColor = [UIColor calendarSeparatorGreenColor];
    [self addSubview:self.separatorTop];
    [self.separatorTop pinToContainerEdge:NSLayoutAttributeTop];
    [self.separatorTop pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.separatorTop pinHeight:0.5f withRelation:NSLayoutRelationEqual];

    self.separatorBottom = [UIView autolayoutView];
    self.separatorBottom.backgroundColor = [UIColor calendarSeparatorGreenColor];
    [self addSubview:self.separatorBottom];
    [self.separatorBottom pinToContainerEdge:NSLayoutAttributeBottom];
    [self.separatorBottom pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.separatorBottom pinHeight:0.5f withRelation:NSLayoutRelationEqual];
  }
  return self;
}

@end
