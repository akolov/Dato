//
//  DTOTextFieldCell.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOTextFieldCell.h"
#import "DTOTextField.h"

@interface DTOTextFieldCell ()

@property (nonatomic, strong) NSLayoutConstraint *leadingConstraint;

@end

@implementation DTOTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.textField = [DTOTextField autolayoutView];
    [self.contentView addSubview:self.textField];
    [self.contentView pin:@"H:[textField]-15.0-|" options:0 owner:self];
    [self.textField pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];

    self.leadingConstraint = [self.textField pinToContainerEdge:NSLayoutAttributeLeading];
    self.leadingConstraint.constant = self.indentationLevel * self.indentationWidth + 15.0f;
  }
  return self;
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
