//
//  DTOCalendarBackgroundView.m
//  Dato
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOCalendarBackgroundView.h"
#import "DTOTheme.h"
#import "DTOThemeManager.h"

@interface DTOCalendarBackgroundView ()

@property (nonatomic, strong) UIView *separatorTop;
@property (nonatomic, strong) UIView *separatorBottom;

@end

@implementation DTOCalendarBackgroundView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
    self.opaque = YES;

    self.separatorTop = [UIView autolayoutView];
    self.separatorTop.backgroundColor = [DTOThemeManager theme].separatorColor;
    [self addSubview:self.separatorTop];
    [self.separatorTop pinToContainerEdge:NSLayoutAttributeTop];
    [self.separatorTop pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.separatorTop pinHeight:0.5f withRelation:NSLayoutRelationEqual];

    self.separatorBottom = [UIView autolayoutView];
    self.separatorBottom.backgroundColor = [DTOThemeManager theme].separatorColor;
    [self addSubview:self.separatorBottom];
    [self.separatorBottom pinToContainerEdge:NSLayoutAttributeBottom];
    [self.separatorBottom pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.separatorBottom pinHeight:0.5f withRelation:NSLayoutRelationEqual];


  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  self.separatorTop.backgroundColor = [DTOThemeManager theme].separatorColor;
  self.separatorBottom.backgroundColor = [DTOThemeManager theme].separatorColor;
}

@end
