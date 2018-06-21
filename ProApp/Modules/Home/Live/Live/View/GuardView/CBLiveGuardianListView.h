//
//  CBLiveGuardianListView.h
//  EaseMobLiveDemo
//
//  Created by EaseMob on 16/7/15.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBLiveGuardianListViewDelegate <NSObject>

- (void)didSelectHeaderWithUsername:(NSString*)username;
- (void)didSelectOccupantsWithUserID:(NSString *)userId;

@end

@class EasePublishModel;
@class CBAppLiveVO;
@interface CBLiveGuardianListView : UIView

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO*)room;

@property (nonatomic, weak) id<CBLiveGuardianListViewDelegate> delegate;

- (void)loadHeaderListWithChatroomId:(NSString*)chatroomId;

@end
