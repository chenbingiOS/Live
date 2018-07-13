//
//  CBPersonalHomePageVC.h
//  ProApp
//
//  Created by hxbjt on 2018/7/12.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
// 个人主页

#define RGBColorAlpha(r,g,b,f)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:f]
#define RGBColor(r,g,b)          RGBColorAlpha(r,g,b,1)

typedef NS_ENUM(NSInteger,STControllerType) {
    STControllerTypeNormal,
    STControllerTypeHybrid,
    STControllerTypeDisableBarScroll,
    STControllerTypeHiddenNavBar,
};

@interface CBPersonalHomePageVC : UIViewController

@property (nonatomic, assign) STControllerType type;
@property (nonatomic, strong) UIImageView * headerImageView;

@end


