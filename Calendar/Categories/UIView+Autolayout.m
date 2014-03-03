//
//  UIView+Autolayout.m
//  Calendar
//
//  Created by Alexander Kolov on 5/23/13.
//  Copyright (c) 2013 Stylight. All rights reserved.
//

#import "NNMConfig.h"
#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)

+ (instancetype)autolayoutView {
  UIView *view = [[self alloc] init];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  return view;
}

#pragma mark - Pin size

- (NSLayoutConstraint *)pinWidth:(CGFloat)width withRelation:(NSLayoutRelation)relation {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:relation
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:width];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)pinHeight:(CGFloat)height withRelation:(NSLayoutRelation)relation {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:relation
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:height];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSArray *)pinSize:(CGSize)size withRelation:(NSLayoutRelation)relation {
  return @[[self pinWidth:size.width withRelation:relation],
           [self pinHeight:size.height withRelation:relation]];
}

#pragma mark - Pin to center

- (NSArray *)pinToCenter {
  return [self pinToCenterOfView:self.superview];
}

- (NSArray *)pinToCenterOfView:(UIView *)superview {
  return @[[self pinToCenterOfView:superview onAxis:UILayoutConstraintAxisHorizontal],
           [self pinToCenterOfView:superview onAxis:UILayoutConstraintAxisVertical]];
}

- (NSLayoutConstraint *)pinToCenterOfView:(UIView *)view onAxis:(UILayoutConstraintAxis)axis {
  NSLayoutAttribute attribute;
  if (axis == UILayoutConstraintAxisHorizontal) {
    attribute = NSLayoutAttributeCenterX;
  }
  else {
    attribute = NSLayoutAttributeCenterY;
  }

  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:attribute
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:view
                                                                attribute:attribute
                                                               multiplier:1.0f
                                                                 constant:0];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)pinToCenterInContainerOnAxis:(UILayoutConstraintAxis)axis {
  return [self pinToCenterOfView:self.superview onAxis:axis];
}

#pragma mark - Pin to edge

- (NSLayoutConstraint *)pinToContainerEdge:(NSLayoutAttribute)edge {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:edge
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.superview
                                                                attribute:edge
                                                               multiplier:1.0f
                                                                 constant:0];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toView:(UIView *)otherView edge:(NSLayoutAttribute)otherEdge {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:edge
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:otherView
                                                                attribute:otherEdge
                                                               multiplier:1.0f
                                                                 constant:0];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toView:(UIView *)otherView {
  return [self pinEdge:edge toView:otherView edge:edge];
}

#pragma mark - Fill container

- (NSArray *)pinToFillContainer {
  NSDictionary *const views = NSDictionaryOfVariableBindings(self);
  NSMutableArray *constraints = [NSMutableArray array];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
  [self.superview addConstraints:constraints];
  return constraints;
}

- (NSArray *)pinToFillContainerOnAxis:(UILayoutConstraintAxis)axis {
  NSString *expression = @"|[self]|";
  if (axis == UILayoutConstraintAxisHorizontal) {
    expression = [@"H:" stringByAppendingString:expression];
  }
  else {
    expression = [@"V:" stringByAppendingString:expression];
  }

  NSDictionary *const views = NSDictionaryOfVariableBindings(self);
  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:expression options:0 metrics:nil views:views];
  [self.superview addConstraints:constraints];
  return constraints;
}

- (NSArray *)pinViews:(NSArray *)views toFillContainerOnAxis:(UILayoutConstraintAxis)axis {
  NSMutableArray *constraints = [NSMutableArray array];
  if (axis == UILayoutConstraintAxisHorizontal) {
    for (NSUInteger i = 0; i < views.count; ++i) {
      UIView *view = views[i];
      if (i != 0) {
        [constraints addObject:[view pinEqualToView:views[i - 1] attribute:NSLayoutAttributeWidth]];
        [constraints addObject:[view pinEdge:NSLayoutAttributeLeading toView:views[i - 1] edge:NSLayoutAttributeTrailing]];
      }

      [constraints addObject:[views.firstObject pinEdge:NSLayoutAttributeLeading toView:self]];
      [constraints addObject:[views.lastObject pinEdge:NSLayoutAttributeTrailing toView:self]];
      [constraints addObjectsFromArray:[view pinToFillContainerOnAxis:UILayoutConstraintAxisVertical]];
    }
  }
  else {
    for (NSUInteger i = 0; i < views.count; ++i) {
      UIView *view = views[i];
      if (i != 0) {
        [constraints addObject:[view pinEqualToView:views[i - 1] attribute:NSLayoutAttributeHeight]];
        [constraints addObject:[view pinEdge:NSLayoutAttributeTop toView:views[i - 1] edge:NSLayoutAttributeBottom]];
      }

      [constraints addObject:[views.firstObject pinEdge:NSLayoutAttributeTop toView:self]];
      [constraints addObject:[views.lastObject pinEdge:NSLayoutAttributeBottom toView:self]];
      [constraints addObjectsFromArray:[view pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal]];
    }
  }

  return constraints;
}

#pragma mark - Pin equal

- (NSArray *)pinEqualToView:(UIView *)view {
  NSMutableArray *constraints = [NSMutableArray array];
  [constraints addObject:[self pinEdge:NSLayoutAttributeLeading toView:view]];
  [constraints addObject:[self pinEdge:NSLayoutAttributeTrailing toView:view]];
  [constraints addObject:[self pinEdge:NSLayoutAttributeTop toView:view]];
  [constraints addObject:[self pinEdge:NSLayoutAttributeBottom toView:view]];
  return constraints;
}

- (NSLayoutConstraint *)pinEqualToView:(UIView *)view attribute:(NSLayoutAttribute)attribute {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:attribute
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:view
                                                                attribute:attribute
                                                               multiplier:1.0f
                                                                 constant:0];
  [self.superview addConstraint:constraint];
  return constraint;
}

#pragma mark - Pin many views

- (NSArray *)pinInContainerWithVisualFormat:(NSString *)format {
  NSDictionary *const views = NSDictionaryOfVariableBindings(self);
  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
  [self.superview addConstraints:constraints];
  return constraints;
}

- (void)pin:(NSArray *)expressions views:(NSDictionary *)views {
  for (NSString *expr in expressions) {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:expr options:0 metrics:nil views:views]];
  }
}

- (void)pin:(NSArray *)expressions owner:(id)owner {
  for (NSString *x in expressions) {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[(\\w+).*?\\]"
                                                                           options:0 error:&error];
    if (!regex) {
      ErrorLog(error.localizedDescription);
      continue;
    }

    NSMutableDictionary *views = [NSMutableDictionary dictionary];
    [regex
     enumerateMatchesInString:x options:0 range:NSMakeRange(0, x.length)
     usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
       for (NSUInteger i = 1; i < result.numberOfRanges; ++i) {
         NSRange range = [result rangeAtIndex:i];
         NSString *key = [x substringWithRange:range];
         views[key] = [owner valueForKey:key];
       }
     }];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:x options:0 metrics:0 views:views]];
  }
}

@end
