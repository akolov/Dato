//
//  DTOCalendarBackgroundView.m
//  Dato
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOCalendarBackgroundView.h"

@interface DTOCalendarBackgroundView ()

@property (nonatomic, strong) UIView *separatorTop;
@property (nonatomic, strong) UIView *separatorBottom;

@end

@implementation DTOCalendarBackgroundView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor calendarBackgroundGrayColor];
    self.opaque = NO;

    self.separatorTop = [UIView autolayoutView];
    self.separatorTop.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    [self addSubview:self.separatorTop];
    [self.separatorTop pinToContainerEdge:NSLayoutAttributeTop];
    [self.separatorTop pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.separatorTop pinHeight:0.5f withRelation:NSLayoutRelationEqual];

    self.separatorBottom = [UIView autolayoutView];
    self.separatorBottom.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    [self addSubview:self.separatorBottom];
    [self.separatorBottom pinToContainerEdge:NSLayoutAttributeBottom];
    [self.separatorBottom pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.separatorBottom pinHeight:0.5f withRelation:NSLayoutRelationEqual];
  }
  return self;
}

@end
