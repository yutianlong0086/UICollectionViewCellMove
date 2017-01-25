//
//  UICollectionView+TLCellRearrange.m
//  UICollectionViewCellMove
//
//  Created by 余天龙 on 2016/12/9.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import "UICollectionView+TLCellRearrange.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, AutoScrollDirection) {
    AutoScrollDirectionNone = 0,
    AutoScrollDirectionUp,
    AutoScrollDirectionDown,
    AutoScrollDirectionLeft,
    AutoScrollDirectionRight
};

@interface UICollectionView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *rearrangeLongPress;
@property (nonatomic, assign) AutoScrollDirection autoScrollDirection;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView *moveView;
@property (nonatomic, strong) NSIndexPath *sourceIndexPath;
@property (nonatomic, strong) UICollectionViewCell *moveCell;

@end

@implementation UICollectionView (TLCellRearrange)

#pragma mark - Getter & Setter

- (UIView *)moveView {
    return objc_getAssociatedObject(self, @selector(moveView));
}

- (UICollectionViewCell *)moveCell {
    return objc_getAssociatedObject(self, @selector(moveCell));
}

- (NSIndexPath *)sourceIndexPath {
    return objc_getAssociatedObject(self, @selector(sourceIndexPath));
}

- (BOOL)enableRearrangement {
    return [objc_getAssociatedObject(self, @selector(enableRearrangement)) boolValue];
}

- (CGFloat)autoScrollSpeed {
    return [objc_getAssociatedObject(self, @selector(autoScrollSpeed)) doubleValue];
}

- (CGFloat)longPressMagnificationFactor {
    return [objc_getAssociatedObject(self, @selector(longPressMagnificationFactor)) doubleValue];
}

- (id<UICollectionViewCellRearrangeDelegate>)rearrangeDelegate {
    return objc_getAssociatedObject(self, @selector(rearrangeDelegate));
}

- (UILongPressGestureRecognizer *)rearrangeLongPress {
    return objc_getAssociatedObject(self, @selector(rearrangeLongPress));
}

- (AutoScrollDirection)autoScrollDirection {
    return [objc_getAssociatedObject(self, @selector(autoScrollDirection)) unsignedIntegerValue];
}

- (CADisplayLink *)displayLink {
    return objc_getAssociatedObject(self, @selector(displayLink));
}

