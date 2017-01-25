//
//  WBAreaDetaliCollectionViewCell.m
//  AirMonitor
//
//  Created by 余天龙 on 2016/11/15.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import "WBAreaDetaliCollectionViewCell.h"
#import "Masonry.h"

#import "WBDeviceCollectionViewCell.h"

#import "WBAreaDetailModel.h"
#import "WBDeviceModel.h"

#define SELECT_BRODER_COLOR              (RGB_COLOR(246, 236, 139))

@interface WBAreaDetaliCollectionViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *areaTitleButton;
@property (nonatomic, strong) UIButton *editorAreaTitle;
@property (nonatomic, strong) WBAreaDetailModel *currentAreaDetailModel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<WBDeviceModel *> *devices;

@end

@implementation WBAreaDetaliCollectionViewCell

+ (NSString *)reuseIdentifier {
    return @"AERA_DETAIL_CELL";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(WBAreaDetaliCollectionViewCell);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(WBAreaDetaliCollectionViewCell);
    }
    return self;
}

- (NSMutableArray<WBDeviceModel *> *)devices {
    if (!_devices) {
        _devices = [NSMutableArray new];
    }
    return _devices;
}

commonInitImplementationSafe(WBAreaDetaliCollectionViewCell) {

    self.contentView.userInteractionEnabled = YES;
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 2.0f;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.areaTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.areaTitleButton setTitle:@"" forState:UIControlStateNormal];
    [self.areaTitleButton setTitleColor:COMMON_WHITE_COLOR forState:UIControlStateNormal];
    self.areaTitleButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.areaTitleButton addTarget:self action:@selector(areaTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.areaTitleButton.titleLabel.numberOfLines = 2;
    
    self.editorAreaTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editorAreaTitle setImage:[UIImage imageNamed:@"EditorTitle"] forState:UIControlStateNormal];
    [_editorAreaTitle sizeToFit];
    [_editorAreaTitle addTarget:self action:@selector(editorTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *separator = [UIView new];
    separator.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width - 30, self.height - 40) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.userInteractionEnabled = YES;
    [_collectionView registerClass:[WBDeviceCollectionViewCell class] forCellWithReuseIdentifier:[WBDeviceCollectionViewCell reuseIdentifier]];

    [self.contentView addSubview:self.areaTitleButton];
    [self.contentView addSubview:self.editorAreaTitle];
    [self.contentView addSubview:separator];
    [self.contentView addSubview:self.collectionView];
    
    [self.contentView setNeedsLayout];
    [self.areaTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@45);
        make.trailing.equalTo(self.editorAreaTitle.mas_leading).offset(-5);
        make.height.equalTo(@40);
    }];
    
    [self.editorAreaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.equalTo(@0);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaTitleButton.mas_bottom);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom).offset(20);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.bottom.equalTo(@(-20));
    }];
    [self.contentView layoutIfNeeded];
}

- (void)setIsDragCurrent:(BOOL)isDragCurrent {
    self.contentView.backgroundColor = isDragCurrent ?
    [[UIColor whiteColor] colorWithAlphaComponent:0.3] :
    [[UIColor blackColor] colorWithAlphaComponent:0.2];
}


#pragma mark - Private methods

- (IBAction)areaTitleButtonClick:(UIButton *)sender {
}

- (IBAction)editorTitleButtonClick:(UIButton *)sender {
}

#pragma mark - Public methods

- (void)setupWithModel:(WBAreaDetailModel *)areaDetailModel {
    self.currentAreaDetailModel = areaDetailModel;
    
    [self.areaTitleButton setTitle:areaDetailModel.roomName forState:UIControlStateNormal];
    
    self.devices = [areaDetailModel.devices mutableCopy];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (void)setupCollectionViewOffsetWitnPointValue:(NSValue *)pointValue {
    if (pointValue == nil) {
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        return;
    }
    [self.collectionView setContentOffset:[pointValue CGPointValue] animated:NO];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.devices.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WEAK_SELF();
    WBDeviceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WBDeviceCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    [cell setupWithModel:self.devices[indexPath.row]];

    [cell setLongPressDragBeganBlock:^(CGPoint centerpoint) {
        BLOCK_SAFE_CALLS(weakSelf.longPressDragBeganBlock, centerpoint);
    }];
    [cell setLongPressDragChangeBlock:^(CGPoint centerpoint) {
        BLOCK_SAFE_CALLS(weakSelf.longPressDragChangeBlock, centerpoint);
    }];
    [cell setLongPressDragEndedBlock:^(WBDeviceModel *currentDeviceModel, CGPoint centerpoint) {
        BLOCK_SAFE_CALLS(weakSelf.longPressDragEndedBlock, weakSelf.currentAreaDetailModel, currentDeviceModel, centerpoint);
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((collectionView.width - 5) / 2.0, 97);
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

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGPoint estimateContentOffset = CGPointMake(targetContentOffset -> x, targetContentOffset -> y);
    BLOCK_SAFE_CALLS(self.pointChangeBlock, [NSValue valueWithCGPoint:estimateContentOffset]);
}

@end
