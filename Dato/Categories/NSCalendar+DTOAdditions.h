//
//  NSCalendar+DTOAdditions.h
//  Dato
//
//  Created by Alexander Kolov on 04/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import Foundation;

@interface NSCalendar (DTOAdditions)

- (BOOL)isDifferentWeek:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (BOOL)isDifferentMonth:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSDate *)today;
- (NSDate *)nextDate:(NSDate *)date;
- (NSDate *)nextNextDate:(NSDate *)date;
- (NSDate *)previousDate:(NSDate *)date;
- (NSDate *)dateWithOffset:(NSInteger)offset fromDate:(NSDate *)date;

@end
