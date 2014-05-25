//
//  DTOReminderCell.h
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import UIKit;

@interface DTOReminderCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *fiveMinutesLabel;
@property (nonatomic, strong, readonly) UILabel *tenMinutesLabel;
@property (nonatomic, strong, readonly) UILabel *fifteenMinutesLabel;
@property (nonatomic, strong, readonly) UILabel *thirtyMinutesLabel;
@property (nonatomic, strong, readonly) UILabel *fortyFiveMinutesLabel;
@property (nonatomic, strong, readonly) UILabel *sixtyMinutesLabel;
@property (nonatomic, strong, readonly) UILabel *oneDayLabel;

@end
