//
//  CBLivePlayerVC.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPlayerVC.h"

@class CBAppLiveVO;
@interface CBLivePlayerVC : CBPlayerVC

@property (nonatomic, strong) CBAppLiveVO *liveVO;  /** 直播 */

@end
