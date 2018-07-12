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

@protocol AnchorInfoViewDelegate <NSObject>

- (void)anchorInfoXibView:(CBAnchorInfoXibView *)infoXibView actionTouchHomeBtn:(UIButton *)btn;

@end

@interface CBAnchorInfoView : CBPopView

@property (nonatomic, weak) id <AnchorInfoViewDelegate> delelgate;
@property (nonatomic, strong) CBAnchorInfoXibView *acnchorInfoXibView;
@property (nonatomic, strong) CBAppLiveVO *liveVO;

@end
