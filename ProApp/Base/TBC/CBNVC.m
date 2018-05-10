//
//  CBNVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/8.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBNVC.h"

@interface CBNVC () <UINavigationControllerDelegate>
@property (nonatomic, assign, getter=isAppearingVC) BOOL appearingVC; ///< 是否正在出现
@end

@implementation CBNVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// push时候因此TabBar，并且保证只push一个页面
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
    if (animated && self.isAppearingVC) {
        // 避免同一时间push多个界面导致的crash
        return ;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.appearingVC = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.appearingVC = NO;
}


@end
