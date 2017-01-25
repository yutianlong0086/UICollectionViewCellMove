//
//  WBAreaDetaliCollectionViewCell.h
//  AirMonitor
//
//  Created by 余天龙 on 2016/11/15.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBAreaDetailModel;
@class WBDeviceModel;

@interface WBAreaDetaliCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)setupWithModel:(WBAreaDetailModel *)areaDetailModel;

// 处理重用
- (void)setupCollectionViewOffsetWitnPointValue:(NSValue *)pointValue;

@property (nonatomic, copy) void (^pointChangeBlock)(NSValue *pointValue);

@property (nonatomic, assign) BOOL isDragCurrent;

// 长按拖动回调
@property (nonatomic, copy) void (^longPressDragBeganBlock)(CGPoint centerPoint);

@property (nonatomic, copy) void (^longPressDragChangeBlock)(CGPoint centerPoint);

@property (nonatomic, copy) void (^longPressDragEndedBlock)(WBAreaDetailModel *currentAreaDetailModel, WBDeviceModel *currentDeviceModel, CGPoint centerPoint);


@end
