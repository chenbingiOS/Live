//
//  CBChatGiftMessageVO.h
//  presentAnimation
//
//  Created by 潘涯 on 16/7/28.
//  Copyright © 2016年 许博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBChatGiftMessageVO : NSObject

@property (nonatomic, retain) NSString *senderUID;      ///< 发送人ID
@property (nonatomic, retain) NSString *senderName;     ///< 发送人名字
@property (nonatomic, retain) NSString *senderAvater;   ///< 发送人头像

@property (nonatomic, retain) NSString *giftID;         ///< 礼物编号
@property (nonatomic, retain) NSString *giftName;       ///< 礼物名称
@property (nonatomic, retain) NSString *giftImageURL;   ///< 礼物图片地址
@property (nonatomic, retain) NSString *giftNum;        ///< 礼物数量
@property (nonatomic, retain) NSString *giftType;       ///< 礼物类别   礼物类型，默认0普通礼物，1贵族礼物，2幸运礼物，3其他礼物
@property (nonatomic, retain) NSString *giftSwf;        ///< gif礼物

@end
