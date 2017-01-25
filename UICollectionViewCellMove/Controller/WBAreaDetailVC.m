//
//  WBAreaDetailVC.m
//  UICollectionViewCellMove
//
//  Created by 余天龙 on 2016/12/8.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import "WBAreaDetailVC.h"
#import "WBAreaDetailModel.h"
#import "WBAreaDetaliCollectionViewCell.h"
#import "WBAreaContentManager.h"

@interface WBAreaDetailVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<WBAreaDetailModel *> *areasDetail;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSValue *> *pointsValue;  // 处理重用

@end

@implementation WBAreaDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

- (NSMutableDictionary<NSString *,NSValue *> *)pointsValue {
    if (!_pointsValue) {
        _pointsValue = [NSMutableDictionary new];
    }
    return _pointsValue;
}

#pragma mark - Private methods

- (void)setupUI {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_collectionView setCollectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[WBAreaDetaliCollectionViewCell class] forCellWithReuseIdentifier:[WBAreaDetaliCollectionViewCell reuseIdentifier]];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self updateContent];
}

- (void)updateContent {

    WEAK_SELF();
    [GetAreaContentManager() asyncFetchAreaDetailCompleteBlock:^(NSArray<WBAreaDetailModel *> *areaDetails) {
        
        weakSelf.areasDetail= [areaDetails mutableCopy];
        [weakSelf.collectionView reloadData];
    }];
}

// 选中项更新高亮
- (void)judgeDragPositionWithCenterPoint:(CGPoint)centerPoint indexPath:(NSIndexPath *)indexPath {
    
    NSArray<NSIndexPath *> *indexPaths = [self.collectionView indexPathsForVisibleItems];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (indexPath.row != obj.row) {
            WBAreaDetaliCollectionViewCell *cell = (WBAreaDetaliCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:obj];
            CGRect toWindowFrame = [cell convertRect:cell.bounds toView:window];
            cell.isDragCurrent = CGRectContainsPoint(toWindowFrame, centerPoint) ? YES : NO;
        }
    }];
}

// 返回选中项
- (NSIndexPath *)returnSelectedItemWithCenterPoint:(CGPoint)centerPoint indexPath:(NSIndexPath *)indexPath {
    
    NSArray<NSIndexPath *> *indexPaths = [self.collectionView indexPathsForVisibleItems];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    WEAK_SELF();
    __block NSIndexPath *selectedIndexPath = nil;
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (indexPath.row != obj.row) {
            WBAreaDetaliCollectionViewCell *cell = (WBAreaDetaliCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:obj];
            CGRect toWindowFrame = [cell convertRect:cell.bounds toView:window];
            if (CGRectContainsPoint(toWindowFrame, centerPoint)) {
                selectedIndexPath = obj;
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[ obj ]];
            }
        }
    }];
    return selectedIndexPath;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.areasDetail.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WEAK_SELF();
    WBAreaDetaliCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WBAreaDetaliCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    // 初始化重用处理 ***
    [cell setupWithModel:self.areasDetail[indexPath.row]];
    // 内部collectionView的offset
    [cell setupCollectionViewOffsetWitnPointValue:self.pointsValue[INT_TO_STRING(indexPath.row)]];
    // ***
    
    // 长按拖动效果 ***
    cell.isDragCurrent = NO;
    [cell setPointChangeBlock:^(NSValue *pointValue) {
        [weakSelf.pointsValue setObject:pointValue forKey:INT_TO_STRING(indexPath.row)];
    }];
    
    [cell setLongPressDragBeganBlock:^(CGPoint centerPoint) {
        [weakSelf judgeDragPositionWithCenterPoint:centerPoint indexPath:indexPath];
    }];
    [cell setLongPressDragChangeBlock:^(CGPoint centerPoint) {
        [weakSelf judgeDragPositionWithCenterPoint:centerPoint indexPath:indexPath];
    }];
    [cell setLongPressDragEndedBlock:^(WBAreaDetailModel *currentAreaDetailModel, WBDeviceModel *currentDeviceModel, CGPoint centerPoint) {
        
        // 先判断一下拖动到的位置是在哪个 IndexPath 上 (可能为空)
        NSIndexPath *selectedIndexPath = [weakSelf returnSelectedItemWithCenterPoint:centerPoint indexPath:indexPath];
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
        if (!selectedIndexPath) {
            return ;
        } else {
            /*
             *  selectedAreaDetailModel     将要移动到的位置
             *  currentAreaDetailModel      当前数据源的位置
             *  currentDeviceModel          当前设备数据 Model
             */
            
            // 调用自己的重排 API
            WBAreaDetailModel *selectedAreaDetailModel = self.areasDetail[selectedIndexPath.row];
            NSString *str = [NSString stringWithFormat:@"%@ - %@\n\n移动到\n\n%@", currentAreaDetailModel.roomName, currentDeviceModel.deviceName, selectedAreaDetailModel.roomName];
            ShowTips(str);
        }
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((collectionView.width - 5) / 2.0, (collectionView.height - 5) / 2.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

@end
