//
//  CBPlayVideoVC.h
//  ProApp
//
//  Created by hxbjt on 2018/6/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPlayerVC.h"

@class CBShortVideoVO;
@interface CBPlayVideoVC : CBPlayerVC

@property (nonatomic, strong) CBShortVideoVO *video;

@end
