//
//  AppDelegate+AppServer.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "AppDelegate+AppServer.h"
#import "CBTBC.h"
#import "CBNVC.h"
#import "HcdGuideView.h"

@implementation AppDelegate (AppServer)

#pragma mark - 初始化 Window
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

#pragma mark - rootVC
- (void)initRootVC {
    
    self.rootVC = [CBTBC new];
    self.window.rootViewController = self.rootVC;
    
    // 引导页面
    NSMutableArray *images = [NSMutableArray new];
    if (iPhoneX) {
        [images addObject:[UIImage imageNamed:@"guide_X1"]];
        [images addObject:[UIImage imageNamed:@"guide_X2"]];
        [images addObject:[UIImage imageNamed:@"guide_X3"]];
    } else {
        [images addObject:[UIImage imageNamed:@"guide_1"]];
        [images addObject:[UIImage imageNamed:@"guide_2"]];
        [images addObject:[UIImage imageNamed:@"guide_3"]];
    }
    HcdGuideView *guideView = [HcdGuideView sharedInstance];
    guideView.window = self.window;
    [guideView showGuideViewWithImages:images
                        andButtonTitle:@"立即体验"
                   andButtonTitleColor:[UIColor whiteColor]
                      andButtonBGColor:[UIColor mainColor]
                  andButtonBorderColor:[UIColor clearColor]];
}

#pragma mark - 全局外观
- (void)initApperance {
    // 状态栏黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    // 导航栏
    [UINavigationBar appearance].translucent = NO;
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor titleNormalColor]}];
//    if (iPhoneX) {
//        [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"jht_iphoenx"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forBarMetrics:UIBarMetricsDefault];
//    } else {
//        [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"jht_sy_ztl"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forBarMetrics:UIBarMetricsDefault];
//    }

//    // 标签栏
//    UIImage *tabBarBackground = [UIImage imageNamed:@"tabbar_bg"]; //需要的图片中包含黑线用作背景
//    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
//    UIImage *tabBarShadow = [UIImage imageNamed:@"tabbar_bg_line"]; //需要的图片是一个1像素的透明图片
//    [[UITabBar appearance] setShadowImage:tabBarShadow];
    
    // 标签栏按钮
    UITabBarItem *item = [UITabBarItem appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    [textAttrs addEntriesFromDictionary:@{NSForegroundColorAttributeName : [UIColor titleNormalColor]}];
    [textAttrs addEntriesFromDictionary:@{NSFontAttributeName : [UIFont systemFontOfSize:11.0]}];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    [selectTextAttrs addEntriesFromDictionary:@{NSForegroundColorAttributeName : [UIColor titleSelectColor]}];
    [selectTextAttrs addEntriesFromDictionary:@{NSFontAttributeName : [UIFont systemFontOfSize:11.0]}];
    [item setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
        
    // 按钮
    [[UIButton appearance] setExclusiveTouch:YES];  // 禁止按钮同时触发
    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];   // 按钮被点击高亮提醒
    
    //    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = KWhiteColor;
    
    // iOS 11 ScrollView 偏移量
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    // TableView
    // 关闭Cell高度估算
    [UITableView appearance].estimatedRowHeight = 0;    
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    // 关系cell点击效果
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // 导航栏返回按钮
    [[UIBarButtonItem appearance] setTintColor:[UIColor backColor]];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"jht_dly_fh"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

@end




















