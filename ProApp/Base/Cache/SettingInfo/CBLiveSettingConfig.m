//
//  CBLiveSettingConfig.m
//  ProApp
//
//  Created by hxbjt on 2018/5/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveSettingConfig.h"

NSString *const share_title = @"share_title";
NSString *const share_des = @"share_des";
NSString *const wx_siteurl = @"wx_siteurl";
NSString *const ipa_ver = @"ipa_ver";
NSString *const app_ios = @"app_ios";
NSString *const ios_shelves = @"ios_shelves";
NSString *const name_coin = @"name_coin";
NSString *const name_votes = @"name_votes";
NSString *const enter_tip_level = @"enter_tip_level";

NSString *const maintain_switch = @"maintain_switch";
NSString *const maintain_tips = @"maintain_tips";
NSString *const live_cha_switch = @"live_cha_switch";
NSString *const live_pri_switch = @"live_pri_switch";

NSString *const live_time_coin = @"live_time_coin";
NSString *const live_time_switch = @"live_time_switch";
NSString *const live_type = @"live_type";
NSString *const share_type = @"share_type";

NSString *const video_share_title = @"video_share_title";
NSString *const video_share_des = @"video_share_des";

NSString *const personc = @"personc";

NSString *const pravitelive_switch = @"pravitelive_switch";

#define connectname @"xin-"//数据互通标志

@implementation CBLiveSettingConfig

+ (CBLiveSetting *)mySetting {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CBLiveSetting *user = [[CBLiveSetting alloc] init];
    user.share_title = [userDefaults objectForKey:share_title];
    user.video_share_title = [userDefaults objectForKey:video_share_title];
    user.video_share_des = [userDefaults objectForKey:video_share_des];
    user.share_des = [userDefaults objectForKey:share_des];
    user.wx_siteurl = [userDefaults objectForKey:wx_siteurl];
    user.ipa_ver = [userDefaults objectForKey:ipa_ver];
    user.app_ios = [userDefaults objectForKey:app_ios];
    user.ios_shelves = [userDefaults objectForKey:ios_shelves];
    user.name_coin = [userDefaults objectForKey:name_coin];
    user.name_votes = [userDefaults objectForKey:name_votes];
    user.enter_tip_level = [userDefaults objectForKey:enter_tip_level];
    
    user.maintain_switch = [userDefaults objectForKey:maintain_switch];
    user.maintain_tips = [userDefaults objectForKey:maintain_tips];
    user.live_cha_switch = [userDefaults objectForKey:live_cha_switch];
    user.live_pri_switch = [userDefaults objectForKey:live_pri_switch];
    
    user.live_type = [userDefaults objectForKey:live_type];
    user.share_type = [userDefaults objectForKey:share_type];
    user.live_time_coin = [userDefaults objectForKey:live_time_coin];
    user.live_time_switch = [userDefaults objectForKey:live_time_switch];
    user.pravitelive_switch = [userDefaults objectForKey:pravitelive_switch];
    return user;
}

+ (void)saveSetting:(CBLiveSetting *)setting {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:setting.video_share_title forKey:video_share_title];
    [userDefaults setObject:setting.video_share_des forKey:video_share_des];
    [userDefaults setObject:setting.share_title forKey:share_title];
    [userDefaults setObject:setting.share_des forKey:share_des];
    [userDefaults setObject:setting.wx_siteurl forKey:wx_siteurl];
    [userDefaults setObject:setting.ipa_ver forKey:ipa_ver];
    [userDefaults setObject:setting.app_ios forKey:app_ios];
    [userDefaults setObject:setting.ios_shelves forKey:ios_shelves];
    [userDefaults setObject:setting.name_coin forKey:name_coin];
    [userDefaults setObject:setting.name_votes forKey:name_votes];
    [userDefaults setObject:setting.enter_tip_level forKey:enter_tip_level];
    
    [userDefaults setObject:setting.maintain_switch forKey:maintain_switch];
    [userDefaults setObject:setting.maintain_tips forKey:maintain_tips];
    [userDefaults setObject:setting.live_cha_switch forKey:live_cha_switch];
    [userDefaults setObject:setting.live_pri_switch forKey:live_pri_switch];
    
    [userDefaults setObject:setting.live_time_coin forKey:live_time_coin];
    [userDefaults setObject:setting.live_time_switch forKey:live_time_switch];
    [userDefaults setObject:setting.live_type forKey:live_type];
    [userDefaults setObject:setting.share_type forKey:share_type];
    [userDefaults setObject:setting.pravitelive_switch forKey:pravitelive_switch];
    [userDefaults synchronize];
    
    UIPasteboard *pasteashare_title = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@share_title", connectname] create:YES];
    pasteashare_title.string = setting.share_title;
    
    UIPasteboard *pasteashare_des = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@share_des", connectname] create:YES];
    pasteashare_des.string = setting.share_des;
    
    UIPasteboard *pasteawx_siteurl = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@wx_siteurl", connectname] create:YES];
    pasteawx_siteurl.string = setting.wx_siteurl;
    
    UIPasteboard *pasteaname_coin = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@name_coin", connectname] create:YES];
    pasteaname_coin.string = setting.name_coin;
    
    UIPasteboard *pasteaapp_ios = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@app_ios", connectname] create:YES];
    pasteaapp_ios.string = setting.app_ios;
    
    UIPasteboard *pasteaname_votes = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@name_votes", connectname] create:YES];
    pasteaname_votes.string = setting.name_votes;
}

