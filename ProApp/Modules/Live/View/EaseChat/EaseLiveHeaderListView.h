//
//  EaseLiveHeaderListView.h
//  EaseMobLiveDemo
//
//  Created by EaseMob on 16/7/15.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBActionLiveDelegate.h"

@class CBAppLiveVO;
@interface EaseLiveHeaderListView : UIView

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO*)room;

@property (nonatomic, weak) id <CBActionLiveDelegate> delegate;

- (void)loadHeaderListWithChatroomId:(NSString*)chatroomId;

@end
