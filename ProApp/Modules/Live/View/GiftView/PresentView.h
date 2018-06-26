//
//  PresentView.h
//  presentAnimation
//
//  Created by 许博 on 16/7/14.
//  Copyright © 2016年 许博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeLabel.h"
#import "GiftModel.h"


typedef void(^completeBlock)(BOOL finished,NSInteger finishCount);

@interface PresentView : UIView
@property (nonatomic,strong) GiftModel *model;
@property (nonatomic,strong) UIImageView *headImageView; // 头像
@property (nonatomic,strong) UIImageView *giftImageView; // 礼物
@property (nonatomic,strong) UILabel *nameLabel; // 送礼物者
@property (nonatomic,strong) UILabel *giftLabel; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数

@property (nonatomic,strong) ShakeLabel *skLabel;
@property (nonatomic,assign) NSInteger animCount; // 动画执行到了第几次
@property (nonatomic,assign) CGRect originFrame; // 记录原始坐标

@property (nonatomic,assign,getter=isFinished) BOOL finished;
- (void)animateWithCompleteBlock:(completeBlock)completed;


- (void)shakeNumberLabel;
- (void)hidePresendView;

@end


//// 模拟收到礼物消息的回调
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    // IM 消息
//    GSPChatMessage *msg = [[GSPChatMessage alloc] init];
//    msg.text = @"1个【鲜花】";
//    // 模拟 n 个人在送礼物
//    int x = arc4random() % 9;
//    msg.senderChatID = [NSString stringWithFormat:@"%d",x];
//    msg.senderName = msg.senderChatID;
//    NSLog(@"id %@ -------送了1个【鲜花】--------",msg.senderChatID);
//    
//    // 礼物模型
//    GiftModel *giftModel = [[GiftModel alloc] init];
//    giftModel.headImage = [UIImage imageNamed:@"luffy"];
//    giftModel.name = msg.senderName;
//    giftModel.giftImage = [UIImage imageNamed:@"flower"];
//    giftModel.giftName = msg.text;
//    giftModel.giftCount = 1;
//    
//    
//    AnimOperationManager *manager = [AnimOperationManager sharedManager];
//    manager.parentView = self.view;
//    // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
//    [manager animWithUserID:[NSString stringWithFormat:@"%@",msg.senderChatID] model:giftModel finishedBlock:^(BOOL result) {
//        
//    }];
//}
