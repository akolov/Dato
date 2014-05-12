//
//  NSCalendar+DTOAdditions.m
//  Dato
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "NSCalendar+DTOAdditions.h"

@implementation NSCalendar (DTOAdditions)

- (BOOL)isDifferentWeek:(NSDate *)fromDate toDate:(NSDate *)toDate {
  if (!fromDate || !toDate) {
    return NO;
  }

  NSDateComponents *fromComponents = [self components:NSCalendarUnitWeekOfYear fromDate:fromDate];
  NSDateComponents *toComponents = [self components:NSCalendarUnitWeekOfYear fromDate:toDate];
  return fromComponents.weekOfYear != toComponents.weekOfYear;
}

- (BOOL)isDifferentMonth:(NSDate *)fromDate toDate:(NSDate *)toDate {
  if (!fromDate || !toDate) {
    return NO;
  }

  NSDateComponents *fromComponents = [self components:NSCalendarUnitMonth fromDate:fromDate];
  NSDateComponents *toComponents = [self components:NSCalendarUnitMonth fromDate:toDate];
  return fromComponents.month != toComponents.month;
}

- (NSDate *)today {
  NSDateComponents *components =
    [self components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
  return [self dateFromComponents:components];
}

- (NSDate *)nextDate:(NSDate *)date {
  return [self dateWithOffset:1 fromDate:date];
}

- (NSDate *)nextNextDate:(NSDate *)date {
  return [self dateWithOffset:2 fromDate:date];
}

- (NSDate *)previousDate:(NSDate *)date {
  return [self dateWithOffset:-1 fromDate:date];
}

- (NSDate *)dateWithOffset:(NSInteger)offset fromDate:(NSDate *)date {
  if (!date) {
    return nil;
  }

  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.day = offset;
  return [self dateByAddingComponents:components toDate:date options:0];
}

@end
