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

@end
