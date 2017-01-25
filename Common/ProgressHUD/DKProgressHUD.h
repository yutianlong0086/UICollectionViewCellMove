//
//  DKProgressHUD.h
//  portfolio
//
//  Created by 张奥 on 14-9-15.
//  Copyright (c) 2014年 DKHS. All rights reserved.
//

#import "MBProgressHUD.h"

#define LENGTH_SHORT (2)
#define LENGTH_LONG  (3.5)

@interface DKProgressHUD : MBProgressHUD

+ (BOOL)isBlank:(NSString *)str;

@end

CG_EXTERN  MBProgressHUD* _showTipsView(NSString* text, float duration_time, UIView* view);
CG_EXTERN  MBProgressHUD* _showSuccessView(NSString * text, float duration_time, UIView *view);
CG_EXTERN  MBProgressHUD* _showErrorView(NSString * text, float duration_time, UIView *view);
CG_EXTERN  MBProgressHUD* _showTinyClearIndicator(UIView *view);

#define ShowTipsView(text, duration_time, view) _showTipsView(text, duration_time, view)

#define ShowTips(text)                          ShowTipsView(text, LENGTH_SHORT, self.view)

#define HideIndicator()                 HideIndicatorInView(self.view)
