//
//  CBUploadSuccessView.m
//  ProApp
//
//  Created by hxbjt on 2018/6/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBUploadSuccessView.h"

@implementation CBUploadSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation CBUploadSuccessPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置参数 (否则用默认值)
        self.popType = PopTypeScale;
        self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.animateDuration = 0.35;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.homeMenuView];
        
        @weakify(self);
        [self.homeMenuView.closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            [self hide];
        }];
    }
    return self;
}

- (CBUploadSuccessView *)homeMenuView {
    if (!_homeMenuView) {
        _homeMenuView = [CBUploadSuccessView viewFromXib];
        _homeMenuView.frame = CGRectMake(0, 0, 300, 120);
    }
    return _homeMenuView;
}

@end
