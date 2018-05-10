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
#import "LoginViewController.h"

@implementation AppDelegate (AppServer)

#pragma mark - 初始化 Window
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

#pragma mark - rootVC
- (void)initRootVC {
    self.rootVC = [LoginViewController new];
    self.window.rootViewController = self.rootVC;
}

#pragma mark - 全局外观
- (void)initApperance {
    // 状态栏黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // 禁止按钮同时触发
    [[UIButton appearance] setExclusiveTouch:YES];
    // 按钮被点击高亮提醒
    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    //    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = KWhiteColor;
    // iOS 11 ScrollView 偏移量
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    // 关闭Cell高度估算
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    // 关系cell点击效果
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    // 导航栏返回按钮
    [[UIBarButtonItem appearance] setTintColor:[UIColor backColor]];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"jht_dly_fh"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // 导航栏
    [UINavigationBar appearance].translucent = NO;
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor titleNormalColor]}];
    //    if (iPhoneX) {
    //        [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"jht_iphoenx"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forBarMetrics:UIBarMetricsDefault];
    //    } else {
    //        [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"jht_sy_ztl"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forBarMetrics:UIBarMetricsDefault];
    //    }
    
}

@end




















