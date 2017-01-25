//
//  WBDeviceCollectionViewCell.m
//  AirMonitor
//
//  Created by 余天龙 on 2016/11/16.
//  Copyright © 2016年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import "WBDeviceCollectionViewCell.h"
#import "Masonry.h"

#import "WBDeviceModel.h"
#import "WBDeviceInfo.h"

#define Duration 0.2
#define SELECT_BRODER_COLOR              (RGB_COLOR(246, 236, 139))

@interface WBDeviceCollectionViewCell ()

@property (nonatomic, strong) WBDeviceModel *currentDeviceModel;

@property (nonatomic, strong) UILabel *deviceName;
@property (nonatomic, strong) UIImageView *deviceImageView;
@property (nonatomic, strong) UILabel *pmValue;
@property (nonatomic, strong) UILabel *temperature;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

// 长按属性
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint originPoint;

@property (nonatomic, strong) UIView *snapshotView;


@end

@implementation WBDeviceCollectionViewCell

+ (NSString *)reuseIdentifier {
    return @"DEVICE_CELL";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(WBDeviceCollectionViewCell);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(WBDeviceCollectionViewCell);
    }
    return self;
}

commonInitImplementationSafe(WBDeviceCollectionViewCell) {
    
    self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.layer.borderWidth = 2.0f;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.deviceName = [[UILabel alloc] init];
    self.deviceName.textColor = COMMON_FONT_BLACK;
    self.deviceName.textAlignment = NSTextAlignmentCenter;
    self.deviceName.adjustsFontSizeToFitWidth = YES;
    self.deviceName.numberOfLines = 2;
    self.deviceName.font = [UIFont systemFontOfSize:13];
    
    self.deviceImageView = [[UIImageView alloc] init];
    
    UIImageView *PMIcon = [[UIImageView alloc] init];
    PMIcon.image = [UIImage imageNamed:@"PMIcon"];
    
    self.pmValue = [[UILabel alloc] init];
    self.pmValue.textColor = RGB_COLOR(46, 252, 135);
    self.pmValue.textAlignment = NSTextAlignmentCenter;
    self.pmValue.adjustsFontSizeToFitWidth = YES;
    self.pmValue.numberOfLines = 1;
    self.pmValue.font = [UIFont systemFontOfSize:15];
    
    UILabel *pmUnit = [[UILabel alloc] init];
    pmUnit.text = @"ug/m³";
    pmUnit.textColor = COMMON_FONT_BLACK;
    pmUnit.adjustsFontSizeToFitWidth = YES;
    pmUnit.numberOfLines = 1;
    pmUnit.font = [UIFont systemFontOfSize:11];
    
    UIView *separator = [UIView new];
    separator.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    
    UIImageView *temperatureIcon = [[UIImageView alloc] init];
    temperatureIcon.image = [UIImage imageNamed:@"TemperatureIcon"];
    
    self.temperature = [[UILabel alloc] init];
    self.temperature.textColor = RGB_COLOR(46, 252, 135);
    self.temperature.textAlignment = NSTextAlignmentCenter;
    self.temperature.adjustsFontSizeToFitWidth = YES;
    self.temperature.numberOfLines = 1;
    self.temperature.font = [UIFont systemFontOfSize:15];

    UILabel *temperatureUnit = [[UILabel alloc] init];
    temperatureUnit.text = @"℃";
    temperatureUnit.textColor = COMMON_FONT_BLACK;
    temperatureUnit.adjustsFontSizeToFitWidth = YES;
    temperatureUnit.numberOfLines = 1;
    temperatureUnit.font = [UIFont systemFontOfSize:11];
    
    [self.contentView addSubview:self.deviceName];
    [self.contentView addSubview:self.deviceImageView];
    [self.contentView addSubview:PMIcon];
    [self.contentView addSubview:self.pmValue];
    [self.contentView addSubview:pmUnit];
    [self.contentView addSubview:separator];
    [self.contentView addSubview:temperatureIcon];
    [self.contentView addSubview:self.temperature];
    [self.contentView addSubview:temperatureUnit];
    
    [self.deviceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.bottom.equalTo(self.deviceImageView.mas_top).offset(-3);
        make.height.lessThanOrEqualTo(@27);
    }];
    
    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceName.mas_bottom).offset(3);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.height.lessThanOrEqualTo(@15);
    }];
    
    [self.pmValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(separator.mas_top).offset(-3);
        make.leading.equalTo(PMIcon.mas_trailing);
        make.trailing.equalTo(pmUnit.mas_leading);
        make.width.lessThanOrEqualTo(@25);
        make.height.equalTo(@18);
    }];
    
    [self.pmValue setContentCompressionResistancePriority:(UILayoutPriorityDefaultHigh + 1) forAxis:UILayoutConstraintAxisHorizontal];

    [PMIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pmValue.mas_bottom);
        make.trailing.equalTo(self.pmValue.mas_leading);
        make.top.equalTo(self.pmValue.mas_top).offset(5);
        make.leading.equalTo(@5);
    }];
    
    [pmUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pmValue.mas_bottom);
        make.leading.equalTo(self.pmValue.mas_trailing);
        make.top.equalTo(self.pmValue.mas_top).offset(5);
        make.trailing.equalTo(@(-5));
    }];

    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pmValue.mas_bottom).offset(3);
        make.leading.equalTo(@5);
        make.trailing.equalTo(@(-5));
        make.bottom.equalTo(self.temperature.mas_top);
        make.height.equalTo(@1);
    }];
    
    [self.temperature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separator.mas_bottom);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(@(-3));
        make.leading.equalTo(temperatureIcon.mas_trailing).offset(2);
        make.trailing.equalTo(temperatureUnit.mas_leading);
        make.width.lessThanOrEqualTo(@25);
        make.height.equalTo(@18);
    }];
    
    [self.temperature setContentCompressionResistancePriority:(UILayoutPriorityDefaultHigh + 1) forAxis:UILayoutConstraintAxisHorizontal];
    
    [temperatureIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.temperature.mas_bottom);
        make.trailing.equalTo(self.temperature.mas_leading).offset(-2);
        make.top.equalTo(self.temperature.mas_top).offset(5);
        make.width.equalTo(@10);
    }];
    
    [temperatureUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.temperature.mas_bottom);
        make.leading.equalTo(self.temperature.mas_trailing);
        make.top.equalTo(self.temperature.mas_top).offset(5);
        make.trailing.equalTo(@(-5));
    }];
    
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(selfContentViewLongPressed:)];
    [self.contentView addGestureRecognizer:self.longPressGesture];
}