- (void)setMoveView:(UIView *)moveView {
    objc_setAssociatedObject(self, @selector(moveView), moveView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMoveCell:(UICollectionViewCell *)moveCell {
    objc_setAssociatedObject(self, @selector(moveCell), moveCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSourceIndexPath:(NSIndexPath *)sourceIndexPath {
    objc_setAssociatedObject(self, @selector(sourceIndexPath), sourceIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setEnableRearrangement:(BOOL)enableRearrangement {
    objc_setAssociatedObject(self, @selector(enableRearrangement), @(enableRearrangement), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (enableRearrangement) {
        [self setupRearrangement];
    } else {
        [self removeGestureRecognizer:self.rearrangeLongPress];
    }
}

- (void)setAutoScrollSpeed:(CGFloat)autoScrollSpeed {
    objc_setAssociatedObject(self, @selector(autoScrollSpeed), @(autoScrollSpeed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLongPressMagnificationFactor:(CGFloat)longPressMagnificationFactor {
    objc_setAssociatedObject(self, @selector(longPressMagnificationFactor), @(longPressMagnificationFactor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRearrangeDelegate:(id<UICollectionViewCellRearrangeDelegate>)rearrangeDelegate {
    objc_setAssociatedObject(self, @selector(rearrangeDelegate), rearrangeDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setRearrangeLongPress:(UILongPressGestureRecognizer *)rearrangeLongPress {
    objc_setAssociatedObject(self, @selector(rearrangeLongPress), rearrangeLongPress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAutoScrollDirection:(AutoScrollDirection)autoScrollDirection {
    objc_setAssociatedObject(self, @selector(autoScrollDirection), @(autoScrollDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDisplayLink:(CADisplayLink *)displayLink {
    objc_setAssociatedObject(self, @selector(displayLink), displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private methods

- (void)setupRearrangement {
    if (!self.autoScrollSpeed) {
        self.autoScrollSpeed = 5;
    }
    
    if (!self.longPressMagnificationFactor) {
        self.longPressMagnificationFactor = 1.2;
    }
    
    self.rearrangeLongPress = [[UILongPressGestureRecognizer alloc]
                               initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:self.rearrangeLongPress];
}

- (UIView *)snapshotOfView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [[UIImageView alloc] initWithImage:image];
}

- (void)startDisplayLink {
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdate)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink = displaylink;
}

- (void)stopDisplayLink {
    if (!self.displayLink) {
        return;
    }
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)autoScrollWithTouchMoveView:(UIView *)moveView {
    CGRect moveViewRectInSuperView = [moveView convertRect:moveView.bounds toView:self.superview];
    
    if (self.contentSize.height > self.frame.size.height) { // vertical scroll
        if (moveViewRectInSuperView.size.height > self.frame.size.height) {
            return;
        }
        
        if (moveViewRectInSuperView.origin.y + moveView.frame.size.height > self.frame.size.height) { // bottom
            if (self.autoScrollDirection == AutoScrollDirectionUp) {
                return;
            }
            self.autoScrollDirection = AutoScrollDirectionUp;
            [self startDisplayLink];
            
            return;
            
        } else if (moveViewRectInSuperView.origin.y < 0) { // top
            
            if (self.autoScrollDirection == AutoScrollDirectionDown) {
                return;
            }
            self.autoScrollDirection = AutoScrollDirectionDown;
            [self startDisplayLink];
            
            return;
        }
        
    } else if(self.contentSize.width > self.frame.size.width) { // horizontal scroll
        
        if (moveViewRectInSuperView.size.width > self.frame.size.width) {
            return;
        }
        
        if (moveViewRectInSuperView.origin.x + moveView.frame.size.width > self.frame.size.width) { // right
            
            if (self.autoScrollDirection == AutoScrollDirectionLeft) {
                return;
            }
            self.autoScrollDirection = AutoScrollDirectionLeft;
            [self startDisplayLink];
            
            return;
            
        } else if (moveViewRectInSuperView.origin.x < 0) { // left
            
            if (self.autoScrollDirection == AutoScrollDirectionRight) {
                return;
            }
            self.autoScrollDirection = AutoScrollDirectionRight;
            [self startDisplayLink];
            
            return;
        }
    }
    
    self.autoScrollDirection = AutoScrollDirectionNone;
    [self stopDisplayLink];
}

- (void)autoScrollUpdateWithDirection:(AutoScrollDirection)autoScrollDirection {
    CGPoint offset = self.contentOffset;
    CGRect moveViewRect = self.moveView.frame;
    
    switch (autoScrollDirection) {
        case AutoScrollDirectionNone: {
            [self stopDisplayLink];
            break;
        }
        case AutoScrollDirectionLeft: {
            CGFloat diff = self.contentOffset.x - (self.contentSize.width - self.frame.size.width);
            
            if(diff + self.autoScrollSpeed >= 0) {
                offset.x = self.contentSize.width - self.frame.size.width;
                self.contentOffset = offset;
                
                moveViewRect.origin.x += - diff;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.x += self.autoScrollSpeed;
            self.contentOffset = offset;
            
            moveViewRect.origin.x += self.autoScrollSpeed;
            self.moveView.frame = moveViewRect;
            
            break;
        }
        case AutoScrollDirectionRight: {
            if (self.contentOffset.x - self.autoScrollSpeed <= 0) {
                offset.x = 0;
                self.contentOffset = offset;
                
                moveViewRect.origin.x -= self.contentOffset.x;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.x -= self.autoScrollSpeed;
            self.contentOffset = offset;
            
            moveViewRect.origin.x -= self.autoScrollSpeed;
            self.moveView.frame = moveViewRect;
            
            break;
        }
        case AutoScrollDirectionUp: {
            CGFloat diff = self.contentOffset.y - (self.contentSize.height - self.frame.size.height);
            
            if (diff + self.autoScrollSpeed >= 0) {
                offset.y = self.contentSize.height - self.frame.size.height;
                self.contentOffset = offset;
                
                moveViewRect.origin.y += -diff;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.y += self.autoScrollSpeed;
            self.contentOffset = offset;
            
            moveViewRect.origin.y += self.autoScrollSpeed;
            self.moveView.frame = moveViewRect;
            
            break;
        }
        case AutoScrollDirectionDown: {
            if (self.contentOffset.y - self.autoScrollSpeed <= 0) {
                offset.y = 0;
                self.contentOffset = offset;
                
                moveViewRect.origin.y -= self.contentOffset.y;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.y -= self.autoScrollSpeed;
            self.contentOffset = offset;
            
            moveViewRect.origin.y -= self.autoScrollSpeed;
            self.moveView.frame = moveViewRect;
            
            break;
        }
    }
    
    if (autoScrollDirection != AutoScrollDirectionNone) {
        NSIndexPath *targetIndexPath = [self indexPathForItemAtPoint:self.moveView.center];
        
        if (!targetIndexPath) {
            targetIndexPath = [self findIndexPathFailureHandleWithMoveView:self.moveView
                                                           scrollDirection:autoScrollDirection];
        }
        
        if (targetIndexPath) {
            [self longPressChangeWithTargetIndexPath:targetIndexPath pressPoint:self.moveView.center];
        }
    }
}

- (NSIndexPath *)findIndexPathFailureHandleWithMoveView:(UIView *)moveView
                                        scrollDirection:(AutoScrollDirection)autoScrollDirection {
    NSIndexPath *indexPath = nil;
    
    switch (autoScrollDirection) {
        case AutoScrollDirectionRight: {
            CGPoint firstPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMaxY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMinY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AutoScrollDirectionLeft: {
            CGPoint firstPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMaxY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMinY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AutoScrollDirectionDown: {
            CGPoint firstPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMaxY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMaxY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AutoScrollDirectionUp: {
            CGPoint firstPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMinY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMinY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AutoScrollDirectionNone: {
            break;
        }
            
    }
    
    return indexPath;
}

#pragma mark - Event Response

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    CGPoint pressPoint = [longPress locationInView:longPress.view];
    NSIndexPath *targetIndexPath = [self indexPathForItemAtPoint:pressPoint];
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self longPressBeginWithTargetIndexPath:targetIndexPath pressPoint:pressPoint];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self longPressChangeWithTargetIndexPath:targetIndexPath pressPoint:pressPoint];
            
            break;
        }
        default: {
            [self longPressEndWithTargetIndexPath:targetIndexPath];
            
            break;
        }
    }
}

- (void)longPressBeginWithTargetIndexPath:(NSIndexPath *)targetIndexPath pressPoint:(CGPoint)pressPoint {
    if (!targetIndexPath) {
        return;
    }
    
    self.sourceIndexPath = targetIndexPath;
    self.moveCell = [self cellForItemAtIndexPath:self.sourceIndexPath];
    
    if ([self.rearrangeDelegate respondsToSelector:@selector(collectionView:shouldMoveCell:atIndexPath:)]) {
        if (![self.rearrangeDelegate collectionView:self shouldMoveCell:self.moveCell atIndexPath:self.sourceIndexPath]) {
            return;
        }
    }
    
    self.moveView = [self snapshotOfView:self.moveCell];
    self.moveView.frame = self.moveCell.frame;
    [self addSubview:self.moveView];
    self.moveCell.hidden = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.moveView.transform = CGAffineTransformMakeScale(self.longPressMagnificationFactor, self.longPressMagnificationFactor);
        self.moveView.center = pressPoint;
    }];
}

- (void)longPressChangeWithTargetIndexPath:(NSIndexPath *)targetIndexPath pressPoint:(CGPoint)pressPoint{
    if (self.moveView) {
        self.moveView.center = pressPoint;
        [self autoScrollWithTouchMoveView:self.moveView];
    }
    
    if (!self.sourceIndexPath || !targetIndexPath || [targetIndexPath isEqual:self.sourceIndexPath]) {
        return;
    }
    
    if ([self.rearrangeDelegate respondsToSelector:@selector(collectionView:shouldMoveCell:atIndexPath:)]) {
        if (![self.rearrangeDelegate collectionView:self shouldMoveCell:self.moveCell atIndexPath:self.sourceIndexPath]) {
            return;
        }
        if (![self.rearrangeDelegate collectionView:self shouldMoveCell:self.moveCell atIndexPath:targetIndexPath]) {
            return;
        }
    }
    
    if ([self.rearrangeDelegate respondsToSelector:@selector(collectionView:shouldMoveCell:fromIndexPath:toIndexPath:)]) {
        if (![self.rearrangeDelegate collectionView:self shouldMoveCell:self.moveCell fromIndexPath:self.sourceIndexPath toIndexPath:targetIndexPath]) {
            return;
        }
    }
    
    [self moveItemAtIndexPath:self.sourceIndexPath toIndexPath:targetIndexPath];
    
    
    if ([self.rearrangeDelegate respondsToSelector:@selector(collectionView:didMoveCell:fromIndexPath:toIndexPath:)]) {
        [self.rearrangeDelegate collectionView:self didMoveCell:self.moveCell fromIndexPath:self.sourceIndexPath toIndexPath:targetIndexPath];
    }
    
    self.sourceIndexPath = targetIndexPath;
}

- (void)longPressEndWithTargetIndexPath:(NSIndexPath *)targetIndexPath {
    if (!self.sourceIndexPath) {
        return;
    }
    
    if ([self.rearrangeDelegate respondsToSelector:@selector(collectionView:shouldMoveCell:atIndexPath:)]) {
        if (![self.rearrangeDelegate collectionView:self shouldMoveCell:self.moveCell atIndexPath:self.sourceIndexPath]) {
            return;
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.moveView.center = self.moveCell.center;
        self.moveView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.moveCell.hidden = NO;
        [self.moveView removeFromSuperview];
        self.moveView = nil;
        self.moveCell = nil;
        self.sourceIndexPath = nil;
        [self autoScrollWithTouchMoveView:self.moveView];
    }];
    
    if ([self.rearrangeDelegate respondsToSelector:@selector(collectionView:putDownCell:atIndexPath:)]) {
        [self.rearrangeDelegate collectionView:self putDownCell:self.moveCell atIndexPath:self.sourceIndexPath];
    }
}

- (void)displayLinkUpdate {
    [self autoScrollUpdateWithDirection:self.autoScrollDirection];
}

@end
