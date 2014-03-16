//
//  NNMLayoutAttributeStorage.h
//  Calendar
//
//  Created by Alexander Kolov on 03/03/14.
//  Copyright (c) 2014 Noname. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface NNMLayoutAttributeStorage : NSObject

- (NSUInteger)count;

#pragma mark - Adding Attributes

- (void)setAttributes:(UICollectionViewLayoutAttributes *)attributes;

#pragma mark - Querying Attributes

- (UICollectionViewLayoutAttributes *)firstAttribute;
- (UICollectionViewLayoutAttributes *)firstAttributeInSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)lastAttribute;
- (UICollectionViewLayoutAttributes *)lastAttributeInSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)attributesInSection:(NSInteger)section;

#pragma mark - Sending Messages to Sections

- (void)enumerateSectionsUsingBlock:(void (^)(NSArray *section, NSUInteger idx, BOOL *stop))block;
- (void)enumerateSectionsWithOptions:(NSEnumerationOptions)opts
                          usingBlock:(void (^)(NSArray *section, NSUInteger idx, BOOL *stop))block;
- (void)enumerateSectionsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts
                        usingBlock:(void (^)(NSArray *section, NSUInteger idx, BOOL *stop))block;

#pragma mark - Sending Messages to Attributes

- (void)enumerateAttributesUsingBlock:(void (^)(UICollectionViewLayoutAttributes *attrs, NSIndexPath *idx, BOOL *stop))block;
- (void)enumerateAttributesWithOptions:(NSEnumerationOptions)opts
                            usingBlock:(void (^)(UICollectionViewLayoutAttributes *attrs, NSIndexPath *idx, BOOL *stop))block;
- (void)enumerateAttributesAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts
                          usingBlock:(void (^)(UICollectionViewLayoutAttributes *attrs, NSIndexPath *idx, BOOL *stop))block;

@end
