//
//  NSCalendar+STYHelpers.m
//  Calendar
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NSCalendar+STYHelpers.h"

@implementation NSCalendar (STYHelpers)

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
  if (!date) {
    return nil;
  }

  static NSDateComponents *components;
  if (!components) {
    components = [[NSDateComponents alloc] init];
    components.day = 1;
  }
  return [self dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)nextNextDate:(NSDate *)date {
  if (!date) {
    return nil;
  }

  static NSDateComponents *components;
  if (!components) {
    components = [[NSDateComponents alloc] init];
    components.day = 2;
  }
  return [self dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)previousDate:(NSDate *)date {
  if (!date) {
    return nil;
  }

  static NSDateComponents *components;
  if (!components) {
    components = [[NSDateComponents alloc] init];
    components.day = -1;
  }
  return [self dateByAddingComponents:components toDate:date options:0];
}

@end
