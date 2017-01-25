//
//  DKProgressHUD.m
//  portfolio
//
//  Created by 张奥 on 14-9-15.
//  Copyright (c) 2014年 DKHS. All rights reserved.
//

#import "DKProgressHUD.h"
#import "UIView+Frame.h"

UIView *_getTargetView(UIView *view) {
    if ([view isKindOfClass:[UIScrollView class]]) {
        return (view.superview == nil ? view : view.superview);
    } else {
        return view;
    }
}

MBProgressHUD *_showTipsView(NSString *text, float duration_time, UIView *view) {
    if (view == nil) {
        return nil;
    }
    UIView *targetView = _getTargetView(view);
    
    if ([text isEqual:[NSNull null]]) {
        text = @"null";
    }
    
    [MBProgressHUD hideHUDForView:targetView animated:NO];
    if ([DKProgressHUD isBlank:text]) {
        return nil;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:targetView];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.margin = 15;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.offset = CGPointMake(hud.x, hud.y);
    [targetView addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:duration_time];
    hud.layer.zPosition = 999;
    return hud;
}

MBProgressHUD *_showSuccessView(NSString *text, float duration_time, UIView *view) {
    UIView *targetView = _getTargetView(view);
    
    [MBProgressHUD hideHUDForView:targetView animated:NO];
    if ([DKProgressHUD isBlank:text]) {
        return nil;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:targetView];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hub_success"]];
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.margin = 25;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.offset = CGPointMake(hud.x, hud.y);
    [targetView addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:duration_time];
    return hud;
}

MBProgressHUD *_showErrorView(NSString *text, float duration_time, UIView *view) {
    UIView *targetView = _getTargetView(view);
    
    [MBProgressHUD hideHUDForView:targetView animated:NO];
    if ([DKProgressHUD isBlank:text]) {
        return nil;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:targetView];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hub_alert"]];
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.margin = 25;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.offset = CGPointMake(hud.x, hud.y);
    [targetView addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:duration_time];
    return hud;
}

MBProgressHUD *_showTinyClearIndicator(UIView *view) {
    UIView *targetView = _getTargetView(view);
    
    [MBProgressHUD hideHUDForView:targetView animated:NO];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:targetView];
    hud.mode = MBProgressHUDModeCustomView;
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    hud.customView = indicatorView;
    hud.bezelView.color = [UIColor clearColor];
    hud.removeFromSuperViewOnHide = YES;
    [targetView addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

@implementation DKProgressHUD

+ (void)initialize {
    if (self == [DKProgressHUD class]) {
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    }
}

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    DKProgressHUD *hud = [super showHUDAddedTo:view animated:animated];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    return hud;
}

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
//        self.opacity = 0.3;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self setNeedsDisplay];
}

+ (BOOL)isEmptyOrWhitespace:(NSString *)str {
    // A nil or NULL string is not the same as an empty string
    return 0 == str.length ||
    ![str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

+ (BOOL)isBlank:(NSString *)str {
    return str == nil || [self isEmptyOrWhitespace:str];
}

@end
