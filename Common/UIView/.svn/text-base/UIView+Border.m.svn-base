//
//  UIView+Border.m
//  Whistle
//
//  Created by ZhangAo on 15/11/24.
//  Copyright © 2015年 BookSir. All rights reserved.
//

#import "UIView+Border.h"
#import "Masonry.h"

@implementation UIView (Border)

- (void)addTopBorder {
	UIView *separator = [self createHorizonSeparator];
	[separator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_top).offset(-0.5);
	}];
}

- (void)addBottomBorder {
	UIView *separator = [self createHorizonSeparator];
	[separator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.mas_bottom);
	}];
}

- (void)addTopAndBottomBorder {
	[self addTopBorder];
	[self addBottomBorder];
}

- (void)addVerticalCenterBorder {
	UIView *separator = [self createHorizonSeparator];
	[separator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(@0);
	}];
}

- (UIView *)createHorizonSeparator {
	UIView *separator = [UIView new];
	separator.backgroundColor = (RGB_COLOR(239, 239, 239)) ;
	[self addSubview:separator];
	[separator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@0.5);
		make.leading.equalTo(@0);
		make.width.equalTo(self.mas_width);
	}];
	return separator;
}

- (UIView *)createVerticalSeparator {
	UIView *separator = [UIView new];
	separator.backgroundColor = (RGB_COLOR(239, 239, 239));
	[self addSubview:separator];
	[separator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(@0);
		make.width.equalTo(@0.5);
	}];
	return separator;
}

@end
