//
//  CBLiveUserConfig.m
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveUserConfig.h"
#import "CBArchiverTool.h"

#define KLiveUserConfigFilePath @"KLiveUserConfig.plist"

static NSString * const KLiveUser = @"KLiveUser";

@implementation CBLiveUserConfig

+ (CBLiveUser *)myProfile {
    CBLiveUser *user = [CBArchiverTool unarchiverPath:KLiveUserConfigFilePath key:KLiveUser];
    return user;
}

+ (void)saveProfile:(CBLiveUser *)user {
    [CBArchiverTool archiverObject:user key:KLiveUser filePath:KLiveUserConfigFilePath];
}

+ (void)clearProfile {
    [CBArchiverTool removeArchiverObjectFilePath:KLiveUserConfigFilePath];
}

+ (NSString *)getHXuid {
    return [self myProfile].hx_uid;
}

+ (NSString *)getHXpwd {
    return [self myProfile].hx_pw;
}

+ (NSString *)getOwnToken {
    return [self myProfile].token;
}

+ (NSString *)getOwnID {
    return [self myProfile].ID;
}

@end