- (void)setIsDisableLongPress:(BOOL)isDisableLongPress {
    self.longPressGesture.enabled = !isDisableLongPress;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    
    self.contentView.layer.borderColor = isSelect ? SELECT_BRODER_COLOR.CGColor : [UIColor clearColor].CGColor;
}


#pragma mark - Public methods

- (void)setupWithModel:(WBDeviceModel *)deviceModel {
    
    self.currentDeviceModel = deviceModel;
    
    self.deviceName.text = deviceModel.deviceName;
    self.deviceImageView.image = deviceModel.imageIcon;
    self.deviceImageView.highlightedImage = deviceModel.imageIcon;
    self.pmValue.text = deviceModel.PM;
    self.temperature.text = deviceModel.temperature;
}

#pragma mark - UIGestureRecognizer

- (void)selfContentViewLongPressed:(UILongPressGestureRecognizer *)sender {
    
    UIView *view = (UIView *)sender.view;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        _startPoint = [sender locationInView:sender.view];
        _originPoint = view.center;
        
        // iphone7及以上 或者 模拟器，自己绘制快照
        if ([[GetDeviceInfo() getCurrentDeviceModel] isEqualToString:@"iPhone7"] || [[GetDeviceInfo() getCurrentDeviceModel] isEqualToString:@"iPhone7Plus"] || [[GetDeviceInfo() getCurrentDeviceModel] isEqualToString:@"iPhoneSimulator"] ) {
                self.snapshotView = [[UIImageView alloc] initWithImage:[UIImage imageFromView:view]];
        } else {
            self.snapshotView = [view snapshotViewAfterScreenUpdates:NO];
        }
        
        // 添加在 window 上
        [window addSubview:self.snapshotView];
        CGRect toWindowFrame = [view convertRect:view.bounds toView:window];
        self.snapshotView.frame = toWindowFrame;
        
        [UIView animateWithDuration:Duration animations:^{
            // 放大1.1倍
            self.snapshotView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.snapshotView.alpha = 0.9;
        }];
        
        BLOCK_SAFE_CALLS(self.longPressDragBeganBlock, [self fetchCenterPointWithRect:toWindowFrame]);
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x - _startPoint.x;
        CGFloat deltaY = newPoint.y - _startPoint.y;
        view.center = CGPointMake(view.center.x + deltaX, view.center.y + deltaY);
        
        CGRect toWindowFrame = [view convertRect:view.bounds toView:window];
        self.snapshotView.frame = toWindowFrame;
        
        BLOCK_SAFE_CALLS(self.longPressDragChangeBlock, [self fetchCenterPointWithRect:toWindowFrame]);
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:Duration animations:^{
            self.snapshotView.transform = CGAffineTransformIdentity;
            self.snapshotView.alpha = 1.0;
        }];
        
        [self.snapshotView removeFromSuperview];
        self.snapshotView = nil;
        
        CGRect toWindowFrame = [view convertRect:view.bounds toView:window];
        
        BLOCK_SAFE_CALLS(self.longPressDragEndedBlock, self.currentDeviceModel, [self fetchCenterPointWithRect:toWindowFrame]);
    }
}

- (CGPoint)fetchCenterPointWithRect:(CGRect)rect {
    return CGPointMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + rect.size.height / 2.0);
}

@end
