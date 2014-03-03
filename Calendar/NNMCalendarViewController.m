//
//  NNMCalendarViewController.m
//  Calendar
//
//  Created by Alexander Kolov on 13/02/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMCalendarViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "NNMCalendarHeaderView.h"
#import "NNMCalendarLayout.h"
#import "NNMCalendarViewCell.h"

@interface NNMCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
                                         UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDateFormatter *dayFormatter;
@property (nonatomic, strong) NSDateFormatter *monthFormatter;
@property (nonatomic, strong) NNMCalendarLayout *layout;
@property (nonatomic, strong) UICollectionView *calendarView;
@property (nonatomic, strong) UITableView *scheduleView;

@end

@implementation NNMCalendarViewController

- (void)viewDidLoad {
  [super viewDidLoad];

	self.navigationController.navigationBar.barTintColor = [UIColor calendarBackgroundGreenColor];
  self.view.backgroundColor = [UIColor calendarBackgroundGreenColor];

  self.dayFormatter = [[NSDateFormatter alloc] init];
  self.dayFormatter.dateFormat =
    [NSDateFormatter dateFormatFromTemplate:@"d" options:0 locale:[NSLocale autoupdatingCurrentLocale]];
  self.monthFormatter = [[NSDateFormatter alloc] init];
  self.monthFormatter.dateFormat =
    [NSDateFormatter dateFormatFromTemplate:@"MMMM" options:0 locale:[NSLocale autoupdatingCurrentLocale]];

  // Calendar View

  self.layout = [[NNMCalendarLayout alloc] init];
  self.layout.calendar = [NSCalendar autoupdatingCurrentCalendar];
  self.layout.startDate = [NSDate date];

  self.calendarView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
  self.calendarView.backgroundColor = [UIColor calendarBackgroundGreenColor];
  self.calendarView.dataSource = self;
  [self.view addSubview:self.calendarView];

  [self.calendarView registerClass:[NNMCalendarViewCell class]
        forCellWithReuseIdentifier:[NNMCalendarViewCell reuseIdentifier]];
  [self.calendarView registerClass:[NNMCalendarHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:[NNMCalendarHeaderView reuseIdentifier]];

  // Schedule View

  CGRect scheduleFrame = self.view.bounds;

  self.scheduleView = [[UITableView alloc] initWithFrame:scheduleFrame style:UITableViewStyleGrouped];
  self.scheduleView.dataSource = self;
  self.scheduleView.rowHeight = 60.0f;
  self.scheduleView.scrollEnabled = NO;
  [self.calendarView addSubview:self.scheduleView];

  [self.scheduleView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell reuseIdentifier]];

  [self.scheduleView reloadData];
  scheduleFrame.origin.y = -self.scheduleView.contentSize.height;
  scheduleFrame.size.height = self.scheduleView.contentSize.height;
  self.scheduleView.frame = scheduleFrame;

  self.calendarView.contentInset = UIEdgeInsetsMake(scheduleFrame.size.height, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 12;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 365;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  NNMCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NNMCalendarViewCell reuseIdentifier]
                                                                        forIndexPath:indexPath];

  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.day = indexPath.item;
  components.month = indexPath.section;
  NSDate *date = [self.layout.calendar dateByAddingComponents:components toDate:self.layout.startDate options:0];

  cell.dateLabel.text = [self.dayFormatter stringFromDate:date];

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    NNMCalendarHeaderView *header =
      [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[NNMCalendarHeaderView reuseIdentifier]
                                                forIndexPath:indexPath];

    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = indexPath.item;
    components.month = indexPath.section;
    NSDate *date = [self.layout.calendar dateByAddingComponents:components toDate:self.layout.startDate options:0];

    header.textLabel.text = [self.monthFormatter stringFromDate:date];

    return header;
  }

  return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 2;
    default:
      return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]
                                                          forIndexPath:indexPath];
  cell.textLabel.text = @"test";
  return cell;
}

@end
