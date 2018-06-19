//
//  CBStopLiveVO.h
//  ProApp
//
//  Created by hxbjt on 2018/6/15.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBStopLiveVO : NSObject

@property (nonatomic, copy) NSString *ID;               ///< 房主的用户id    数字(number)
@property (nonatomic, copy) NSString *room_id;          ///< 房间编号    数字(number)
@property (nonatomic, copy) NSString *online_num;       ///< 在线用户数    数字(number)
@property (nonatomic, copy) NSString *channel_hits;     ///< 直播间访问人数    数字(number)
@property (nonatomic, copy) NSString *channel_like;     ///< 直播间点赞人数    数字(number)
@property (nonatomic, copy) NSString *earn;             ///< 本次直播收入    数字(number)
@property (nonatomic, copy) NSString *avatar;           ///< 主播头像    字符串(string)
@property (nonatomic, copy) NSString *user_nicename;    ///< 主播昵称    字符串(string)
@property (nonatomic, copy) NSString *all_time;         ///< 本次直播直播时长    字符串(string)

@end
