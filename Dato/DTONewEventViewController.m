//
//  DTONewEventViewController.m
//  Dato
//
//  Created by Alexander Kolov on 14/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTONewEventViewController.h"

@interface DTONewEventViewController ()

- (void)didTapLeftNavigationBarButton:(id)sender;
- (void)didTapRightNavigationBarButton:(id)sender;

@end

@implementation DTONewEventViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Close" style:UIBarButtonItemStylePlain
                                           target:self action:@selector(didTapLeftNavigationBarButton:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Add" style:UIBarButtonItemStylePlain
                                            target:self action:@selector(didTapRightNavigationBarButton:)];
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

@end
