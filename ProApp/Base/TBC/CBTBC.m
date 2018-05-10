//
//  CBTBC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/8.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBTBC.h"
#import "CBNVC.h"

@interface CBTBC ()

@end

@implementation CBTBC

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self _PhoneTBC_setupVCs];
    [self _PhoneTBC_setupViews];
}

- (void)_PhoneTBC_setupVCs {
    UIViewController *vc1 = [NSClassFromString(@"CBHomeVC") new];
    CBNVC *nc1 = [[CBNVC alloc] initWithRootViewController:vc1];
    UIViewController *vc2 = [NSClassFromString(@"CBVideoVC") new];
    CBNVC *nc2 = [[CBNVC alloc] initWithRootViewController:vc2];
    UIViewController *vc3 = [NSClassFromString(@"CBAttentionVC") new];
    CBNVC *nc3 = [[CBNVC alloc] initWithRootViewController:vc3];
    UIViewController *vc4 = [NSClassFromString(@"CBProfileVC") new];
    CBNVC *nc4 = [[CBNVC alloc] initWithRootViewController:vc4];
    [self setViewControllers:@[nc1, nc2, nc3, nc4] animated:NO];
}

- (void)_PhoneTBC_setupViews {
    NSArray *imgOffAry = @[@"home",
                           @"video",
                           @"follow",
                           @"my"];
    NSArray *imgOnAry = @[@"home_pre",
                          @"video_pre",
                          @"follow_pre",
                          @"my_pre"];
    NSArray *titleAry =  @[@"首页",
                           @"视频",
                           @"关注",
                           @"我的" ];
    NSDictionary *titleSelectColor = @{NSForegroundColorAttributeName : [UIColor titleSelectColor]};
    NSDictionary *titleNormalColor = @{NSForegroundColorAttributeName : [UIColor titleNormalColor]};
    NSArray *vcAry = self.viewControllers;
    for (NSInteger i = 0; i < vcAry.count; i++) {
        UIViewController *vCtrl = (UIViewController *)vcAry[i];
        vCtrl.tabBarItem.image = [[UIImage imageNamed:imgOffAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vCtrl.tabBarItem.selectedImage = [[UIImage imageNamed:imgOnAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vCtrl.tabBarItem.title = titleAry[i];
        
        // 选中颜色
        [vCtrl.tabBarItem setTitleTextAttributes:titleSelectColor forState:UIControlStateSelected];
        [vCtrl.tabBarItem setTitleTextAttributes:titleNormalColor forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
