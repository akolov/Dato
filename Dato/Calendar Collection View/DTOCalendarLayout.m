//
//  DTOCalendarLayout.m
//  Dato
//
//  Created by Alexander Kolov on 23/02/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOCalendarLayout.h"

#import "DTOCalendarBackgroundView.h"
#import "DTOLayoutAttributeStorage.h"
#import "NSCalendar+DTOAdditions.h"

NSString *const DTOCalendarElementKindBackground = @"DTOCalendarElementKindBackground";

@interface DTOCalendarLayout ()

@property (nonatomic, strong) DTOLayoutAttributeStorage *itemLayoutAttributes;
@property (nonatomic, strong) DTOLayoutAttributeStorage *headerLayoutAttributes;
@property (nonatomic, strong) DTOLayoutAttributeStorage *backgroundLayoutAttributes;
@property (nonatomic, strong) NSArray *previousLayoutAttributes;
@property (nonatomic, assign) CGRect previousLayoutRect;

- (void)placeBlocksToRect:(CGRect)rect;
- (void)placeBlocksToIndexPath:(NSIndexPath *)toIndexPath;
- (void)placeBackgroundsToRect:(CGRect)rect;

@end

@implementation DTOCalendarLayout

- (instancetype)init {
  self = [super init];
  if (self) {
    self.itemSize = CGSizeMake(320.0f / 7.0f, 320.0f / 7.0f);
    self.headerReferenceSize = CGSizeMake(320.0f, 35.0f);
    self.itemLayoutAttributes = [[DTOLayoutAttributeStorage alloc] init];
    self.headerLayoutAttributes = [[DTOLayoutAttributeStorage alloc] init];
    self.backgroundLayoutAttributes = [[DTOLayoutAttributeStorage alloc] init];

    [self registerClass:[DTOCalendarBackgroundView class] forDecorationViewOfKind:DTOCalendarElementKindBackground];
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

  [self.itemLayoutAttributes
   enumerateSectionsWithOptions:options usingBlock:^(NSArray *section, NSUInteger idx, BOOL *stop) {
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

  [self.headerLayoutAttributes
   enumerateSectionsWithOptions:options usingBlock:^(NSArray *section, NSUInteger idx, BOOL *stop) {
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

  [self.backgroundLayoutAttributes
   enumerateSectionsWithOptions:options usingBlock:^(NSArray *section, NSUInteger idx, BOOL *stop) {
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

  if ([kind isEqualToString:DTOCalendarElementKindBackground]) {
    return [self.backgroundLayoutAttributes attributesAtIndexPath:indexPath];
  }

  return nil;
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

  BOOL stop = NO;

  while (YES) {
    NSDate *date = lastDate ? [self.calendar nextDate:lastDate] : self.startDate;
    BOOL newSection = [self.calendar isDifferentMonth:lastDate toDate:date];
    NSInteger ordinality = [self.calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date] - 1;

    BOOL newLine = [self.calendar isDifferentWeek:lastDate toDate:date];
    frame.origin.x = self.itemSize.width * ordinality;

    if (newSection) {
      if (stop) {
        break;
      }

      frame.origin.y += (self.headerReferenceSize.height + self.itemSize.height +
                         self.sectionInset.top + self.sectionInset.bottom);

      if (CGRectGetMaxY(frame) > CGRectGetMaxY(rect)) {
        // Will stop at the next section
        stop = YES;
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

    if (indexPath.section >= [self.collectionView numberOfSections] ||
        indexPath.item >= [self.collectionView numberOfItemsInSection:indexPath.section]) {
      break;
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

    UICollectionViewLayoutAttributes *firstAttributes = [self.itemLayoutAttributes firstAttributeInSection:indexPath.section];
    UICollectionViewLayoutAttributes *lastAttributes = [self.itemLayoutAttributes lastAttributeInSection:indexPath.section];

    if (!firstAttributes || !lastAttributes) {
      break;
    }

    frame.origin.x = 0;
    frame.origin.y = CGRectGetMinY(firstAttributes.frame);
    frame.size.width = CGRectGetWidth(self.collectionView.bounds);
    frame.size.height = CGRectGetMaxY(lastAttributes.frame) - CGRectGetMinY(firstAttributes.frame);

    UICollectionViewLayoutAttributes *backgroundAttributes =
      [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:DTOCalendarElementKindBackground
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
