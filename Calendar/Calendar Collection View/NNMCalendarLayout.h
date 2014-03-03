//
//  NNMCalendarLayout.h
//  Calendar
//
//  Created by Alexander Kolov on 23/02/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

@import UIKit;

OBJC_EXPORT NSString *const NNMCalendarElementKindBackground;

@interface NNMCalendarLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *startDate;

@end
