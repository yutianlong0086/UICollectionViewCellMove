//
//  UIView+AutoLayoutUtils.m
//  portfolio
//
//  Created by 张奥 on 15/5/4.
//  Copyright (c) 2015年 DKHS. All rights reserved.
//

#import "UIView+AutoLayoutUtils.h"

@implementation UIView (AutoLayoutUtils)

- (void)addConstraintForSameWidthToView:(UIView *)view {
    [self addConstraintToView:view attribute:NSLayoutAttributeWidth secondView:self constant:0];
}

- (void)addConstraintForSameHeightToView:(UIView *)view {
    [self addConstraintToView:view attribute:NSLayoutAttributeHeight secondView:self constant:0];
}

- (void)addConstraintToView:(UIView *)view forLeft:(CGFloat)left {
    [self addConstraintToView:view attribute:NSLayoutAttributeLeading secondView:self constant:left];
}

- (void)addConstraintToView:(UIView *)view forTop:(CGFloat)top {
    [self addConstraintToView:view attribute:NSLayoutAttributeTop secondView:self constant:top];
}

- (void)addConstraintToView:(UIView *)view forBottom:(CGFloat)bottom {
    [self addConstraintToView:view attribute:NSLayoutAttributeBottom secondView:self constant:-bottom];
}

- (void)addConstraintToView:(UIView *)view forWidth:(CGFloat)width {
    [self addConstraintToView:view attribute:NSLayoutAttributeWidth secondView:nil constant:width];
}

- (NSLayoutConstraint *)addConstraintToView:(UIView *)view forHeight:(CGFloat)height {
    return [self addConstraintToView:view attribute:NSLayoutAttributeHeight secondView:nil constant:height];
}

- (void)addConstraintsWithFormat:(NSString *)format views:(NSDictionary *)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:views]];
}

#pragma mark - Private methods

- (NSLayoutConstraint *)addConstraintToView:(UIView *)view
                                  attribute:(NSLayoutAttribute)attribute
                                 secondView:(UIView *)secondView
                                   constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:secondView
                                                                  attribute:attribute
                                                                 multiplier:1
                                                                   constant:constant];
    [self addConstraint:constraint];
    return constraint;
}

@end
