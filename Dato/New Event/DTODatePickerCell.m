//
//  DTODatePickerCell.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTODatePickerCell.h"
#import "UILabel+DTOAdditions.h"

@interface DTODatePickerSelectionView : UIView

@end

@implementation DTODatePickerSelectionView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();

  [self.tintColor setFill];

  CGContextFillRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), 0.5f));
  CGContextFillRect(context, CGRectMake(0, CGRectGetMaxY(rect) - 0.5f, CGRectGetWidth(rect), 0.5f));
}

@end

@interface DTODatePickerCell ()

@property (nonatomic, assign) BOOL didUpdateConstraints;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;
@property (nonatomic, strong) UIView *dateSelectionView;

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

    self.dateSelectionView = [DTODatePickerSelectionView autolayoutView];
    [self.contentView addSubview:self.dateSelectionView];
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
    [self.contentView pin:@"V:|-15.0-[titleLabel]-[datePicker(160.0)]|" options:0 owner:self];
    [self.contentView pin:@"V:[dateSelectionView(35.0)]-61.5-|" options:0 owner:self];
    [self.datePicker pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.dateSelectionView pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];

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
