//
//  WBDeviceCollectionViewCell.h
//  AirMonitor
//
//  Created by 余天龙 on 2016/11/16.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBDeviceModel;

@interface WBDeviceCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)setupWithModel:(WBDeviceModel *)deviceModel;

@property (nonatomic, assign) BOOL isDisableLongPress;  // 是否禁用自定义长按手势

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) void (^longPressDragBeganBlock)(CGPoint centerPoint);

@property (nonatomic, copy) void (^longPressDragChangeBlock)(CGPoint centerPoint);

@property (nonatomic, copy) void (^longPressDragEndedBlock)(WBDeviceModel *currentDeviceModel, CGPoint centerPoint);

@end
