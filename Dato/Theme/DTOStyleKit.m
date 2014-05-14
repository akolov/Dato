//
//  DTOStyleKit.m
//  Dato
//
//  Created by Alexander Kolov on 14/05/14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import "DTOStyleKit.h"


@implementation DTOStyleKit

#pragma mark Cache

static UIColor* _foregroundWhiteColor = nil;
static UIColor* _foregroundBlueColor = nil;
static UIColor* _foregroundYellowColor = nil;
static UIColor* _foregroundOrangeColor = nil;
static UIColor* _foregroundRedColor = nil;
static UIColor* _foregroundGrayColor = nil;
static UIColor* _foregroundDarkGrayColor = nil;
static UIColor* _backgroundGrayColor = nil;
static UIColor* _backgroundDarkGrayColor = nil;
static UIColor* _backgroundWhiteColor = nil;
static UIColor* _backgroundBlackColor = nil;
static UIColor* _foregroundSilverColor = nil;
static UIColor* _separatorGrayColor = nil;
static UIColor* _separatorDarkGrayColor = nil;

static UIImage* _imageOfCogwheel = nil;

#pragma mark Initialization

+ (void)initialize
{
    // Colors Initialization
    _foregroundWhiteColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    _foregroundBlueColor = [UIColor colorWithRed: 0.078 green: 0.506 blue: 0.984 alpha: 1];
    _foregroundYellowColor = [UIColor colorWithRed: 0.992 green: 0.745 blue: 0.196 alpha: 1];
    _foregroundOrangeColor = [UIColor colorWithRed: 0.988 green: 0.502 blue: 0.239 alpha: 1];
    _foregroundRedColor = [UIColor colorWithRed: 0.984 green: 0.333 blue: 0.345 alpha: 1];
    _foregroundGrayColor = [UIColor colorWithRed: 0.506 green: 0.506 blue: 0.506 alpha: 1];
    _foregroundDarkGrayColor = [UIColor colorWithRed: 0.224 green: 0.224 blue: 0.224 alpha: 1];
    _backgroundGrayColor = [UIColor colorWithRed: 0.929 green: 0.929 blue: 0.929 alpha: 1];
    _backgroundDarkGrayColor = [UIColor colorWithRed: 0.176 green: 0.192 blue: 0.235 alpha: 1];
    _backgroundWhiteColor = [UIColor colorWithRed: 0.988 green: 0.988 blue: 0.988 alpha: 1];
    _backgroundBlackColor = [UIColor colorWithRed: 0.125 green: 0.137 blue: 0.18 alpha: 1];
    _foregroundSilverColor = [UIColor colorWithRed: 0.671 green: 0.678 blue: 0.694 alpha: 1];
    _separatorGrayColor = [UIColor colorWithRed: 0.878 green: 0.878 blue: 0.878 alpha: 1];
    _separatorDarkGrayColor = [UIColor colorWithRed: 0.255 green: 0.267 blue: 0.31 alpha: 1];

}

#pragma mark Colors

+ (UIColor*)foregroundWhiteColor { return _foregroundWhiteColor; }
+ (UIColor*)foregroundBlueColor { return _foregroundBlueColor; }
+ (UIColor*)foregroundYellowColor { return _foregroundYellowColor; }
+ (UIColor*)foregroundOrangeColor { return _foregroundOrangeColor; }
+ (UIColor*)foregroundRedColor { return _foregroundRedColor; }
+ (UIColor*)foregroundGrayColor { return _foregroundGrayColor; }
+ (UIColor*)foregroundDarkGrayColor { return _foregroundDarkGrayColor; }
+ (UIColor*)backgroundGrayColor { return _backgroundGrayColor; }
+ (UIColor*)backgroundDarkGrayColor { return _backgroundDarkGrayColor; }
+ (UIColor*)backgroundWhiteColor { return _backgroundWhiteColor; }
+ (UIColor*)backgroundBlackColor { return _backgroundBlackColor; }
+ (UIColor*)foregroundSilverColor { return _foregroundSilverColor; }
+ (UIColor*)separatorGrayColor { return _separatorGrayColor; }
+ (UIColor*)separatorDarkGrayColor { return _separatorDarkGrayColor; }

