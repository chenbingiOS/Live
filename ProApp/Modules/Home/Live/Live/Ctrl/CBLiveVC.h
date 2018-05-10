//
//  CBLiveVC.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

// 上下滑动切直播控制器

#import <UIKit/UIKit.h>

@class ALinLive;
@interface CBLiveVC : UIViewController

@property (nonatomic, strong) ALinLive *live;  /** 直播 */
@property (nonatomic, strong) NSArray <ALinLive *> *lives;  /** 直播 */
@property (nonatomic, assign) NSUInteger currentIndex;      /** 当前的index */

@end
