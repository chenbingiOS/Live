//
//  CBRoomView.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
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


@interface CBRoomView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;         ///< 实现左滑清空数据
@property (nonatomic, strong) UIView *leftView;                 ///< 左边控件容器
@property (nonatomic, strong) UIView *rightView;                ///< 右边控件容器
@property (nonatomic, strong) CBLiveAnchorView *anchorView;     ///< 顶部主播相关视图
@property (nonatomic, strong) UIImageView *topGradientView;     ///< 上部渐变
@property (nonatomic, strong) UIImageView *bottomGradientView;  ///< 下部渐变
@property (nonatomic, strong) UILabel *roomCodeLabel;           ///< 房间号
@property (nonatomic, strong) CBOnlineUserView *onlineUserView; ///< 在线用户
@property (nonatomic, strong) CBAnchorInfoView *anchorInfoView; ///< 直播用户信息
@property (nonatomic, strong) JPGiftView *giftView;             /** gift */
@property (nonatomic, strong) UIImageView *gifImageView;        /** gifimage */

@end
