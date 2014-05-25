//
//  DTORepeatCell.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTORepeatCell.h"

@interface DTORepeatCell ()

@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *trailingConstraint;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;

@end

@implementation DTORepeatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.dayLabel = [UILabel autolayoutView];
    self.dayLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.dayLabel];

    self.weekLabel = [UILabel autolayoutView];
    self.weekLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.weekLabel];

    self.monthLabel = [UILabel autolayoutView];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.monthLabel];

    self.yearLabel = [UILabel autolayoutView];
    self.yearLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.yearLabel];

    [self.contentView pin:@"H:[dayLabel(50.0)][weekLabel][monthLabel(==weekLabel)]"
     "[yearLabel(==dayLabel)]" options:NSLayoutFormatAlignAllCenterY owner:self];
    [self.dayLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];

    self.leadingConstraint = [self.dayLabel pinToContainerEdge:NSLayoutAttributeLeading];
    self.leadingConstraint.constant = self.indentationLevel * self.indentationWidth + 15.0f;
    self.trailingConstraint = [self.yearLabel pinToContainerEdge:NSLayoutAttributeTrailing];
    self.trailingConstraint.constant = -self.leadingConstraint.constant;
  }
  return self;
}

- (void)setIndentationLevel:(NSInteger)indentationLevel {
  [super setIndentationLevel:indentationLevel];
  self.leadingConstraint.constant = self.indentationLevel * self.indentationWidth + 15.0f;
  self.trailingConstraint.constant = -self.leadingConstraint.constant;
}

- (void)setIndentationWidth:(CGFloat)indentationWidth {
  [super setIndentationWidth:indentationWidth];
  self.leadingConstraint.constant = self.indentationLevel * self.indentationWidth + 15.0f;
  self.trailingConstraint.constant = -self.leadingConstraint.constant;
}

@end
