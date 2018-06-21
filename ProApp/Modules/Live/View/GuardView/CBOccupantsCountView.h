//
//  CBOccupantsCountView.h
//  ProApp
//
//  Created by hxbjt on 2018/6/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBActionLiveDelegate.h"

// 观众数量，贡献币数量
@class CBAppLiveVO;
@interface CBOccupantsCountView : UIView

@property (nonatomic, weak) id <CBActionLiveDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO *)room;

- (void)_UI_reload;

@end
