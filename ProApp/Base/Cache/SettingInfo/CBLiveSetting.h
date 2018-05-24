//
//  CBLiveSetting.h
//  ProApp
//
//  Created by hxbjt on 2018/5/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBLiveSetting : NSObject

@property (nonatomic, strong) NSString *video_share_title;//分享话语
@property (nonatomic, strong) NSString *video_share_des;//分享话语
@property (nonatomic, strong) NSString *share_title;//分享话语
@property (nonatomic, strong) NSString *share_des;//分享话语
@property (nonatomic, strong) NSString *wx_siteurl;//分享微信观看页面
@property (nonatomic, strong) NSString *ipa_ver;//ios版本号
@property (nonatomic, strong) NSString *app_ios;//分享ios下载链接
@property (nonatomic, strong) NSString *ios_shelves;//用于上架隐藏  1代表正常。其他为隐藏
@property (nonatomic, strong) NSString *name_coin;//显示钻石文字
@property (nonatomic, strong) NSString *name_votes;//显示魅力值文字
@property (nonatomic, strong) NSString *enter_tip_level;//金光一闪等级

@property (nonatomic, strong) NSString *maintain_switch;  //维护开关
@property (nonatomic, strong) NSString *maintain_tips;    //维护信息
@property (nonatomic, strong) NSString *live_pri_switch;  //私密房间开关
@property (nonatomic, strong) NSString *live_cha_switch;  //收费房间开关

@property (nonatomic, strong) NSString *live_time_switch;  //计时收费房间开关
@property (nonatomic, strong) NSArray *live_time_coin;    //收费阶梯
@property (nonatomic, strong) NSArray *live_type;         //房间类型
@property (nonatomic, strong) NSArray *share_type;        //分享类型

@property (nonatomic,strong) NSString *pravitelive_switch; //私播开关

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
