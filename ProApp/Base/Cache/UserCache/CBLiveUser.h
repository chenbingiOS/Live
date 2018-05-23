//
//  CBLiveUser.h
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBLiveUser : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *user_nicename;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *avatar_thumb;
@property (nonatomic, copy) NSString *login_type;
@property (nonatomic, copy) NSString *level_anchor;
//vip_type

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
