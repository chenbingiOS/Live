//
//  CBLiveUser.h
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBLiveUser : NSObject

@property (nonatomic, copy) NSString *token;            ///< APP登录Token
@property (nonatomic, copy) NSString *ID;               ///< 登陆用户id
@property (nonatomic, copy) NSString *user_nicename;    ///< 用户昵称
@property (nonatomic, copy) NSString *balance;          ///< 用户余额
@property (nonatomic, copy) NSString *sidou;            ///< 用户收益
@property (nonatomic, copy) NSString *avatar;           ///< 头像
@property (nonatomic, copy) NSString *sex;              ///< 性别
@property (nonatomic, copy) NSString *signature;        ///< 签名
@property (nonatomic, copy) NSString *vip_deadline;     ///< vip 截至日期

@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *avatar_thumb;
@property (nonatomic, copy) NSString *login_type;
@property (nonatomic, copy) NSString *level_anchor;
//vip_type

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
