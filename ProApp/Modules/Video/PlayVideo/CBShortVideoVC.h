//
//  CBShortVideoVC.h
//  ProApp
//
//  Created by hxbjt on 2018/6/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBShortVideoVO;
@interface CBShortVideoVC : UIPageViewController

@property (nonatomic, strong) NSArray <CBShortVideoVO *> *videos;  /** 视频 */
@property (nonatomic, assign) NSUInteger currentIndex;      /** 当前的index */

@end