#pragma mark Drawing Methods

+ (void)drawCogwheel;
{

    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(17.68, 7.41)];
    [bezierPath addLineToPoint: CGPointMake(16.93, 7.36)];
    [bezierPath addCurveToPoint: CGPointMake(16.42, 7.01) controlPoint1: CGPointMake(16.78, 7.32) controlPoint2: CGPointMake(16.55, 7.23)];
    [bezierPath addCurveToPoint: CGPointMake(15.66, 5.17) controlPoint1: CGPointMake(16.25, 6.36) controlPoint2: CGPointMake(15.99, 5.74)];
    [bezierPath addCurveToPoint: CGPointMake(15.77, 4.56) controlPoint1: CGPointMake(15.59, 4.92) controlPoint2: CGPointMake(15.69, 4.69)];
    [bezierPath addLineToPoint: CGPointMake(16.26, 3.99)];
    [bezierPath addCurveToPoint: CGPointMake(16.26, 3.53) controlPoint1: CGPointMake(16.39, 3.86) controlPoint2: CGPointMake(16.39, 3.66)];
    [bezierPath addLineToPoint: CGPointMake(14.47, 1.74)];
    [bezierPath addCurveToPoint: CGPointMake(14.01, 1.74) controlPoint1: CGPointMake(14.34, 1.62) controlPoint2: CGPointMake(14.14, 1.62)];
    [bezierPath addLineToPoint: CGPointMake(13.45, 2.23)];
    [bezierPath addCurveToPoint: CGPointMake(12.8, 2.33) controlPoint1: CGPointMake(13.31, 2.31) controlPoint2: CGPointMake(13.07, 2.41)];
    [bezierPath addCurveToPoint: CGPointMake(11.08, 1.6) controlPoint1: CGPointMake(12.27, 2.02) controlPoint2: CGPointMake(11.69, 1.77)];
    [bezierPath addCurveToPoint: CGPointMake(10.64, 0.99) controlPoint1: CGPointMake(10.75, 1.46) controlPoint2: CGPointMake(10.66, 1.13)];
    [bezierPath addLineToPoint: CGPointMake(10.59, 0.32)];
    [bezierPath addCurveToPoint: CGPointMake(10.27, 0) controlPoint1: CGPointMake(10.59, 0.15) controlPoint2: CGPointMake(10.45, 0)];
    [bezierPath addLineToPoint: CGPointMake(7.73, 0)];
    [bezierPath addCurveToPoint: CGPointMake(7.41, 0.32) controlPoint1: CGPointMake(7.56, 0) controlPoint2: CGPointMake(7.41, 0.15)];
    [bezierPath addLineToPoint: CGPointMake(7.36, 1.07)];
    [bezierPath addCurveToPoint: CGPointMake(7.01, 1.58) controlPoint1: CGPointMake(7.32, 1.21) controlPoint2: CGPointMake(7.23, 1.44)];
    [bezierPath addCurveToPoint: CGPointMake(5.17, 2.34) controlPoint1: CGPointMake(6.36, 1.75) controlPoint2: CGPointMake(5.74, 2.01)];
    [bezierPath addCurveToPoint: CGPointMake(4.57, 2.24) controlPoint1: CGPointMake(4.92, 2.41) controlPoint2: CGPointMake(4.7, 2.32)];
    [bezierPath addLineToPoint: CGPointMake(3.99, 1.74)];
    [bezierPath addCurveToPoint: CGPointMake(3.53, 1.74) controlPoint1: CGPointMake(3.86, 1.61) controlPoint2: CGPointMake(3.66, 1.61)];
    [bezierPath addLineToPoint: CGPointMake(1.74, 3.53)];
    [bezierPath addCurveToPoint: CGPointMake(1.74, 3.99) controlPoint1: CGPointMake(1.62, 3.66) controlPoint2: CGPointMake(1.62, 3.86)];
    [bezierPath addLineToPoint: CGPointMake(2.19, 4.51)];
    [bezierPath addCurveToPoint: CGPointMake(2.29, 5.27) controlPoint1: CGPointMake(2.28, 4.64) controlPoint2: CGPointMake(2.43, 4.94)];
    [bezierPath addCurveToPoint: CGPointMake(1.62, 6.88) controlPoint1: CGPointMake(2, 5.78) controlPoint2: CGPointMake(1.78, 6.32)];
    [bezierPath addLineToPoint: CGPointMake(1.62, 6.85)];
    [bezierPath addCurveToPoint: CGPointMake(0.97, 7.36) controlPoint1: CGPointMake(1.5, 7.25) controlPoint2: CGPointMake(1.11, 7.34)];
    [bezierPath addLineToPoint: CGPointMake(0.32, 7.41)];
    [bezierPath addCurveToPoint: CGPointMake(0, 7.73) controlPoint1: CGPointMake(0.14, 7.41) controlPoint2: CGPointMake(0, 7.55)];
    [bezierPath addLineToPoint: CGPointMake(0, 10.27)];
    [bezierPath addCurveToPoint: CGPointMake(0.32, 10.59) controlPoint1: CGPointMake(0, 10.45) controlPoint2: CGPointMake(0.14, 10.59)];
    [bezierPath addLineToPoint: CGPointMake(1.02, 10.64)];
    [bezierPath addCurveToPoint: CGPointMake(1.61, 11.11) controlPoint1: CGPointMake(1.18, 10.67) controlPoint2: CGPointMake(1.49, 10.78)];
    [bezierPath addCurveToPoint: CGPointMake(2.29, 12.74) controlPoint1: CGPointMake(1.78, 11.68) controlPoint2: CGPointMake(2, 12.23)];
    [bezierPath addLineToPoint: CGPointMake(2.26, 12.7)];
    [bezierPath addCurveToPoint: CGPointMake(2.13, 13.56) controlPoint1: CGPointMake(2.49, 13.15) controlPoint2: CGPointMake(2.13, 13.56)];
    [bezierPath addLineToPoint: CGPointMake(2.51, 13.12)];
    [bezierPath addLineToPoint: CGPointMake(1.74, 14.01)];
    [bezierPath addCurveToPoint: CGPointMake(1.74, 14.47) controlPoint1: CGPointMake(1.61, 14.14) controlPoint2: CGPointMake(1.61, 14.34)];
    [bezierPath addLineToPoint: CGPointMake(3.53, 16.26)];
    [bezierPath addCurveToPoint: CGPointMake(3.99, 16.26) controlPoint1: CGPointMake(3.66, 16.39) controlPoint2: CGPointMake(3.86, 16.39)];
    [bezierPath addLineToPoint: CGPointMake(4.48, 15.83)];
    [bezierPath addCurveToPoint: CGPointMake(5.21, 15.69) controlPoint1: CGPointMake(4.58, 15.76) controlPoint2: CGPointMake(4.88, 15.57)];
    [bezierPath addCurveToPoint: CGPointMake(6.92, 16.4) controlPoint1: CGPointMake(5.74, 15.99) controlPoint2: CGPointMake(6.32, 16.23)];
    [bezierPath addCurveToPoint: CGPointMake(7.35, 16.95) controlPoint1: CGPointMake(7.2, 16.52) controlPoint2: CGPointMake(7.31, 16.78)];
    [bezierPath addLineToPoint: CGPointMake(7.41, 17.68)];
    [bezierPath addCurveToPoint: CGPointMake(7.73, 18) controlPoint1: CGPointMake(7.41, 17.86) controlPoint2: CGPointMake(7.55, 18)];
    [bezierPath addLineToPoint: CGPointMake(10.27, 18)];
    [bezierPath addCurveToPoint: CGPointMake(10.59, 17.68) controlPoint1: CGPointMake(10.44, 18) controlPoint2: CGPointMake(10.59, 17.86)];
    [bezierPath addLineToPoint: CGPointMake(10.64, 16.99)];
    [bezierPath addCurveToPoint: CGPointMake(11.07, 16.4) controlPoint1: CGPointMake(10.67, 16.84) controlPoint2: CGPointMake(10.76, 16.54)];
    [bezierPath addCurveToPoint: CGPointMake(12.8, 15.68) controlPoint1: CGPointMake(11.68, 16.23) controlPoint2: CGPointMake(12.26, 15.99)];
    [bezierPath addCurveToPoint: CGPointMake(13.46, 15.79) controlPoint1: CGPointMake(13.08, 15.59) controlPoint2: CGPointMake(13.33, 15.7)];
    [bezierPath addLineToPoint: CGPointMake(14.01, 16.26)];
    [bezierPath addCurveToPoint: CGPointMake(14.47, 16.26) controlPoint1: CGPointMake(14.14, 16.39) controlPoint2: CGPointMake(14.34, 16.39)];
    [bezierPath addLineToPoint: CGPointMake(16.26, 14.47)];
    [bezierPath addCurveToPoint: CGPointMake(16.26, 14.01) controlPoint1: CGPointMake(16.38, 14.34) controlPoint2: CGPointMake(16.38, 14.14)];
    [bezierPath addLineToPoint: CGPointMake(15.78, 13.47)];
    [bezierPath addCurveToPoint: CGPointMake(15.66, 12.83) controlPoint1: CGPointMake(15.7, 13.34) controlPoint2: CGPointMake(15.59, 13.1)];
    [bezierPath addCurveToPoint: CGPointMake(16.4, 11.05) controlPoint1: CGPointMake(15.98, 12.28) controlPoint2: CGPointMake(16.23, 11.68)];
    [bezierPath addCurveToPoint: CGPointMake(16.94, 10.65) controlPoint1: CGPointMake(16.53, 10.78) controlPoint2: CGPointMake(16.79, 10.68)];
    [bezierPath addLineToPoint: CGPointMake(17.68, 10.59)];
    [bezierPath addCurveToPoint: CGPointMake(18, 10.27) controlPoint1: CGPointMake(17.85, 10.59) controlPoint2: CGPointMake(18, 10.45)];
    [bezierPath addLineToPoint: CGPointMake(18, 7.73)];
    [bezierPath addCurveToPoint: CGPointMake(17.68, 7.41) controlPoint1: CGPointMake(18, 7.56) controlPoint2: CGPointMake(17.86, 7.41)];
    [bezierPath addLineToPoint: CGPointMake(17.68, 7.41)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(9, 14.6)];
    [bezierPath addCurveToPoint: CGPointMake(3.4, 9) controlPoint1: CGPointMake(5.91, 14.6) controlPoint2: CGPointMake(3.4, 12.09)];
    [bezierPath addCurveToPoint: CGPointMake(9, 3.4) controlPoint1: CGPointMake(3.4, 5.91) controlPoint2: CGPointMake(5.91, 3.4)];
    [bezierPath addCurveToPoint: CGPointMake(14.6, 9) controlPoint1: CGPointMake(12.09, 3.4) controlPoint2: CGPointMake(14.6, 5.91)];
    [bezierPath addCurveToPoint: CGPointMake(9, 14.6) controlPoint1: CGPointMake(14.6, 12.09) controlPoint2: CGPointMake(12.09, 14.6)];
    [bezierPath addLineToPoint: CGPointMake(9, 14.6)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;

    bezierPath.usesEvenOddFillRule = YES;

    [DTOStyleKit.foregroundWhiteColor setFill];
    [bezierPath fill];
}

#pragma mark Generated Images

+ (UIImage*)imageOfCogwheel;
{
    if (_imageOfCogwheel)
        return _imageOfCogwheel;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(18, 18), NO, 0.0f);
    [DTOStyleKit drawCogwheel];
    _imageOfCogwheel = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return _imageOfCogwheel;
}

#pragma mark Customization Infrastructure

- (void)setCogwheelTargets: (NSArray*)cogwheelTargets
{
    _cogwheelTargets = cogwheelTargets;

    for (id target in self.cogwheelTargets)
        [target setImage: DTOStyleKit.imageOfCogwheel];
}


@end
