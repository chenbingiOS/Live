//
//  CBLiveAnchorView.h
//  MiaowShow
//
//  Created by ALin on 16/6/16.
//  Copyright © 2016年 ALin. All rights reserved.
//  直播间主播相关的视图

#import <UIKit/UIKit.h>

@class CBAppLiveVO;
@class ALinUser;

@interface CBLiveAnchorView : UIView

/** 主播 */
@property(nonatomic, strong) ALinUser *user;
/** 直播 */
@property(nonatomic, strong) CBAppLiveVO *live;
/** 点击开关  */
@property(nonatomic, copy)void (^clickDeviceShow)(bool selected);

@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;       ///< 观看人数
@property (weak, nonatomic) IBOutlet UIButton *achorInfoBtn;    ///< 主播信息
@property (weak, nonatomic) IBOutlet UIButton *gurardBtn;       ///< 守护
@property (weak, nonatomic) IBOutlet UIScrollView *guardScrollView; ///< 守护列表
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;   ///< 贡献币


@end
