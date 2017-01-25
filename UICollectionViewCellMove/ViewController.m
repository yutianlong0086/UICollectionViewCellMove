//
//  ViewController.m
//  UICollectionViewCellMove
//
//  Created by 余天龙 on 2016/12/8.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import "ViewController.h"
#import "WBAreaModel.h"
#import "WBAreaCollectionViewCell.h"
#import "WBAreaContentManager.h"

#import "WBAreaDetailVC.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewCellRearrangeDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<WBAreaModel *> *areaModels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = RGB_COLOR(228, 228, 227);

    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

- (NSMutableArray<WBAreaModel *> *)areaModels {
    if (!_areaModels) {
        _areaModels = [NSMutableArray new];
    }
    return _areaModels;
}

#pragma mark - Private methods

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_collectionView setCollectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[WBAreaCollectionViewCell class] forCellWithReuseIdentifier:[WBAreaCollectionViewCell reuseIdentifier]];
    _collectionView.rearrangeDelegate = self;
    _collectionView.enableRearrangement = YES;
    _collectionView.autoScrollSpeed = 3;
    _collectionView.longPressMagnificationFactor = 1.2;

    [self updateContent];
}

- (void)updateContent {
    
    WEAK_SELF();
    [GetAreaContentManager() asyncFetchAreaListCompleteBlock:^(NSArray<WBAreaModel *> *areas) {
       
        weakSelf.areaModels = [areas mutableCopy];
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.areaModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WBAreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WBAreaCollectionViewCell reuseIdentifier] forIndexPath:indexPath];

    [cell setupWithModel:self.areaModels[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return  CGSizeMake((collectionView.width - 20) / 3.0, ((collectionView.width - 20) / 3.0) + 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    WBAreaDetailVC *areaDetailVC = [WBAreaDetailVC new];
    areaDetailVC.navigationItem.title = self.areaModels[indexPath.row].areaTitle;
    [self.navigationController pushViewController:areaDetailVC animated:YES];
}

#pragma mark - UICollectionViewCellRearrangeDelegate methods

- (BOOL)collectionView:(UICollectionView *)collectionView shouldMoveCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        // 如果不需要参与 长按拖动 和 重排效果 的cell， 在这里判断返回NO 即可。
        return NO;
    }
    NSLog(@"开始位置:%ld", indexPath.row);
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView putDownCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // 最终停留在的
    NSLog(@"最终到:%ld",  indexPath.row);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldMoveCell:(UICollectionViewCell *)cell fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    id tempObject = self.areaModels[fromIndexPath.row];
    [self.areaModels removeObjectAtIndex:fromIndexPath.row];
    [self.areaModels insertObject:tempObject atIndex:toIndexPath.row];
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didMoveCell:(UICollectionViewCell *)cell fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // 途径的位置
    NSLog(@"从:%ld, 到x:%ld", fromIndexPath.row, toIndexPath.row);
}

@end
