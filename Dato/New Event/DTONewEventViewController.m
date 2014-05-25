//
//  DTONewEventViewController.m
//  Dato
//
//  Created by Alexander Kolov on 14/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTONewEventViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "DTODatePickerCell.h"
#import "DTOTableHeaderView.h"
#import "DTOTheme.h"
#import "DTOThemeManager.h"
#import "DTONewEventDataSource.h"

@interface DTONewEventViewController ()

@property (nonatomic, strong) DTONewEventDataSource *dataSource;

- (void)didTapLeftNavigationBarButton:(id)sender;
- (void)didTapRightNavigationBarButton:(id)sender;

@end

@implementation DTONewEventViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"New event";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Close" style:UIBarButtonItemStylePlain
                                           target:self action:@selector(didTapLeftNavigationBarButton:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Add" style:UIBarButtonItemStylePlain
                                            target:self action:@selector(didTapRightNavigationBarButton:)];

  self.dataSource = [[DTONewEventDataSource alloc] init];

  self.tableView.dataSource = self.dataSource;
  self.tableView.backgroundColor = [DTOThemeManager theme].windowBackgroundColor;
  self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  self.tableView.separatorColor = [DTOThemeManager theme].separatorColor;
  self.tableView.separatorInset = UIEdgeInsetsMake(0, 30.0f, 0, 0);
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.showsHorizontalScrollIndicator = NO;
  [self.tableView registerClassForCellReuse:[UITableViewCell class]];
  [self.tableView registerClassForHeaderFooterViewReuse:[DTOTableHeaderView class]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)didTapLeftNavigationBarButton:(id)sender {
  [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didTapRightNavigationBarButton:(id)sender {
  [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = self.dataSource.cells[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
  if ([cell isKindOfClass:[DTODatePickerCell class]]) {
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
  }

  return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 3: {
      DTOTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DTOTableHeaderView reuseIdentifier]];
      view.titleLabel.text = @"Reminder";
      return view;
    }

    case 4: {
      DTOTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DTOTableHeaderView reuseIdentifier]];
      view.titleLabel.text = @"Repeat every";
      return view;
    }

    default:
      return nil;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 0.01f;
    default:
      return 30.0f;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  switch (section) {
    case 4:
      return 0;
    default:
      return 0.01f;
  }
}

@end
