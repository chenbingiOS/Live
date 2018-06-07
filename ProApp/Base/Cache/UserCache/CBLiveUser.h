//
//  CBLiveUser.h
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBLiveUser : NSObject <NSCoding>


@property (nonatomic, copy) NSString *token;            ///< APP登录Token
@property (nonatomic, copy) NSString *update_token_time;///< 获取token的时间

@property (nonatomic, copy) NSString *hx_uid;           ///< 环信uid
@property (nonatomic, copy) NSString *hx_pw;            ///< 环信password

@property (nonatomic, copy) NSString *ID;               ///< 登陆用户id
@property (nonatomic, copy) NSString *user_nicename;    ///< 用户昵称
@property (nonatomic, copy) NSString *is_truename;      ///< 真实姓名        是否是真实姓名：0：不是 1：是
@property (nonatomic, copy) NSString *user_email;       ///< 登陆邮箱
@property (nonatomic, copy) NSString *mobile;           ///< 电话号码
@property (nonatomic, copy) NSString *mobile_status;    ///< 是否绑定手机     0: 未绑定 1:绑定
@property (nonatomic, copy) NSString *avatar;           ///< 头像
@property (nonatomic, copy) NSString *sex;              ///< 性别            0:保密 1:男 2:女
@property (nonatomic, copy) NSString *birthday;         ///< 生日
@property (nonatomic, copy) NSString *signature;        ///< 签名

@property (nonatomic, copy) NSString *location;         ///< 地址所在地
@property (nonatomic, copy) NSString *longitude;        ///< 经度
@property (nonatomic, copy) NSString *latitude;         ///< 纬度

@property (nonatomic, copy) NSString *balance;          ///< 钻石余额
@property (nonatomic, copy) NSString *sidou;            ///< 用户收益         钻石,可兑换金币或提现
@property (nonatomic, copy) NSString *total_earn;       ///< 用户总收益       钻石
@property (nonatomic, copy) NSString *total_spend;      ///< 用户总消费贡献(金币)
@property (nonatomic, copy) NSString *vip_deadline;     ///< vip截至日期

@property (nonatomic, copy) NSString *user_status;      ///< 用户状态             0:禁用 1:正常 2:未验证
@property (nonatomic, copy) NSString *user_level;       ///< vip等级             默认1，普通用户等级（财富）

@property (nonatomic, copy) NSString *is_host;          ///< 是否是主播           0：不是主播 ，1：是主播
@property (nonatomic, copy) NSString *family_id;        ///< 所属家族id           0代表没有所属家族
@property (nonatomic, copy) NSString *superior;         ///< 用户从属的上级用户ID   默认0
@property (nonatomic, copy) NSString *path;             ///< 层级关系路径          若无则为0-ID
@property (nonatomic, copy) NSString *subordinate_count;///< 直属下级的个数
@property (nonatomic, copy) NSString *advanced_administrator;   ///< 超管         默认0 ，1是超管
@property (nonatomic, copy) NSString *minute_charge_timestamp;  ///< 分钟扣费时间
@property (nonatomic, copy) NSString *attention_num;    ///< 我的关注
@property (nonatomic, copy) NSString *fans_num;         ///< 我的粉丝


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
