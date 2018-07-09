//
//  CBLiveVC.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

// 上下滑动切直播控制器
#import <UIKit/UIKit.h>

@class CBAppLiveVO;
@interface CBLiveVC : UIPageViewController

@property (nonatomic, strong) NSArray <CBAppLiveVO *> *lives;  /** 直播 */
@property (nonatomic, assign) NSUInteger currentIndex;      /** 当前的index */

@end
