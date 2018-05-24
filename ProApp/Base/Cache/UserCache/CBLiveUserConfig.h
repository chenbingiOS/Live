//
//  CBLiveUserConfig.h
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBLiveUser.h"

@interface CBLiveUserConfig : NSObject

+ (CBLiveUser *)myProfile;
+ (void)saveProfile:(CBLiveUser *)user;
+ (void)updateProfile:(CBLiveUser *)user;
+ (void)clearProfile;

+ (NSString *)getOwnID;
+ (NSString *)getOwnNicename;
+ (NSString *)getOwnToken;
+ (NSString *)getOwnSignature;
+ (NSString *)getavatar;
+ (NSString *)getavatarThumb;
+ (NSString *)getLevel;
+ (NSString *)getSex;

+ (NSString *)level_anchor;//主播等级
+ (void)saveVipandliang:(NSDictionary *)subdic;//保存靓号和vip
+ (NSString *)getVip_type;
+ (NSString *)getliang;

@end
