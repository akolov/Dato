//
//  DTOForwardingCell.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOForwardingCell.h"

@interface DTOForwardingCell ()

@property (nonatomic, strong) UIView *knob;

@end

@implementation DTOForwardingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.knob removeFromSuperview], self.knob = nil;
}

- (UIView *)knob {
  if (!_knob) {
    _knob = [UIView autolayoutView];
    _knob.layer.cornerRadius = 4.0f;
    [self.contentView addSubview:_knob];

    [_knob pinSize:CGSizeMake(8.0f, 8.0f) withRelation:NSLayoutRelationEqual];
    [_knob pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [[_knob pinToContainerEdge:NSLayoutAttributeLeading] setConstant:11.0f];
  }

  return _knob;
}

@end
