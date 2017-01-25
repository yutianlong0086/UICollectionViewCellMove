//
//  UICollectionView+TLCellRearrange.h
//  UICollectionViewCellMove
//
//  Created by 余天龙 on 2016/12/9.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICollectionViewCellRearrangeDelegate <NSObject>

@optional

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
        shouldMoveCell:(nonnull UICollectionViewCell *)cell
           atIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)collectionView:(nonnull UICollectionView *)collectionView
           putDownCell:(nonnull UICollectionViewCell *)cell
           atIndexPath:(nonnull NSIndexPath *)indexPath;

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
        shouldMoveCell:(nonnull UICollectionViewCell *)cell
         fromIndexPath:(nonnull NSIndexPath *)fromIndexPath
           toIndexPath:(nonnull NSIndexPath *)toIndexPath;

- (void)collectionView:(nonnull UICollectionView *)collectionView
           didMoveCell:(nonnull UICollectionViewCell *)cell
         fromIndexPath:(nonnull NSIndexPath *)fromIndexPath
           toIndexPath:(nonnull NSIndexPath *)toIndexPath;

@end

@interface UICollectionView (TLCellRearrange)

@property (nonatomic, weak) id<UICollectionViewCellRearrangeDelegate> _Nullable rearrangeDelegate;

@property (nonatomic, assign) BOOL enableRearrangement;

/**
 *  长按cell接触边缘时collectionView自动滚动的速率，每1/60秒移动的距离
 */
@property (nonatomic, assign) CGFloat autoScrollSpeed;

/**
 *  长按放大倍数
 *  默认为1.2
 */
@property (nonatomic, assign) CGFloat longPressMagnificationFactor;

@end
