//
//  NNMScheduleViewCell.m
//  Calendar
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMScheduleViewCell.h"

@implementation NNMScheduleViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor calendarGreenColor];
    self.indentationLevel = 0;
    self.indentationWidth = 30.0f;
    self.textLabel.textColor = [UIColor whiteColor];
  }
  return self;
}

@end
