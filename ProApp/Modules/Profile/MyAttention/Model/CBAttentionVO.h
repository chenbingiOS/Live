//
//  CBAttentionVO.h
//  ProApp
//
//  Created by hxbjt on 2018/6/1.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBAttentionVO : NSObject

@property (nonatomic, copy) NSString *ID;               ///< 关注的人的id
@property (nonatomic, copy) NSString *user_nicename;    ///< 昵称
@property (nonatomic, copy) NSString *is_truename;      ///< 真实姓名
@property (nonatomic, copy) NSString *avatar;           ///< 头像
@property (nonatomic, copy) NSString *sex;              ///< 性别；        性别；0：保密，1：男；2：女
@property (nonatomic, copy) NSString *signature;        ///< 个性签名
@property (nonatomic, copy) NSString *total_spend;      ///< 用户总消费贡献(金币)
@property (nonatomic, copy) NSString *roomid;           ///< 房间id
@property (nonatomic, copy) NSString *channel_status;   ///< 频道状态；     0禁用，1未开播，2已开播
@property (nonatomic, copy) NSString *user_level;       ///< vip等级；     默认1，普通用户等级（财富）
@property (nonatomic, copy) NSString *attention_status; ///< 关注状态

@end
