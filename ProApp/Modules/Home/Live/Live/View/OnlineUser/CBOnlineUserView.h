//
//  CBOnlineUserView.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@class CBAppLiveVO;
@interface CBOnlineUserView : CBPopView

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO *)room;
@end
