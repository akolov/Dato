//
//  DTOTheme.h
//  Dato
//
//  Created by Alexander Kolov on 13/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

@import Foundation;

@interface DTOTheme : NSObject

@property (nonatomic, copy, readonly) NSString *themeName;
@property (nonatomic, strong, readonly) UIColor *windowBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *viewBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *separatorColor;
@property (nonatomic, strong, readonly) UIColor *primaryTextColor;
@property (nonatomic, strong, readonly) UIColor *secondaryTextColor;
@property (nonatomic, strong, readonly) UIColor *tretiaryTextColor;

+ (instancetype)theme;

@end
