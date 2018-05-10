//
//  CBLivePlayerVC.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PLPlayerKit/PLPlayerKit.h>

@class ALinLive;
@interface CBLivePlayerVC : UIViewController

@property (nonatomic, strong) ALinLive *live;  /** 直播 */

@property (nonatomic, strong) PLPlayer      *player;
//@property (nonatomic, strong) UIButton      *playButton;
@property (nonatomic, strong) UIImageView   *thumbImageView;

@property (nonatomic, strong) UIButton      *closeButton;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) NSURL *thumbImageURL;

//是否启用手指滑动调节音量和亮度, default YES
@property (nonatomic, assign) BOOL enableGesture;

@end