+ (void)clearSetting {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    [userDefaults setObject:nil forKey:share_title];
    [userDefaults setObject:nil forKey:video_share_title];
    [userDefaults setObject:nil forKey:video_share_des];
    [userDefaults setObject:nil forKey:share_des];
    [userDefaults setObject:nil forKey:wx_siteurl];
    [userDefaults setObject:nil forKey:ipa_ver];
    [userDefaults setObject:nil forKey:app_ios];
    [userDefaults setObject:nil forKey:ios_shelves];
    [userDefaults setObject:nil forKey:name_coin];
    [userDefaults setObject:nil forKey:name_votes];
    [userDefaults setObject:nil forKey:enter_tip_level];
    
    [userDefaults setObject:nil forKey:maintain_tips];
    [userDefaults setObject:nil forKey:maintain_switch];
    [userDefaults setObject:nil forKey:live_pri_switch];
    [userDefaults setObject:nil forKey:live_cha_switch];
    
    [userDefaults setObject:nil forKey:live_time_coin];
    [userDefaults setObject:nil forKey:live_time_switch];
    [userDefaults setObject:nil forKey:live_type];
    [userDefaults setObject:nil forKey:share_type];
    [userDefaults setObject:nil forKey:pravitelive_switch];
    
    [userDefaults synchronize];
}

+ (NSString *)name_coin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name_coinss = [userDefaults objectForKey: name_coin];
    return name_coinss;
}

+ (NSString *)name_votes {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* name_votesss = [userDefaults objectForKey: name_votes];
    return name_votesss;
}

+ (NSString *)enter_tip_level {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* enter_tip_levelss = [userDefaults objectForKey: enter_tip_level];
    return enter_tip_levelss;
}

+ (NSString *)share_title {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* share_titles = [userDefaults objectForKey: share_title];
    return share_titles;
}

+ (NSString *)video_share_des {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* share_titles = [userDefaults objectForKey: video_share_des];
    return share_titles;
}

+ (NSString *)video_share_title {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* share_titles = [userDefaults objectForKey: video_share_title];
    return share_titles;
}

+ (NSString *)share_des {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* share_dess = [userDefaults objectForKey: share_des];
    return share_dess;
}

+ (NSString *)wx_siteurl {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* wx_siteurls = [userDefaults objectForKey: wx_siteurl];
    return wx_siteurls;
}

+ (NSString *)ipa_ver {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ipa_vers = [userDefaults objectForKey: ipa_ver];
    return ipa_vers;
}

+ (NSString *)app_ios {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* app_ioss = [userDefaults objectForKey: app_ios];
    return app_ioss;
}

+ (NSString *)ios_shelves {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ios_shelvess = [userDefaults objectForKey: ios_shelves];
    return ios_shelvess;
}

+ (NSString *)maintain_tips {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *maintain_tipss = [userDefaults objectForKey: maintain_tips];
    return maintain_tipss;
}

+ (NSString *)maintain_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *maintain_switchs = [userDefaults objectForKey:maintain_switch];
    return maintain_switchs;
}

+ (NSString *)live_pri_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *live_pri_switchs = [userDefaults objectForKey:live_pri_switch];
    return live_pri_switchs;
}

+ (NSString *)live_cha_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *live_cha_switchs = [userDefaults objectForKey:live_cha_switch];
    return live_cha_switchs;
}

+ (NSString *)live_time_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *live_time_switchs = [userDefaults objectForKey:live_time_switch];
    return live_time_switchs;
}

+ (NSArray *)live_time_coin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *live_cha_switchs = [userDefaults objectForKey:live_time_coin];
    return live_cha_switchs;
}

+ (NSArray  *)live_type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *livetypes = [userDefaults objectForKey:live_type];
    return livetypes;
    
}

+ (NSArray  *)share_type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *share_typess = [userDefaults objectForKey:share_type];
    return share_typess;
}

+ (NSString *)pravitelive_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pravitelive_switchs = [userDefaults objectForKey:pravitelive_switch];
    return pravitelive_switchs;
}

// 保存个人中心选项缓存
+ (void)savepersoncontroller:(NSArray *)arrays {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:arrays forKey:personc];
    [userDefaults synchronize];
}

+ (NSArray *)getpersonc {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *personcs = [userDefaults objectForKey:personc];
    return personcs;
    
}

@end
