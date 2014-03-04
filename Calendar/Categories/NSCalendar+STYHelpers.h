//
//  NSCalendar+STYHelpers.h
//  Calendar
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

@import Foundation;

@interface NSCalendar (STYHelpers)

- (BOOL)isDifferentWeek:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (BOOL)isDifferentMonth:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSDate *)nextDate:(NSDate *)date;
- (NSDate *)nextNextDate:(NSDate *)date;
- (NSDate *)previousDate:(NSDate *)date;

@end
