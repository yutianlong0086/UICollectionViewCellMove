//
//  WBAreaContentManager.h
//  UICollectionViewCellMove
//
//  Created by 余天龙 on 2016/12/8.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBAreaModel;
@class WBAreaDetailModel;

#define GetAreaContentManager()         ([WBAreaContentManager sharedInstance])

@interface WBAreaContentManager : NSObject

+ (instancetype)sharedInstance;

- (void)asyncFetchAreaListCompleteBlock:(void (^)(NSArray<WBAreaModel *> *areas))completed;

- (void)asyncFetchAreaDetailCompleteBlock:(void (^)(NSArray<WBAreaDetailModel *> *areaDetails))completed;

@end
