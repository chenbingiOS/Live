//
//  CBLiveChatViewVC.h
//  ProApp
//
//  Created by hxbjt on 2018/6/22.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBAppLiveVO;
@interface CBLiveChatViewVC : UIViewController

@property (nonatomic, strong) CBAppLiveVO *liveVO;  /** 直播 */

- (void)joinChatRoom;
- (void)leaveChatRoom;
- (void)closeGiftView;

@end
