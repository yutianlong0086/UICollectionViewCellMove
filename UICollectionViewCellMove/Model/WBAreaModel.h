//
//  WBAreaModel.h
//  UICollectionViewCellMove
//
//  Created by 余天龙 on 2016/12/8.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBAreaModel : NSObject

@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *areaTitle;
@property (nonatomic, strong) UIImage *backgroundImageView;

@property (nonatomic, copy) NSString *itemName;     //PM
@property (nonatomic, copy) NSString *itemValue;    //62.36
@property (nonatomic, copy) NSString *itemUnit;     //ug/m3

@end
