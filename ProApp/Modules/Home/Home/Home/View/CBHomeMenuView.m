//
//  CBHomeMenuView.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/14.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBHomeMenuView.h"

@implementation CBHomeMenuView


@end

@implementation CBHomeMenuPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置参数 (否则用默认值)
        self.popType = PopTypeMove;
        self.moveAppearCenterY = kScreenHeight - self.height/2;
        self.moveAppearDirection = MoveAppearDirectionFromBottom;
        self.moveDisappearDirection = MoveDisappearDirectionToBottom;
        self.shadowColor = [UIColor colorWithWhite:1 alpha:0.3];
        self.animateDuration = 0.35;
        self.radius = 0;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.homeMenuView];
        
        @weakify(self);
        [self.homeMenuView.closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            [self hide];
        }];
    }
    return self;
}

- (CBHomeMenuView *)homeMenuView {
    if (!_homeMenuView) {
        _homeMenuView = [CBHomeMenuView viewFromXib];
        _homeMenuView.frame = CGRectMake(0, 0, kScreenWidth, 180);
    }
    return _homeMenuView;
}

@end
