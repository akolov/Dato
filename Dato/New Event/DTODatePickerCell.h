//
//  DTODatePickerCell.h
//  Dato
//
//  Created by Alexander Kolov on 25/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import UIKit;

@interface DTODatePickerCell : UITableViewCell

@property (nonatomic, strong, readonly) UIDatePicker *datePicker;
@property (nonatomic, strong, readonly) UIView *dateSelectionView;

@end
