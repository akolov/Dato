//
//  DTOForwardingCell.m
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOForwardingCell.h"

@implementation DTOForwardingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  return self;
}

@end
