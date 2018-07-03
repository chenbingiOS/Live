//
//  CBLiveVC.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

// 上下滑动切直播控制器
#import <UIKit/UIKit.h>

@interface CBLiveVC : UIViewController

- (instancetype)initWithLives:(NSArray *)lives currentIndex:(NSUInteger)index;

@end
