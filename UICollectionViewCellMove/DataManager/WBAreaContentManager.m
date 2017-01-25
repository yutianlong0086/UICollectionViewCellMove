//
//  WBAreaContentManager.m
//  UICollectionViewCellMove
//
//  Created by 余天龙 on 2016/12/8.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import "WBAreaContentManager.h"
#import "WBAreaModel.h"
#import "WBAreaDetailModel.h"
#import "WBDeviceModel.h"

@interface WBAreaContentManager ()

@end

@implementation WBAreaContentManager

+ (instancetype)sharedInstance {
    return [self sharedInstance:YES];
}

static NSMutableDictionary *instances;
static NSLock *lock;
+ (instancetype)sharedInstance:(BOOL)createIfNotExists {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instances = [NSMutableDictionary dictionary];
        lock = [NSLock new];
    });
    
    @synchronized (lock) {
        NSString *key = NSStringFromClass([self class]);
        id object = instances[key];
        if (object == nil && createIfNotExists) {
            object = [self new];
            [instances setObject:object forKey:key];
        }
        
        return object;
    }
}

- (void)asyncFetchAreaListCompleteBlock:(void (^)(NSArray<WBAreaModel *> *areas))completed {

    NSMutableArray<WBAreaModel *> *areas = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < 12; i ++) {
        WBAreaModel *area = [WBAreaModel new];
        area.areaId = INT_TO_STRING(i);
        area.areaTitle = [NSString stringWithFormat:@"家居 %d", i];
        area.backgroundImageView = [UIImage imageNamed:@"TestChangTu"];
        area.itemName = @"PM";
        area.itemValue = @"62.3";
        area.itemUnit = @"ug/m3";
        
        [areas addObject:area];
    }
    BLOCK_SAFE_CALLS(completed, areas);
}

- (void)asyncFetchAreaDetailCompleteBlock:(void (^)(NSArray<WBAreaDetailModel *> *areaDetails))completed {

    NSMutableArray<WBAreaDetailModel *> *areaDetail = [NSMutableArray new];
    for (int i = 1; i < 11; i ++) {
        
        WBAreaDetailModel *areDetailModel = [WBAreaDetailModel new];
        areDetailModel.roomId = INT_TO_STRING(i);
        areDetailModel.roomName = [NSString stringWithFormat:@"卧室 %d", i];
        
        NSMutableArray<WBDeviceModel *> *devices = [NSMutableArray new];
        for (int j = 1; j <=8 ; j ++) {
            WBDeviceModel *deviceModel = [WBDeviceModel new];
            deviceModel.deviceId = INT_TO_STRING(j);
            deviceModel.deviceName = [NSString stringWithFormat:@"设备 %d", j];
            deviceModel.imageIcon = [UIImage imageNamed:[NSString stringWithFormat:@"chanpin%d", j / 2]];
            deviceModel.PM = @"22";
            deviceModel.temperature = @"25";
            
            [devices addObject:deviceModel];
        }
        areDetailModel.devices = [devices copy];
        
        [areaDetail addObject:areDetailModel];
    }
    BLOCK_SAFE_CALLS(completed, areaDetail);

}

@end
