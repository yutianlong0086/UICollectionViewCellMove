//
//  WBAreaCollectionViewCell.m
//  AirMonitor
//
//  Created by 余天龙 on 2016/11/11.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import "WBAreaCollectionViewCell.h"
#import "WBAreaModel.h"
#import "Masonry.h"

#define IMAGEVIEW_MARGIN                 (10)
#define DEFAULT_BRODER_COLOR             [UIColor whiteColor]
#define SELECT_BRODER_COLOR              (RGB_COLOR(246, 236, 139))

@interface WBAreaCollectionViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *itemName;
@property (nonatomic, strong) UILabel *itemValue;
@property (nonatomic, strong) UILabel *itemUnit;
@property (nonatomic, strong) UILabel *areaTitle;

@property (nonatomic, assign) CGSize oldSize;

@end

@implementation WBAreaCollectionViewCell

+ (NSString *)reuseIdentifier {
    return @"AREA_COLLECTION_CELL";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(WBAreaCollectionViewCell);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(WBAreaCollectionViewCell);
    }
    return self;
}

commonInitImplementationSafe(WBAreaCollectionViewCell) {
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.userInteractionEnabled = YES;
    
    self.itemName = [[UILabel alloc] init];
    self.itemName.textColor = COMMON_FONT_BLACK;
    self.itemName.textAlignment = NSTextAlignmentCenter;
    self.itemName.adjustsFontSizeToFitWidth = YES;
    self.itemName.numberOfLines = 1;
    self.itemName.font = [UIFont systemFontOfSize:15];
    
    self.itemValue = [[UILabel alloc] init];
    self.itemValue.textColor = RGB_COLOR(214, 38, 49);
    self.itemValue.textAlignment = NSTextAlignmentCenter;
    self.itemValue.adjustsFontSizeToFitWidth = YES;
    self.itemValue.numberOfLines = 1;
    self.itemValue.font = [UIFont systemFontOfSize:25];

    self.itemUnit = [[UILabel alloc] init];
    self.itemUnit.textColor = COMMON_FONT_BLACK;
    self.itemUnit.textAlignment = NSTextAlignmentCenter;
    self.itemUnit.adjustsFontSizeToFitWidth = YES;
    self.itemUnit.numberOfLines = 1;
    self.itemUnit.font = [UIFont systemFontOfSize:15];
    
    self.areaTitle = [[UILabel alloc] init];
    self.areaTitle.textColor = COMMON_FONT_BLACK;
    self.areaTitle.textAlignment = NSTextAlignmentCenter;
    self.areaTitle.adjustsFontSizeToFitWidth = YES;
    self.areaTitle.numberOfLines = 1;
    self.areaTitle.font = [UIFont systemFontOfSize:17];
    
    [self.contentView addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.itemName];
    [self.backgroundImageView addSubview:self.itemValue];
    [self.backgroundImageView addSubview:self.itemUnit];
    [self.contentView addSubview:self.areaTitle];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.leading.equalTo(@IMAGEVIEW_MARGIN);
        make.trailing.equalTo(@(-IMAGEVIEW_MARGIN));
        make.height.equalTo(self.backgroundImageView.mas_width);
    }];
    
    [self.itemValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@5);
        make.trailing.equalTo(@(-5));
        make.centerY.equalTo(self.backgroundImageView.mas_centerY);
        make.height.equalTo(@30);
    }];
    
    [self.itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.itemValue.mas_top);
        make.leading.equalTo(@25);
        make.trailing.equalTo(@(-25));
        make.height.equalTo(@20);
    }];
    
    [self.itemUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemValue.mas_bottom);
        make.leading.equalTo(@(25));
        make.trailing.equalTo(@(-25));
        make.height.equalTo(@20);
    }];
    
    [self.areaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backgroundImageView.mas_bottom);
        make.height.equalTo(@20);
        make.leading.trailing.bottom.equalTo(@0);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.size, self.oldSize)) {
        self.oldSize = self.size;
        
        [self adjustImageView];
    }
}

#pragma mark - Getter , Setter methods

#pragma mark - Private methods

- (void)adjustImageView {

    self.backgroundImageView.layer.masksToBounds = YES;
    self.backgroundImageView.layer.cornerRadius = (self.width - 2 * IMAGEVIEW_MARGIN) / 2.0;
    self.backgroundImageView.layer.borderWidth = 2.0;
    self.backgroundImageView.layer.borderColor = DEFAULT_BRODER_COLOR.CGColor;
}

#pragma mark - Public methods

- (void)setupWithModel:(WBAreaModel *)areaModel {
    
    self.areaTitle.text = areaModel.areaTitle;
    self.backgroundImageView.image = areaModel.backgroundImageView;
    self.itemName.text = areaModel.itemName;
    self.itemValue.text = areaModel.itemValue;
    self.itemUnit.text = areaModel.itemUnit;
}

@end
