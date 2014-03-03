//
//  NNMCalendarLayout.m
//  Calendar
//
//  Created by Alexander Kolov on 23/02/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

#import "NNMConfig.h"
#import "NNMCalendarLayout.h"

#import "NNMCalendarBackgroundView.h"
#import "NNMLayoutAttributeStorage.h"

NSString *const NNMCalendarElementKindBackground = @"NNMCalendarElementKindBackground";

@interface NNMCalendarLayout ()

@property (nonatomic, strong) NNMLayoutAttributeStorage *itemLayoutAttributes;
@property (nonatomic, strong) NNMLayoutAttributeStorage *headerLayoutAttributes;
@property (nonatomic, strong) NNMLayoutAttributeStorage *backgroundLayoutAttributes;
@property (nonatomic, strong) NSArray *previousLayoutAttributes;
@property (nonatomic, assign) CGRect previousLayoutRect;

- (void)placeBlocksToRect:(CGRect)rect;
- (void)placeBlocksToIndexPath:(NSIndexPath *)toIndexPath;
- (void)placeBackgroundsToRect:(CGRect)rect;

- (NSDate *)nextDate:(NSDate *)date;
- (BOOL)isDifferentWeek:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (BOOL)isDifferentMonth:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end

@implementation NNMCalendarLayout

- (instancetype)init {
  self = [super init];
  if (self) {
    self.itemSize = CGSizeMake(320.0f / 7.0f, 320.0f / 7.0f);
    self.headerReferenceSize = CGSizeMake(320.0f, 46.0f);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 20.0f, 0);
    self.itemLayoutAttributes = [[NNMLayoutAttributeStorage alloc] init];
    self.headerLayoutAttributes = [[NNMLayoutAttributeStorage alloc] init];
    self.backgroundLayoutAttributes = [[NNMLayoutAttributeStorage alloc] init];

    [self registerClass:[NNMCalendarBackgroundView class] forDecorationViewOfKind:NNMCalendarElementKindBackground];
  }
  return self;
}

#pragma mark - UICollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  if (CGRectEqualToRect(rect, self.previousLayoutRect)) {
    return self.previousLayoutAttributes;
  }

  self.previousLayoutRect = rect;

  [self placeBlocksToRect:rect];

  BOOL backwards = CGRectGetMinY(rect) < CGRectGetMinY(self.previousLayoutRect);
  NSEnumerationOptions options = backwards ? NSEnumerationReverse : 0;

  NSMutableArray *attributesInRect = [NSMutableArray array];

  [self.itemLayoutAttributes enumerateSectionsWithOptions:options usingBlock:^(NSArray *section, NSUInteger idx, BOOL *stop) {
    UICollectionViewLayoutAttributes *first = [section firstObject];
    UICollectionViewLayoutAttributes *last = [section lastObject];

    if (CGRectIntersectsRect(rect, first.frame) || CGRectIntersectsRect(rect, last.frame)) {
      [attributesInRect addObjectsFromArray:section];
    }
    else if (backwards && CGRectGetMinY(last.frame) < CGRectGetMaxY(rect)) {
      *stop = YES;
    }
    else if (!backwards && CGRectGetMinY(first.frame) > CGRectGetMaxY(rect)) {
      *stop = YES;
    }
  }];

  [self.headerLayoutAttributes enumerateSectionsWithOptions:options usingBlock:^(NSArray *section, NSUInteger idx, BOOL *stop) {
    UICollectionViewLayoutAttributes *last = [section lastObject];

    if (CGRectIntersectsRect(rect, last.frame)) {
      [attributesInRect addObjectsFromArray:section];
    }
    else if (backwards && CGRectGetMinY(last.frame) < CGRectGetMaxY(rect)) {
      *stop = YES;
    }
    else if (!backwards && CGRectGetMaxY(last.frame) > CGRectGetMinY(rect)) {
      *stop = YES;
    }
  }];

  [self placeBackgroundsToRect:rect];

  [self.backgroundLayoutAttributes enumerateSectionsWithOptions:options usingBlock:^(NSArray *section, NSUInteger idx, BOOL *stop) {
    UICollectionViewLayoutAttributes *last = [section lastObject];

    if (CGRectIntersectsRect(rect, last.frame)) {
      [attributesInRect addObjectsFromArray:section];
    }
    else if (backwards && CGRectGetMinY(last.frame) < CGRectGetMaxY(rect)) {
      *stop = YES;
    }
    else if (!backwards && CGRectGetMaxY(last.frame) > CGRectGetMinY(rect)) {
      *stop = YES;
    }
  }];

  return attributesInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  [self placeBlocksToIndexPath:indexPath];
  return [self.itemLayoutAttributes attributesAtIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  [self placeBlocksToIndexPath:indexPath];

  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    return [self.headerLayoutAttributes attributesAtIndexPath:indexPath];
  }

  return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  [self placeBlocksToIndexPath:indexPath];

  if ([kind isEqualToString:NNMCalendarElementKindBackground]) {
    return [self.backgroundLayoutAttributes attributesAtIndexPath:indexPath];
  }

  return nil;
}

