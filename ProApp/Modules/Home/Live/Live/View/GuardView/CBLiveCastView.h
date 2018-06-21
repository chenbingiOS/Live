//
//  CBLiveCastView.h
//  EaseMobLiveDemo
//
//  Created by EaseMob on 16/7/26.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBActionLiveDelegate.h"

@class CBAppLiveVO;
@interface CBLiveCastView : UIView

@property (nonatomic, weak) id <CBActionLiveDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO*)room;

@end
