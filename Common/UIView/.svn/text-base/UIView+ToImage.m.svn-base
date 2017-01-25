//
//  UIView+ToImage.m
//  portfolio
//
//  Created by 张奥 on 14-11-20.
//  Copyright (c) 2014年 DKHS. All rights reserved.
//

#import "UIView+ToImage.h"

@implementation UIView (ToImage)

- (UIImage *)toImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    BOOL hidden = [self isHidden];
    [self setHidden:NO];
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setHidden:hidden];
    return image;
}

@end
