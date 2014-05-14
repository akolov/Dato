//
//  DTOSchedulePullBackCell.m
//  Dato
//
//  Created by Alexander Kolov on 14/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOSchedulePullBackCell.h"
#import "DTOTheme.h"
#import "DTOThemeManager.h"

@interface DTOSchedulePullBackCell ()

@property (nonatomic, weak) UIView *separator;

@end

@implementation DTOSchedulePullBackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = nil;
    self.contentView.clipsToBounds = YES;
    self.contentView.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
    self.textLabel.font = [UIFont lightOpenSansFontOfSize:16.0f];
    self.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;

    UIView *separator = [UIView autolayoutView];
    separator.backgroundColor = [DTOThemeManager theme].separatorColor;
    [self addSubview:separator];

    self.separator = separator;

    [self.separator pinEdge:NSLayoutAttributeLeading toView:self.contentView];
    [self.separator pinEdge:NSLayoutAttributeTrailing toView:self.contentView];
    [[self.separator pinEdge:NSLayoutAttributeBottom toView:self.contentView] setConstant:0.5f];
    [self.separator pinHeight:0.5f withRelation:NSLayoutRelationEqual];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.contentView.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
}

@end
