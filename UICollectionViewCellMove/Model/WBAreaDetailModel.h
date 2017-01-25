//
//  WBAreaDetailModel.h
//  UICollectionViewCellMove
//
//  Created by 余天龙 on 2016/12/8.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBDeviceModel.h"

@interface WBAreaDetailModel : NSObject

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, strong) NSArray<WBDeviceModel *> *devices;

@end
