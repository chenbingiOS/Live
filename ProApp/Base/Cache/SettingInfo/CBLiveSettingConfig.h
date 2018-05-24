//
//  CBLiveSettingConfig.h
//  ProApp
//
//  Created by hxbjt on 2018/5/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBLiveSetting.h"

@interface CBLiveSettingConfig : NSObject

+ (CBLiveSetting *)mySetting;
+ (void)saveSetting:(CBLiveSetting *)setting;
+ (void)clearSetting;

+ (NSString *)share_title;
+ (NSString *)share_des;

+ (NSString *)video_share_title;
+ (NSString *)video_share_des;

+ (NSString *)wx_siteurl;
+ (NSString *)ipa_ver;
+ (NSString *)app_ios;
+ (NSString *)ios_shelves;
+ (NSString *)name_coin;
+ (NSString *)name_votes;
+ (NSString *)enter_tip_level;

+ (NSString *)maintain_switch;  //维护开关
+ (NSString *)maintain_tips;    //维护内容
+ (NSString *)live_pri_switch;  //私密房间开关
+ (NSString *)live_cha_switch;  //收费房间开关

+ (NSString *)live_time_switch;     //计时收费房间开关
+ (NSArray  *)live_time_coin;       //收费阶梯
+ (NSArray  *)live_type;            //房间类型
+ (NSArray  *)share_type;           //分享类型
+ (NSString *)pravitelive_switch;   //私播房间开关

//保存个人中心选项缓存
+ (void)savepersoncontroller:(NSArray *)arrays;
+ (NSArray *)getpersonc;


@end
