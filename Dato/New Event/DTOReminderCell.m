//
//  DTOReminderCell.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOReminderCell.h"

@interface DTOReminderCell ()

@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *trailingConstraint;
@property (nonatomic, strong) UILabel *fiveMinutesLabel;
@property (nonatomic, strong) UILabel *tenMinutesLabel;
@property (nonatomic, strong) UILabel *fifteenMinutesLabel;
@property (nonatomic, strong) UILabel *thirtyMinutesLabel;
@property (nonatomic, strong) UILabel *fortyFiveMinutesLabel;
@property (nonatomic, strong) UILabel *sixtyMinutesLabel;
@property (nonatomic, strong) UILabel *oneDayLabel;

@end

@implementation DTOReminderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.fiveMinutesLabel = [UILabel autolayoutView];
    self.fiveMinutesLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.fiveMinutesLabel];

    self.tenMinutesLabel = [UILabel autolayoutView];
    self.tenMinutesLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tenMinutesLabel];

    self.fifteenMinutesLabel = [UILabel autolayoutView];
    self.fifteenMinutesLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.fifteenMinutesLabel];

    self.thirtyMinutesLabel = [UILabel autolayoutView];
    self.thirtyMinutesLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.thirtyMinutesLabel];

    self.fortyFiveMinutesLabel = [UILabel autolayoutView];
    self.fortyFiveMinutesLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.fortyFiveMinutesLabel];

    self.sixtyMinutesLabel = [UILabel autolayoutView];
    self.sixtyMinutesLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.sixtyMinutesLabel];

    self.oneDayLabel = [UILabel autolayoutView];
    self.oneDayLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.oneDayLabel];

    [self.contentView pin:@"H:[fiveMinutesLabel(26.0)][tenMinutesLabel]"
     "[fifteenMinutesLabel(==tenMinutesLabel)][thirtyMinutesLabel(==tenMinutesLabel)]"
     "[fortyFiveMinutesLabel(==tenMinutesLabel)][sixtyMinutesLabel(==tenMinutesLabel)]"
     "[oneDayLabel(==fiveMinutesLabel)]" options:NSLayoutFormatAlignAllCenterY owner:self];
    [self.fiveMinutesLabel pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];

    self.leadingConstraint = [self.fiveMinutesLabel pinToContainerEdge:NSLayoutAttributeLeading];
    self.leadingConstraint.constant = self.indentationLevel * self.indentationWidth + 15.0f;
    self.trailingConstraint = [self.oneDayLabel pinToContainerEdge:NSLayoutAttributeTrailing];
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
