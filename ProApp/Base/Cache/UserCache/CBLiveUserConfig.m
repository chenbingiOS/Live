//
//  CBLiveUserConfig.m
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveUserConfig.h"

static NSString * const KToken          = @"token";
static NSString * const KID             = @"ID";
static NSString * const KUser_nicename  = @"user_nicename";
static NSString * const KBalance        = @"balance";
static NSString * const KSidou          = @"sidou";
static NSString * const KAvatar         = @"avatar";
static NSString * const KSex            = @"sex";
static NSString * const KSignature      = @"signature";
static NSString * const KTotal_spend    = @"total_spend";
static NSString * const KUser_status    = @"user_status";
static NSString * const KVip_deadline   = @"vip_deadline";
static NSString * const KHx_uid         = @"hx_uid";
static NSString * const KHx_pw          = @"hx_pw";
static NSString * const KUser_level     = @"user_level";

static NSString * const KBirthday = @"birthday";
static NSString * const KCoin = @"coin";
static NSString * const Kcity = @"city";
static NSString * const Klevel = @"level";
static NSString * const kavatar_thumb = @"avatar_thumb";
static NSString * const Klogin_type = @"login_type";
static NSString * const Klevel_anchor = @"level_anchor";
static NSString * const vip_type = @"vip_type";
static NSString * const liang = @"liang";

#define connectname @"xin-"//数据互通标志

@implementation CBLiveUserConfig

#pragma mark - user profile
+ (CBLiveUser *)myProfile {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CBLiveUser *user    = [[CBLiveUser alloc] init];
    user.token          = [userDefaults objectForKey:KToken];
    user.ID             = [userDefaults objectForKey:KID];
    user.user_nicename  = [userDefaults objectForKey:KUser_nicename];
    user.balance        = [userDefaults objectForKey:KBalance];
    user.sidou          = [userDefaults objectForKey:KSidou];
    user.avatar         = [userDefaults objectForKey:KAvatar];
    user.sex            = [userDefaults objectForKey:KSex];
    user.signature      = [userDefaults objectForKey:KSignature];
    user.total_spend    = [userDefaults objectForKey:KTotal_spend];
    user.user_status    = [userDefaults objectForKey:KUser_status];
    user.vip_deadline   = [userDefaults objectForKey:KVip_deadline];
    user.hx_uid         = [userDefaults objectForKey:KHx_uid];
    user.hx_pw          = [userDefaults objectForKey:KHx_pw];
    user.user_level     = [userDefaults objectForKey:KUser_level];
    
    user.birthday       = [userDefaults objectForKey:KBirthday];
    user.coin           = [userDefaults objectForKey:KCoin];
    user.level_anchor   = [userDefaults objectForKey:Klevel_anchor];
    user.level          = [userDefaults objectForKey:Klevel];
    user.city           = [userDefaults objectForKey:Kcity];
    user.avatar_thumb   = [userDefaults objectForKey:kavatar_thumb];
    user.login_type     = [userDefaults objectForKey:Klogin_type];
    return user;
}

+ (void)saveProfile:(CBLiveUser *)user {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.token forKey:KToken];
    [userDefaults setObject:user.ID forKey:KID];
    [userDefaults setObject:user.user_nicename forKey:KUser_nicename];
    [userDefaults setObject:user.balance forKey:KBalance];
    [userDefaults setObject:user.sidou forKey:KSidou];
    [userDefaults setObject:user.avatar forKey:KAvatar];
    [userDefaults setObject:user.sex forKey:KSex];
    [userDefaults setObject:user.signature forKey:KSignature];
    [userDefaults setObject:user.total_spend forKey:KTotal_spend];
    [userDefaults setObject:user.user_status forKey:KUser_status];
    [userDefaults setObject:user.vip_deadline forKey:KVip_deadline];
    [userDefaults setObject:user.hx_uid forKey:KHx_uid];
    [userDefaults setObject:user.hx_pw forKey:KHx_pw];
    [userDefaults setObject:user.user_level forKey:KUser_level];
    
    [userDefaults setObject:user.avatar_thumb forKey:kavatar_thumb];
    [userDefaults setObject:user.coin forKey:KCoin];
    [userDefaults setObject:user.login_type forKey:Klogin_type];
    [userDefaults setObject:user.avatar forKey:Klevel_anchor];
    [userDefaults setObject:user.birthday forKey:KBirthday];
    [userDefaults setObject:user.city forKey:Kcity];
    [userDefaults setObject:user.level forKey:Klevel];
    [userDefaults synchronize];
    
