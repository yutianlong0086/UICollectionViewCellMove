//
//  WBDeviceInfo.h
//  AirMonitor
//
//  Created by 余天龙 on 2016/11/18.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GetDeviceInfo()         ([WBDeviceInfo sharedInstance])

@interface WBDeviceInfo : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) NSString *imei;
@property (nonatomic, readonly) NSString *imsi;
@property (nonatomic, readonly) NSString *model;
@property (nonatomic, readonly) NSString *uuid;
@property (nonatomic, readonly) NSString *vendor;

- (NSString *)getCurrentDeviceModel;

@end
