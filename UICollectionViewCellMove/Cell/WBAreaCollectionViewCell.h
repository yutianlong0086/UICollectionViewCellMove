//
//  WBAreaCollectionViewCell.h
//  AirMonitor
//
//  Created by 余天龙 on 2016/11/11.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBAreaModel;

@interface WBAreaCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)setupWithModel:(WBAreaModel *)areaModel;

@end
