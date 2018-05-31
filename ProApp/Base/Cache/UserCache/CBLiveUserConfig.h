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
+ (void)clearProfile;

+ (NSString *)getHXuid;
+ (NSString *)getHXpwd;
+ (NSString *)getOwnToken;
+ (NSString *)getOwnID;

@end
