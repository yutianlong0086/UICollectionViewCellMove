//
//  UIView+FirstResponder.m
//  TMarket
//
//  Created by ZhangAo on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+firstResponder.h"

@implementation UIView (FirstResponder)

- (UIView *)findFirstResponder{
    if ([self isFirstResponder]) {
        return self;
    }
    
    for (UIView *view in self.subviews) {
        UIView *firstResponder = [view findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}
@end
