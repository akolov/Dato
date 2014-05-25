//
//  DTORepeatCell.h
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import UIKit;

@interface DTORepeatCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *dayLabel;
@property (nonatomic, strong, readonly) UILabel *weekLabel;
@property (nonatomic, strong, readonly) UILabel *monthLabel;
@property (nonatomic, strong, readonly) UILabel *yearLabel;

@end