#pragma mark - Date helpers

- (BOOL)isDifferentWeek:(NSDate *)fromDate toDate:(NSDate *)toDate {
  if (!fromDate || !toDate) {
    return NO;
  }

  NSDateComponents *fromComponents = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:fromDate];
  NSDateComponents *toComponents = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:toDate];
  return fromComponents.weekOfYear != toComponents.weekOfYear;
}

- (BOOL)isDifferentMonth:(NSDate *)fromDate toDate:(NSDate *)toDate {
  if (!fromDate || !toDate) {
    return NO;
  }

  NSDateComponents *fromComponents = [self.calendar components:NSCalendarUnitMonth fromDate:fromDate];
  NSDateComponents *toComponents = [self.calendar components:NSCalendarUnitMonth fromDate:toDate];
  return fromComponents.month != toComponents.month;
}

- (NSDate *)nextDate:(NSDate *)date {
  if (!date) {
    return nil;
  }

  static NSDateComponents *components;
  if (!components) {
    components = [[NSDateComponents alloc] init];
    components.day = 1;
  }
  return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)previousDate:(NSDate *)date {
  if (!date) {
    return nil;
  }

  static NSDateComponents *components;
  if (!components) {
    components = [[NSDateComponents alloc] init];
    components.day = -1;
  }
  return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

#pragma mark - Private methods

- (void)placeBlocksToRect:(CGRect)rect {
  UICollectionViewLayoutAttributes *lastAttribute = [self.itemLayoutAttributes lastAttribute];
  CGRect lastFrame = lastAttribute.frame;
  NSIndexPath *lastIndexPath = lastAttribute.indexPath;

  NSDate *lastDate;
  if (lastIndexPath) {
    lastDate = [self.calendar dateByAddingComponents:({
      NSDateComponents *components = [[NSDateComponents alloc] init];
      components.day = lastIndexPath.item;
      components.month = lastIndexPath.section;
      components;
    }) toDate:self.startDate options:0];
  }
  else {
    lastDate = nil;
  }

  // First header

  if (!lastIndexPath) {
    UICollectionViewLayoutAttributes *headerAttributes =
      [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                     withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    headerAttributes.frame = CGRectMake(0, 0, self.headerReferenceSize.width, self.headerReferenceSize.height);
    headerAttributes.zIndex = 2;
    [self.headerLayoutAttributes setAttributes:headerAttributes];

    lastFrame = headerAttributes.frame;
    lastFrame.origin.y += self.headerReferenceSize.height;
  }

  CGRect frame = lastFrame;

  while (YES) {
    NSDate *date = lastDate ? [self nextDate:lastDate] : self.startDate;
    BOOL newSection = [self isDifferentMonth:lastDate toDate:date];
    NSInteger ordinality = [self.calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date] - 1;

    BOOL newLine = [self isDifferentWeek:lastDate toDate:date];
    frame.origin.x = self.itemSize.width * ordinality;

    if (newSection) {
      frame.origin.y += (self.headerReferenceSize.height + self.itemSize.height +
                         self.sectionInset.top + self.sectionInset.bottom);

      if (CGRectGetMaxY(frame) > CGRectGetMaxY(rect)) {
        break;
      }
    }
    else if (newLine) {
      frame.origin.y += self.itemSize.height;
    }

    frame.size.width = self.itemSize.width;
    frame.size.height = self.itemSize.height;

    NSIndexPath *indexPath;
    if (lastIndexPath) {
      NSInteger item = newSection ? 0 : lastIndexPath.item + 1;
      NSInteger section = newSection ? lastIndexPath.section + 1 : lastIndexPath.section;
      indexPath = [NSIndexPath indexPathForItem:item inSection:section];
    }
    else {
      indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }

    UICollectionViewLayoutAttributes *itemAttributes =
      [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    itemAttributes.frame = frame;
    itemAttributes.zIndex = 1;

    [self.itemLayoutAttributes setAttributes:itemAttributes];

    if (newSection) {
      UICollectionViewLayoutAttributes *headerAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                       withIndexPath:indexPath];
      headerAttributes.frame = CGRectMake(0, CGRectGetMinY(frame) - self.headerReferenceSize.height - self.sectionInset.top,
                                          self.headerReferenceSize.width, self.headerReferenceSize.height);
      headerAttributes.zIndex = 2;

      [self.headerLayoutAttributes setAttributes:headerAttributes];
    }

    lastDate = date;
    lastIndexPath = indexPath;
  }
}

- (void)placeBackgroundsToRect:(CGRect)rect {
  UICollectionViewLayoutAttributes *lastAttribute = [self.backgroundLayoutAttributes lastAttribute];
  CGRect lastFrame = lastAttribute.frame;
  NSIndexPath *lastIndexPath = lastAttribute.indexPath;

  CGRect frame = lastFrame;

  while (CGRectGetMaxY(frame) < CGRectGetMaxY(rect)) {
    NSIndexPath *indexPath;
    if (lastIndexPath) {
      indexPath = [NSIndexPath indexPathForItem:0 inSection:lastIndexPath.section + 1];
    }
    else {
      indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }

    UICollectionViewLayoutAttributes *headerAttributes = [self.headerLayoutAttributes attributesAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *itemAttributes = [self.itemLayoutAttributes lastAttributeInSection:indexPath.section];

    frame.origin.x = 0;
    frame.origin.y = CGRectGetMinY(headerAttributes.frame);
    frame.size.width = CGRectGetWidth(self.collectionView.bounds);
    frame.size.height = CGRectGetMaxY(itemAttributes.frame) - CGRectGetMinY(headerAttributes.frame);

    UICollectionViewLayoutAttributes *backgroundAttributes =
      [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NNMCalendarElementKindBackground
                                                                  withIndexPath:indexPath];
    backgroundAttributes.frame = frame;
    backgroundAttributes.zIndex = 0;

    [self.backgroundLayoutAttributes setAttributes:backgroundAttributes];

    lastIndexPath = indexPath;
  }
}

- (void)placeBlocksToIndexPath:(NSIndexPath *)toIndexPath {
  UICollectionViewLayoutAttributes *attributes = [self.itemLayoutAttributes lastAttribute];
  CGRect frame = attributes.frame;
  NSIndexPath *indexPath = attributes.indexPath ?: [NSIndexPath indexPathForItem:0 inSection:0];

  while (toIndexPath.section < indexPath.section) {
    frame.origin.x = 0;
    frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    frame.size.height = CGRectGetHeight([UIScreen mainScreen].bounds);

    [self placeBlocksToRect:frame];
    [self placeBackgroundsToRect:frame];

    attributes = [self.itemLayoutAttributes lastAttribute];
    indexPath = attributes.indexPath;
  }
}

#pragma mark - Getters and Setters

- (void)setStartDate:(NSDate *)startDate {
  NSDateComponents *comps = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:startDate];
  _startDate = [self.calendar dateFromComponents:comps];
}

@end
