//
//  DTOCalendarLayout.h
//  Dato
//
//  Created by Alexander Kolov on 23/02/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import UIKit;

OBJC_EXPORT NSString *const DTOCalendarElementKindBackground;

@interface DTOCalendarLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *startDate;

@end
