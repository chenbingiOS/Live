//
//  CBLivePlayerVC.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPlayerVC.h"

@class ALinLive;
@interface CBLivePlayerVC : CBPlayerVC

@property (nonatomic, strong) ALinLive *live;  /** 直播 */

@end
