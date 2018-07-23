//
//  LiveGiftShowModel.m
//  LiveSendGift
//
//  Created by Jonhory on 2016/11/11.
//  Copyright © 2016年 com.wujh. All rights reserved.
//

#import "LiveGiftShowModel.h"

@implementation LiveGiftShowModel

+ (instancetype)giftModel:(LiveGiftListModel *)giftModel userModel:(LiveUserModel *)userModel{
    LiveGiftShowModel * model = [[LiveGiftShowModel alloc]init];
    model.giftModel = giftModel;
    model.user = userModel;
    model.interval = 0.35;
    model.toNumber = 1;
    return model;
}


+ (instancetype)instancetypeGiftVOByGiftMessage:(CBChatGiftMessageVO *)giftMessage {
    LiveGiftListModel *giftListModel = [LiveGiftListModel new];
    giftListModel.type = giftMessage.giftID;
    giftListModel.name = giftMessage.giftName;
    giftListModel.picUrl = giftMessage.giftImageURL;
    giftListModel.rewardMsg = [NSString stringWithFormat:@"赠送 %@", giftMessage.giftName];
    
    LiveUserModel *userModel = [LiveUserModel new];
    userModel.iconUrl = giftMessage.senderAvater;
    userModel.name = giftMessage.senderName;
    
    return [self giftModel:giftListModel userModel:userModel];
}

@end
