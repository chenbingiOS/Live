//
//  CBAppLiveVO.h
//  ProApp
//
//  Created by hxbjt on 2018/5/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CBMsgVO;
@interface CBAppLiveVO : NSObject

@property (nonatomic, copy) NSString *room_id;          ///<直播间编号    数字(number)
@property (nonatomic, copy) NSString *leancloud_room;   ///<聊天室编号    数字(number)
@property (nonatomic, copy) NSString *ID;               ///<主播的用户id    数字(number)
@property (nonatomic, copy) NSString *channel_creater;  ///<主播的用户id    数字(number)
@property (nonatomic, copy) NSString *avatar;           ///<主播头像    字符串(string)
@property (nonatomic, copy) NSString *user_nicename;    ///<主播昵称    字符串(string)
@property (nonatomic, copy) NSString *location;         ///<主播地址信息    字符串(string)
@property (nonatomic, copy) NSString *channel_status;   ///<直播间状态    数字(number)        开播中状态：2
@property (nonatomic, copy) NSString *channel_title;    ///<直播间标题    字符串(string)
@property (nonatomic, copy) NSString *thumb;            ///<直播间封面图    字符串(string)
@property (nonatomic, copy) NSString *price;            ///<直播间价格    数字(number)
@property (nonatomic, copy) NSString *minute_charge;    ///<直播间分钟收费    数字(number)
@property (nonatomic, copy) NSString *vip_change;       ///<是否vip房间    数字(number)
@property (nonatomic, copy) NSString *user_level;       ///<主播用户等级    数字(number)
@property (nonatomic, copy) NSString *smeta;            ///<用户头像    字符串(string)
@property (nonatomic, copy) NSString *online_num;       ///<直播间在线人数    数字(number)
@property (nonatomic, copy) NSString *term_name;        ///<分类名目    字符串(string)
@property (nonatomic, copy) NSString *need_password;    ///<是否需要密码    数字(number)
@property (nonatomic, copy) NSString *channel_source;   ///<拉流地址    字符串(string)

// 推流地址
@property (nonatomic, copy) NSString *push_rtmp;        ///<推流地址    字符串(string)
@property (nonatomic, copy) NSArray <CBMsgVO *> *msg;   ///<直播间公告    数组(array

@end

//直播间公告
@interface CBMsgVO : NSObject

@property (nonatomic, copy) NSString *title;    ///<标题    字符串(string)
@property (nonatomic, copy) NSString *msg;      ///<消息    字符串(string)

@end

