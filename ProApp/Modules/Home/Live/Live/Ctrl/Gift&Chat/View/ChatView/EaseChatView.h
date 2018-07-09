//
//  EaseChatView.h
//  UCloudMediaRecorderDemo
//
//  Created by EaseMob on 16/5/9.
//  Copyright © 2016年 zilong.li All rights reserved.
//

// 底部菜单，包含聊天室

#import <UIKit/UIKit.h>
#import "CBShareView.h"

@class EMMessage;
@class CBAppLiveVO;
@class EaseChatView;
@protocol EaseChatViewDelegate <NSObject>

@optional
- (void)easeChatViewDidChangeFrameToHeight:(CGFloat)toHeight;
- (void)didReceiveGiftWithCMDMessage:(EMMessage*)message;
- (void)didReceiveBarrageWithCMDMessage:(EMMessage*)message;
- (void)didReceivePraiseWithCMDMessage:(EMMessage *)message;
- (void)didSelectUserWithMessage:(EMMessage*)message;
- (void)didSelectAdminButton:(BOOL)isOwner;

// 私信按钮
- (void)chatView:(EaseChatView *)chatView actionTouchDirectMessageBtn:(UIButton *)sender;
// 礼物按钮
- (void)chatView:(EaseChatView *)chatView actionTouchGiftBtn:(UIButton *)sender;
// 分享按钮
- (void)chatView:(EaseChatView *)chatView actionTouchShareBtn:(UIButton *)sender;
// 菜单按钮
- (void)chatView:(EaseChatView *)chatView actionTouchMenuBtn:(UIButton *)sender;
// 美颜按钮
- (void)chatView:(EaseChatView *)chatView actionTouchFaceUnityBeautyBtn:(UIButton *)sender;
// 道具按钮
- (void)chatView:(EaseChatView *)chatView actionTouchFaceUnityPropBtn:(UIButton *)sender;
// 旋转相机
- (void)chatView:(EaseChatView *)chatView actionTouchChangeCameraBtn:(UIButton *)sender;

@end

@interface EaseChatView : UIView

@property (nonatomic, weak) id<EaseChatViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame chatroomId:(NSString*)chatroomId;
- (instancetype)initWithFrame:(CGRect)frame chatroomId:(NSString*)chatroomId isPublish:(BOOL)isPublish;
- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO*)room isPublish:(BOOL)isPublish;


- (void)joinChatroomWithIsCount:(BOOL)aIsCount
                     completion:(void (^)(BOOL success))aCompletion;

- (void)leaveChatroomWithIsCount:(BOOL)aIsCount
                      completion:(void (^)(BOOL success))aCompletion;

- (void)sendGiftWithId:(NSString*)giftId;

- (void)sendGiftDict:(NSDictionary *)giftDict;

- (void)sendMessageAtWithUsername:(NSString*)username;

@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic, strong) CBSharePopView *sharePopView;     ///< 分享页面

@end