//    //传递大s头像
//    if (user.avatar) {
//        UIPasteboard *pasteavatar = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@avatar",connectname] create:YES];
//        pasteavatar.string = user.avatar;
//    }
//
//    //传递小头像
//    if (user.avatar_thumb) {
//        UIPasteboard *pasteaavatar_thumb = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@avatar_thumb",connectname] create:YES];
//        pasteaavatar_thumb.string = user.avatar_thumb;
//    }
//
//    //传递id
//    if (user.ID) {
//        UIPasteboard *pasteaID = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@ID",connectname] create:YES];
//        pasteaID.string = user.ID;
//    }
//
//    //传递name
//    if (user.user_nicename) {
//        UIPasteboard *pasteauser_nicename = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@user_nicename",connectname] create:YES];
//        pasteauser_nicename.string = user.user_nicename;
//    }
//
//    //传递token
//    if (user.token) {
//        UIPasteboard *pastetoken= [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@token",connectname] create:YES];
//        pastetoken.string = user.token;
//    }
//
//    //传递余额
//    if (user.coin) {
//        UIPasteboard *pastecoin = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@coin",connectname] create:YES];
//        pastecoin.string = user.coin;
//    }
//
//    //传递性别
//    if (user.sex) {
//        UIPasteboard *pastesex = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@sex",connectname] create:YES];
//        pastesex.string = user.sex;
//    }
//
//    //传递个签
//    if (user.signature) {
//        UIPasteboard *pastesignature = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@signature",connectname] create:YES];
//        pastesignature.string = user.signature;
//    }
//
//    //传递等级
//    if (user.level) {
//        UIPasteboard *pastelevel = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@level",connectname] create:YES];
//        pastelevel.string = user.level;
//    }
//
//    //传递城市
//    if (user.city) {
//        UIPasteboard *pastecity = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@city",connectname] create:YES];
//        pastecity.string = user.city;
//    }
}

+ (void)updateProfile:(CBLiveUser *)user {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if (user.token != nil) [userDefaults setObject:user.token forKey:KToken];
//    if (user.ID != nil) [userDefaults setObject:user.ID forKey:KID];

    if (user.user_nicename != nil) [userDefaults setObject:user.user_nicename forKey:KUser_nicename];
    if (user.balance != nil) [userDefaults setObject:user.balance forKey:KBalance];
    if (user.sidou != nil) [userDefaults setObject:user.sidou forKey:KSidou];
    if (user.avatar != nil) [userDefaults setObject:user.avatar forKey:KAvatar];
    if (user.sex != nil) [userDefaults setObject:user.sex forKey:KSex];
    if (user.signature != nil) [userDefaults setObject:user.signature forKey:KSignature];
    if (user.total_spend!=nil) [userDefaults setObject:user.total_spend forKey:KTotal_spend];
    if (user.user_status!=nil) [userDefaults setObject:user.user_status forKey:KUser_status];
    if (user.vip_deadline!=nil) [userDefaults setObject:user.vip_deadline forKey:KVip_deadline];
    if (user.hx_uid!=nil) [userDefaults setObject:user.hx_uid forKey:KHx_uid];
    if (user.hx_pw!=nil) [userDefaults setObject:user.hx_pw forKey:KHx_pw];
    if (user.user_level!=nil) [userDefaults setObject:user.user_level forKey:KUser_level];
    
    if (user.level_anchor != nil) [userDefaults setObject:user.level_anchor forKey:Klevel_anchor];
    if (user.avatar_thumb!=nil) [userDefaults setObject:user.avatar_thumb forKey:kavatar_thumb];
    if (user.coin!=nil) [userDefaults setObject:user.coin forKey:KCoin];
    if (user.birthday!=nil) [userDefaults setObject:user.birthday forKey:KBirthday];
    if (user.login_type!=nil) [userDefaults setObject:user.login_type forKey:Klogin_type];
    if (user.city!=nil) [userDefaults setObject:user.city forKey:Kcity];
    if (user.level!=nil) [userDefaults setObject:user.level forKey:Klevel];
    
    [userDefaults synchronize];
}

