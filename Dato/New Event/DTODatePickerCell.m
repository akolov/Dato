//
//  DTODatePickerCell.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTODatePickerCell.h"

@interface DTODatePickerCell ()

@property (nonatomic, assign) BOOL didUpdateConstraints;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;

@end

@implementation DTODatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.titleLabel = [UILabel autolayoutView];
    [self.contentView addSubview:self.titleLabel];

    self.datePicker = [UIDatePicker autolayoutView];
    [self.contentView addSubview:self.datePicker];
  }
  return self;
}

- (void)updateConstraints {
  if (!self.didUpdateConstraints) {
    self.didUpdateConstraints = YES;

    CGRect bounds = self.contentView.bounds;
    bounds.size.height = 300.0f;
    self.contentView.bounds = bounds;

    [self.contentView pin:@"H:[titleLabel]-(>=15.0)-|" options:0 owner:self];
    [self.datePicker pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView pin:@"V:|-15.0-[titleLabel]-[datePicker(160.0)]|" options:0 owner:self];

    self.leadingConstraint = [self.titleLabel pinToContainerEdge:NSLayoutAttributeLeading];
    self.leadingConstraint.constant = self.indentationLevel * self.indentationWidth + 15.0f;
  }

  [super updateConstraints];
}

- (UILabel *)textLabel {
  return self.titleLabel;
}

- (void)setIndentationLevel:(NSInteger)indentationLevel {
  [super setIndentationLevel:indentationLevel];
  self.leadingConstraint.constant = self.indentationLevel * self.indentationWidth + 15.0f;
}

- (void)setIndentationWidth:(CGFloat)indentationWidth {
  [super setIndentationWidth:indentationWidth];
  self.leadingConstraint.constant = self.indentationLevel * self.indentationWidth + 15.0f;
}

@end
