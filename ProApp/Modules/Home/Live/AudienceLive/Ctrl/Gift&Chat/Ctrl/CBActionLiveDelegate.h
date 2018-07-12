//
//  CBActionLiveDelegate.h
//  ProApp
//
//  Created by hxbjt on 2018/6/21.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol CBActionLiveDelegate <NSObject>

@optional
// 显示主播信息
- (void)actionLiveShowAnchorInfo;
// 关注当前用户
- (void)actionLiveAttentionCurrentAnchor;
// 开通守护
- (void)actionLiveOpenGuard;
// 显示在线用户列表
- (void)actionLiveShowOnlineUserList;
// 显示贡献榜
- (void)actionLiveShowContributionList;
// 显示守护列表
- (void)actionLiveShowGrardianList;

@end
