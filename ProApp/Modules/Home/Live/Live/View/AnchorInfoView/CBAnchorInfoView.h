//
//  CBAnchorInfoView.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@class CBAnchorInfoXibView;
@class CBAppLiveVO;

@interface CBAnchorInfoView : CBPopView

@property (nonatomic, strong) CBAnchorInfoXibView *acnchorInfoXibView;
@property (nonatomic, strong) CBAppLiveVO *liveVO;

@end
