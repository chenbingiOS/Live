//
//  CBLiveChatViewVC.h
//  ProApp
//
//  Created by hxbjt on 2018/6/22.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBLiveChatViewVC;
@protocol LiveChatViewVCDelegate <NSObject>

// 美颜按钮
- (void)liveChatViewVC:(CBLiveChatViewVC *)liveChatViewVC  actionTouchFaceUnityBeautyBtn:(UIButton *)sender;
// 道具按钮
- (void)liveChatViewVC:(CBLiveChatViewVC *)liveChatViewVC actionTouchFaceUnityPropBtn:(UIButton *)sender;
// 旋转相机按钮
- (void)liveChatViewVC:(CBLiveChatViewVC *)liveChatViewVC actionTouchChangeCameraBtn:(UIButton *)sender;
@end




@class CBAppLiveVO;
@interface CBLiveChatViewVC : UIViewController

@property (nonatomic, weak) id <LiveChatViewVCDelegate> delegate;
@property (nonatomic, strong) CBAppLiveVO *liveVO;  /** 直播 */
@property (nonatomic, assign) BOOL isAnchor;        ///< 是否主播

- (void)joinChatRoom;
- (void)leaveChatRoom;
- (void)closeGiftView;

@end
