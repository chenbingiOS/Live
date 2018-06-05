//
//  CBCityMenuView.m
//  ProApp
//
//  Created by hxbjt on 2018/6/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBCityMenuView.h"

@implementation CBCityMenuView

@end

@implementation CBCityMenuPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置参数 (否则用默认值)
        self.popType = PopTypeMove;
        self.moveAppearCenterY = kScreenHeight - self.height/2;
        self.moveAppearDirection = MoveAppearDirectionFromBottom;
        self.moveDisappearDirection = MoveDisappearDirectionToBottom;
        self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.animateDuration = 0.35;
        self.radius = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.homeMenuView];
        
//        @weakify(self);
//        [self.homeMenuView.closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            @strongify(self);
//            [self hide];
//        }];
    }
    return self;
}

- (CBCityMenuView *)homeMenuView {
    if (!_homeMenuView) {
        _homeMenuView = [CBCityMenuView viewFromXib];
        _homeMenuView.frame = CGRectMake(0, 0, kScreenWidth, 244);
    }
    return _homeMenuView;
}

@end
