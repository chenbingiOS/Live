//
//  CBBeginLiveVO.h
//  ProApp
//
//  Created by hxbjt on 2018/6/12.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

//直播间公告
@interface CBMsgVO : NSObject

@property (nonatomic, copy) NSString *title;    ///<标题    字符串(string)
@property (nonatomic, copy) NSString *msg;      ///<消息    字符串(string)

@end

@interface CBBeginLiveVO : NSObject


@property (nonatomic, copy) NSString *room_id;          ///<直播间编号    数字(number)
@property (nonatomic, copy) NSString *leancloud_room;   ///<聊天室编号    字符串(string)
@property (nonatomic, copy) NSString *push_rtmp;        ///<推流地址    字符串(string)
@property (nonatomic, copy) NSArray <CBMsgVO *> *msg;   ///<直播间公告    数组(array

@end
