//
//  CBLiveGuardianListView.h
//  EaseMobLiveDemo
//
//  Created by EaseMob on 16/7/15.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBActionLiveDelegate.h"

@class EasePublishModel;
@class CBAppLiveVO;
@interface CBLiveGuardianListView : UIView

@property (nonatomic, weak) id <CBActionLiveDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO*)room;

- (void)loadHeaderListWithChatroomId:(NSString*)chatroomId;

@end
