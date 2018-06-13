//
//  CBLiveBottomView.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/25.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLiveBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *barrageBtn;      ///< 普通消息
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;        ///< 分享按钮
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;         ///< 礼物功能
@property (weak, nonatomic) IBOutlet UIButton *noticeBoardBtn;  ///< 侧边功能
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;      ///< 私信功能

@end
