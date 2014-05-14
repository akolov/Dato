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

#import "DTOTheme.h"
#import "DTOThemeManager.h"

@interface DTONewEventViewController ()

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

  self.tableView.backgroundColor = [DTOThemeManager theme].windowBackgroundColor;
  self.tableView.separatorColor = [DTOThemeManager theme].separatorColor;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.showsHorizontalScrollIndicator = NO;
  [self.tableView registerClassForCellReuse:[UITableViewCell class]];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 1;
    case 1:
      return 3;
    case 2:
      return 3;
    case 3:
      return 1;
    case 4:
      return 1;
    default:
      return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]
                                                          forIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.backgroundColor = [DTOThemeManager theme].viewBackgroundColor;
  cell.textLabel.font = [UIFont lightOpenSansFontOfSize:16.0f];
  cell.textLabel.textColor = [DTOThemeManager theme].primaryTextColor;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0:
          cell.textLabel.text = @"Add a title...";
          break;
        default:
          break;
      }
    }
      break;

    case 1: {
      cell.textLabel.font = [UIFont lightOpenSansFontOfSize:14.0f];

      switch (indexPath.row) {
        case 0:
          cell.textLabel.text = @"All-Day";
          break;
        case 1:
          cell.textLabel.text = @"Start";
          break;
        case 2:
          cell.textLabel.text = @"End";
          break;
        default:
          break;
      }
    }
      break;

    case 2: {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      cell.textLabel.font = [UIFont lightOpenSansFontOfSize:14.0f];

      switch (indexPath.row) {
        case 0:
          cell.textLabel.text = @"Location";
          break;
        case 1:
          cell.textLabel.text = @"Calendar";
          break;
        case 2:
          cell.textLabel.text = @"Invitees";
          break;
        default:
          break;
      }
    }
      break;

    default:
      break;
  }

  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 0.01f;
    default:
      return 15.0f;
  }
}

@end
