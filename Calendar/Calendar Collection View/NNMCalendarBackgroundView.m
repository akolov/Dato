//
//  NNMCalendarBackgroundView.m
//  Calendar
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMCalendarBackgroundView.h"

@implementation NNMCalendarBackgroundView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor calendarGreenColor];
  }
  return self;
}

@end
