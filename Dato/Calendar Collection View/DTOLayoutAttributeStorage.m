//
//  DTOLayoutAttributeStorage.m
//  Dato
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

#import "DTOConfig.h"
#import "DTOLayoutAttributeStorage.h"

@interface DTOLayoutAttributeStorage ()

@property (nonatomic, strong) NSMutableArray *storage;

@end

@implementation DTOLayoutAttributeStorage

- (instancetype)init {
  self = [super init];
  if (self) {
    self.storage = [NSMutableArray array];
  }
  return self;
}

- (NSUInteger)count {
  NSUInteger count = 0;
  for (NSArray *array in self.storage) {
    count += [array count];
  }
  return count;
}

#pragma mark - Adding Attributes

- (void)setAttributes:(UICollectionViewLayoutAttributes *)attributes {
  while ([self.storage count] <= attributes.indexPath.section) {
    [self.storage addObject:[NSMutableArray array]];
  }

  while ([self.storage[attributes.indexPath.section] count] < attributes.indexPath.item) {
    [self.storage[attributes.indexPath.section] addObject:[NSNull null]];
  }

  if ([self.storage[attributes.indexPath.section] count] == attributes.indexPath.item) {
    [self.storage[attributes.indexPath.section] addObject:attributes];
  }
  else {
    [self.storage[attributes.indexPath.section] replaceObjectAtIndex:attributes.indexPath.item withObject:attributes];
  }
}

#pragma mark - Querying Attributes

- (UICollectionViewLayoutAttributes *)firstAttribute {
  id obj = [[self.storage firstObject] firstObject];
  return [obj isEqual:[NSNull null]] ? nil : obj;
}

- (UICollectionViewLayoutAttributes *)firstAttributeInSection:(NSInteger)section {
  if ([self.storage count] <= section) {
    return nil;
  }

  id obj = [self.storage[section] firstObject];
  return [obj isEqual:[NSNull null]] ? nil : obj;
}

- (UICollectionViewLayoutAttributes *)lastAttribute {
  id obj = [[self.storage lastObject] lastObject];
  return [obj isEqual:[NSNull null]] ? nil : obj;
}

- (UICollectionViewLayoutAttributes *)lastAttributeInSection:(NSInteger)section {
  if ([self.storage count] <= section) {
    return nil;
  }

  id obj = [self.storage[section] lastObject];
  return [obj isEqual:[NSNull null]] ? nil : obj;
}

- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.storage count] <= indexPath.section) {
    return nil;
  }

  if ([self.storage[indexPath.section] count] <= indexPath.item) {
    return nil;
  }

  id attributes = self.storage[indexPath.section][indexPath.item];
  if ([attributes isEqual:[NSNull null]]) {
    return nil;
  }

  return attributes;
}

- (NSArray *)attributesInSection:(NSInteger)section {
  return [self.storage[section] filteredArrayUsingPredicate:
          [NSPredicate predicateWithFormat:@"SELF != %@", [NSNull null]]];
}

#pragma mark - Sending Messages to Sections

- (void)enumerateSectionsUsingBlock:(void (^)(NSArray *section, NSUInteger idx, BOOL *stop))block {
  [self.storage enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger section, BOOL *stop) {
    block(arr, section, stop);
  }];
}

- (void)enumerateSectionsWithOptions:(NSEnumerationOptions)opts
                          usingBlock:(void (^)(NSArray *section, NSUInteger idx, BOOL *stop))block {
  [self.storage enumerateObjectsWithOptions:opts usingBlock:^(NSArray *arr, NSUInteger section, BOOL *stop) {
    block(arr, section, stop);
  }];
}

- (void)enumerateSectionsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts
                        usingBlock:(void (^)(NSArray *section, NSUInteger idx, BOOL *stop))block {
  [self.storage enumerateObjectsAtIndexes:s options:opts usingBlock:^(NSArray *arr, NSUInteger section, BOOL *stop) {
    block(arr, section, stop);
  }];
}

#pragma mark - Sending Messages to Attributes

- (void)enumerateAttributesUsingBlock:(void (^)(UICollectionViewLayoutAttributes *attrs, NSIndexPath *idx, BOOL *stop))block {
  [self.storage enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger section, BOOL *stop) {
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger item, BOOL *stop) {
      if (![obj isEqual:[NSNull null]]) {
        block(obj, [NSIndexPath indexPathForItem:item inSection:section], stop);
      }
    }];
  }];
}

- (void)enumerateAttributesWithOptions:(NSEnumerationOptions)opts
                            usingBlock:(void (^)(UICollectionViewLayoutAttributes *attrs, NSIndexPath *idx, BOOL *stop))block {
  [self.storage enumerateObjectsWithOptions:opts usingBlock:^(NSArray *arr, NSUInteger section, BOOL *stop) {
    [arr enumerateObjectsWithOptions:opts usingBlock:^(id obj, NSUInteger item, BOOL *stop) {
      if (![obj isEqual:[NSNull null]]) {
        block(obj, [NSIndexPath indexPathForItem:item inSection:section], stop);
      }
    }];
  }];
}

- (void)enumerateAttributesAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts
                          usingBlock:(void (^)(UICollectionViewLayoutAttributes *attrs, NSIndexPath *idx, BOOL *stop))block {
  [self.storage enumerateObjectsAtIndexes:s options:opts usingBlock:^(NSArray *arr, NSUInteger section, BOOL *stop) {
    [arr enumerateObjectsWithOptions:opts usingBlock:^(id obj, NSUInteger item, BOOL *stop) {
      if (![obj isEqual:[NSNull null]]) {
        block(obj, [NSIndexPath indexPathForItem:item inSection:section], stop);
      }
    }];
  }];
}

@end
