//
//  CBRoomView.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBRoomView.h"

@interface CBRoomView () <JPGiftViewDelegate>

@end

@implementation CBRoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.rightView];
    [self.leftView addSubview:self.roomCodeLabel];
    [self.rightView addSubview:self.topGradientView];
    [self.rightView addSubview:self.bottomGradientView];
    [self.rightView addSubview:self.anchorView];
}

- (void)giftViewSendGiftInView:(JPGiftView *)giftView data:(JPGiftCellModel *)model {
    NSLog(@"点击-- %@",model.name);
    JPGiftModel *giftModel = [[JPGiftModel alloc] init];
    giftModel.userIcon = model.icon;
    giftModel.userName = model.username;
    giftModel.giftName = model.name;
    giftModel.giftImage = model.icon;
    giftModel.giftGifImage = model.icon_gif;
    giftModel.giftId = model.id;
    giftModel.defaultCount = 0;
    giftModel.sendCount = 1;
    
    [[JPGiftShowManager sharedManager] showGiftViewWithBackView:self.rightView info:giftModel completeBlock:^(BOOL finished) {
        //结束
    } completeShowGifImageBlock:^(JPGiftModel *giftModel) {
        //展示gifimage
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self.gifImageView];
            [self.gifImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.giftGifImage]];
            self.gifImageView.hidden = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.gifImageView.hidden = YES;
                [self.gifImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
                [self.gifImageView removeFromSuperview];
            });
        });
    }];
}

- (void)giftViewGetMoneyInView:(JPGiftView *)giftView {
    NSLog(@"充值");
}

#pragma mark - layz
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight);
        _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _leftView.backgroundColor = [UIColor clearColor];
    }
    return _leftView;
}

- (UILabel *)roomCodeLabel {
    if (!_roomCodeLabel) {
        _roomCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 100, 30)];
        _roomCodeLabel.textColor = [UIColor whiteColor];
        _roomCodeLabel.font = [UIFont systemFontOfSize:13];
        [_roomCodeLabel shadowWtihText:@"房间号:11214"];
    }
    return _roomCodeLabel;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        _rightView.backgroundColor = [UIColor clearColor];
    }
    return _rightView;
}

- (UIImageView *)topGradientView {
    if (!_topGradientView) {
        _topGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
        _topGradientView.image = [UIImage imageNamed:@"topGradient"];
    }
    return _topGradientView;
}

- (UIView *)bottomGradientView {
    if (!_bottomGradientView) {
        _bottomGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-205, kScreenWidth, 205)];
        _bottomGradientView.image = [UIImage imageNamed:@"bottomGradient"];
    }
    return _bottomGradientView;
}

- (CBLiveAnchorView *)anchorView {
    if (!_anchorView) {
        _anchorView = [CBLiveAnchorView viewFromXib];
        CGFloat y = 0;
        if (iPhoneX) y += 10;
        _anchorView.frame = CGRectMake(0, y, kScreenWidth, 130);
    }
    return _anchorView;
}

- (CBAnchorInfoView *)anchorInfoView {
    if (!_anchorInfoView) {
        _anchorInfoView = [[CBAnchorInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 365)];
    }
    return _anchorInfoView;
}

- (UIImageView *)gifImageView{
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 0, 360, 225)];
        _gifImageView.hidden = YES;
    }
    return _gifImageView;
}

- (JPGiftView *)giftView{
    if (!_giftView) {
        _giftView = [[JPGiftView alloc] init];
        _giftView.delegate = self;
    }
    return _giftView;
}

@end