+ (void)clearProfile {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:KToken];
    [userDefaults setObject:nil forKey:KID];
    [userDefaults setObject:nil forKey:KUser_nicename];
    [userDefaults setObject:nil forKey:KAvatar];
    [userDefaults setObject:nil forKey:KBalance];
    [userDefaults setObject:nil forKey:KSidou];
    [userDefaults setObject:nil forKey:KSex];
    [userDefaults setObject:nil forKey:KSignature];
    [userDefaults setObject:nil forKey:KTotal_spend];
    [userDefaults setObject:nil forKey:KUser_status];
    [userDefaults setObject:nil forKey:KVip_deadline];
    [userDefaults setObject:nil forKey:KHx_uid];
    [userDefaults setObject:nil forKey:KHx_pw];
    [userDefaults setObject:nil forKey:KUser_level];
    
    [userDefaults setObject:nil forKey:Klevel_anchor];
    [userDefaults setObject:nil forKey:KBirthday];
    [userDefaults setObject:nil forKey:KCoin];
    [userDefaults setObject:nil forKey:Klogin_type];
    [userDefaults setObject:nil forKey:Kcity];
    [userDefaults setObject:nil forKey:Klevel];
    [userDefaults setObject:nil forKey:kavatar_thumb];
    
    [userDefaults synchronize];
}

+ (NSString *)getOwnToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:KToken];
    return token;
}

+ (NSString *)getOwnID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ID = [userDefaults objectForKey: KID];
    return ID;
}

+ (NSString *)getOwnNicename {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nicename = [userDefaults objectForKey: KUser_nicename];
    return nicename;
}

+ (NSString *)getOwnSignature {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *signature = [userDefaults objectForKey:KSignature];
    return signature;
}

+ (NSString *)getHXuid {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *hxuid = [userDefaults objectForKey:KHx_uid];
    return hxuid;
}

+ (NSString *)getHXpwd {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *hxpwd = [userDefaults objectForKey:KHx_pw];
    return hxpwd;

}





+ (NSString *)getavatar {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *avatar = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:KAvatar]];
    return avatar;
}

+ (NSString *)getavatarThumb {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *signature = [userDefaults objectForKey:kavatar_thumb];
    return signature;
}

+ (NSString *)getLevel {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *level = [userDefaults objectForKey:Klevel];
    return level;
}

+(NSString *)getSex {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sex = [userDefaults objectForKey:KSex];
    return sex;
}

+ (NSString *)level_anchor {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *level_anchors = [userDefaults objectForKey:Klevel_anchor];
    return level_anchors;
}

//保存靓号和vip
+(void)saveVipandliang:(NSDictionary *)subdic{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%@", [subdic valueForKey:@"vip_type"]] forKey:@"vip_type"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@", [subdic valueForKey:@"liang"]] forKey:@"liang"];
    [userDefaults synchronize];
}

+ (NSString *)getVip_type{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *viptype = [NSString stringWithFormat:@"%@", [userDefults objectForKey:vip_type]];
    return viptype;
}

+ (NSString *)getliang{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *liangnum = [NSString stringWithFormat:@"%@", [userDefults objectForKey:liang]];
    return liangnum;
}

@end
