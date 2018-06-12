//
//  CBShortVideoRoomView.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBShortVideoRoomView.h"
#import "CBLiveAnchorView.h"
#import "CBLiveBottomView.h"
#import "UILabel+ShadowText.h"
#import "CBOnlineUserView.h"
#import "CBAnchorInfoView.h"
#import "CBGuardVC.h"
#import "CBGuardRankVC.h"
#import "CBContributionRankVC.h"

#import "JPGiftView.h"
#import "JPGiftCellModel.h"
#import "JPGiftModel.h"
#import "JPGiftShowManager.h"
#import "UIImageView+WebCache.h"
#import "NSObject+YYModel.h"


@interface CBShortVideoRoomView () <JPGiftViewDelegate>

@property (nonatomic, strong) UIView *leftView;             ///< 左边控件容器
@property (nonatomic, strong) UIView *rightView;            ///< 右边控件容器
@property (nonatomic, strong) CBLiveAnchorView *anchorView; ///< 顶部主播相关视图
@property (nonatomic, strong) CBLiveBottomView *bottomView; ///< 底部主播相关视图
@property (nonatomic, strong) UIImageView *topGradientView;      ///< 上部渐变
@property (nonatomic, strong) UIImageView *bottomGradientView;   ///< 下部渐变
@property (nonatomic, strong) UILabel *roomCodeLabel;       ///< 房间号
@property (nonatomic, strong) CBOnlineUserView *onlineUserView; ///< 在线用户
@property (nonatomic, strong) CBAnchorInfoView *anchorInfoView; ///< 直播用户信息


@property (nonatomic, strong) JPGiftView *giftView;     /** gift */

@property (nonatomic, strong) UIImageView *gifImageView;    /** gifimage */

@end

@implementation CBShortVideoRoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.topGradientView];
    [self addSubview:self.bottomGradientView];
    [self addSubview:self.anchorView];
    [self addSubview:self.bottomView];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    @weakify(self);
    [self.anchorView.peopleBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self.onlineUserView showIn:window];
    }];
    [self.anchorView.achorInfoBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self.anchorInfoView showIn:window];
    }];
    [self.anchorView.gurardBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        CBGuardVC *vc = [CBGuardVC new];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.anchorView.guardScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        CBGuardRankVC *vc = [CBGuardRankVC new];
//        [self.navigationController pushViewController:vc animated:YES];
    }]];
    [self.anchorView.moneyBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        CBContributionRankVC *vc = [CBContributionRankVC new];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.bottomView.giftBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self.giftView showGiftView];
    }];
    
//    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
//    NSArray *data = [responseObject objectForKey:@"data"];
//    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:data];
//    self.giftView.dataArray = [NSArray modelArrayWithClass:[JPGiftCellModel class] json:dataArr];
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

- (CBLiveBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [CBLiveBottomView viewFromXib];
        CGFloat y = kScreenHeight - 60;
        if (iPhoneX) y -= 35;
        _bottomView.frame = CGRectMake(0, y, kScreenWidth, 60);
    }
    return _bottomView;
}

- (CBOnlineUserView *)onlineUserView {
    if (!_onlineUserView) {
        _onlineUserView = [[CBOnlineUserView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
    }
    return _onlineUserView;
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
