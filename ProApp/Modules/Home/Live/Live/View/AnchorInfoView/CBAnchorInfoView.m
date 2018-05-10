//
//  CBAnchorInfoView.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAnchorInfoView.h"
#import "CBAnchorInfoXibView.h"

@implementation CBAnchorInfoView

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
        [self addSubview:self.acnchorInfoXibView];
    }
    return self;
}

- (CBAnchorInfoXibView *)acnchorInfoXibView {
    if (!_acnchorInfoXibView) {
        _acnchorInfoXibView = [CBAnchorInfoXibView viewFromXib];
        _acnchorInfoXibView.frame = CGRectMake(0, 0, self.width, 365);
    }
    return _acnchorInfoXibView;
}

@end
