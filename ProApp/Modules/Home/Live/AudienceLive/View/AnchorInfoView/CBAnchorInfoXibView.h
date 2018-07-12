//
//  CBAnchorInfoXibView.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBAppLiveVO;
@interface CBAnchorInfoXibView : UIView

@property (nonatomic, strong) CBAppLiveVO *liveVO;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *herBtn;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;

@end
