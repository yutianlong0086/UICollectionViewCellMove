//
//  WBDeviceModel.h
//  UICollectionViewCellMove
//
//  Created by 余天龙 on 2016/12/8.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBDeviceModel : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, strong) UIImage *imageIcon;
@property (nonatomic, copy) NSString *PM;
@property (nonatomic, copy) NSString *temperature;

@end
