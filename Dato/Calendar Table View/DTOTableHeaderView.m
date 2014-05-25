//
//  DTOTableHeaderView.m
//  Dato
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOTableHeaderView.h"

#import "DTOTheme.h"
#import "DTOThemeManager.h"

@interface DTOTableHeaderView ()

@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DTOTableHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:reuseIdentifier];
  if (self) {
    self.titleLabel = [UILabel autolayoutView];
    self.titleLabel.font = [UIFont lightClavoFontOfSize:13.0f];
    self.titleLabel.textColor = [DTOThemeManager theme].secondaryTextColor;
    [self.contentView addSubview:self.titleLabel];

    self.leadingConstraint = [self.titleLabel pinToContainerEdge:NSLayoutAttributeLeading];
    self.leadingConstraint.constant = 30.0f;

    [self pin:@"H:[titleLabel]-(>=0)-|" options:0 owner:self];
    [self.titleLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.titleLabel.textColor = [DTOThemeManager theme].secondaryTextColor;
}

@end
