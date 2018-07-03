//
//  CBPlayVideoInfoVC.h
//  ProApp
//
//  Created by hxbjt on 2018/7/2.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBShortVideoVO;
@interface CBPlayVideoInfoVC : UIViewController

@property (nonatomic, strong) CBShortVideoVO *shortVideoVO;
- (void)joinVideoRoom;
- (void)leaveVideoRoom;

@end
