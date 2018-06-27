//
//  CBLiveCastView.m
//  EaseMobLiveDemo
//
//  Created by EaseMob on 16/7/26.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "CBLiveCastView.h"

#import "CBAppLiveVO.h"

@interface CBLiveCastView () {
    CBAppLiveVO *_room;
}

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *openGuardBtn;

@end

@implementation CBLiveCastView

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO*)room {
    self = [super initWithFrame:frame];
    if (self) {
        _room = room;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CGRectGetHeight(frame)/2;
        
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.openGuardBtn];
    }
    return self;
}

- (UIImageView*)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.frame = CGRectMake(0, 0, self.height, self.height);
        _headImageView.image = [UIImage imageNamed:@"live_guard"];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = CGRectGetHeight(_headImageView.frame)/2;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImageView;
}

- (UILabel*)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(35, 0.f, 30.f, self.height);
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"守护";
    }
    return _nameLabel;
}


- (UIButton *)openGuardBtn {
    if (!_openGuardBtn) {
        _openGuardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat left = self.width-50;
        _openGuardBtn.frame = CGRectMake(left, 0, 50, 30);
        _openGuardBtn.layer.cornerRadius = 15;
        _openGuardBtn.layer.masksToBounds = YES;
        _openGuardBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _openGuardBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        [_openGuardBtn addTarget:self action:@selector(actionBtnOpenGuard) forControlEvents:UIControlEventTouchUpInside];
        [_openGuardBtn setTitle:@"开通" forState:UIControlStateNormal];
        [_openGuardBtn setBackgroundImage:[UIImage imageNamed:@"btn_guard_pre"] forState:UIControlStateNormal];
        [_openGuardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _openGuardBtn;
}

// 开通守护
- (void)actionBtnOpenGuard {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionLiveOpenGuard)]) {
        [self.delegate actionLiveOpenGuard];
    }
}

@end
