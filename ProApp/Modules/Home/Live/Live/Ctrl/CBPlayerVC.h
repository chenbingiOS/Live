//
//  CBPlayerVC.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPlayerVC : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURL *thumbImageURL;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIButton *closeButton;

// 子类重写，用于加入聊天室
- (void)joinChatRoom;
- (void)leaveChatRoom;

@end
