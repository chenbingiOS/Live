//
//  CBTBC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/8.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBTBC.h"
#import "CBNVC.h"

@interface CBTBC () <UITabBarControllerDelegate>

@end

@implementation CBTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.translucent = YES;
    
    [self _PhoneTBC_setupVCs];
}

/** 配置底部标签栏 */
- (void)_PhoneTBC_setupVCs {
    NSArray *ctrlArr = @[@"CBHomeVC",
                         @"CBVideoVC",
                         @"CBLiveVideoVC",
                         @"CBAttentionVC",
                         @"CBProfileVC"];
    NSArray *imgOffAry = @[@"home",
                           @"video",
                           @"liveVideo",
                           @"follow",
                           @"my"];
    NSArray *imgOnAry = @[@"home_pre",
                          @"video_pre",
                          @"liveVideo",
                          @"follow_pre",
                          @"my_pre"];
    NSArray *titleAry =  @[@"直播",
                           @"视频",
                           @"直播&小视频",
                           @"关注",
                           @"我的" ];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < ctrlArr.count; i++)
    {
        Class cls = NSClassFromString(ctrlArr[i]);
        UIViewController *vCtrl = (UIViewController *)[[cls alloc] init];
        
        vCtrl.tabBarItem.tag = i;
        vCtrl.tabBarItem.title = titleAry[i];
        vCtrl.tabBarItem.image = [[UIImage imageNamed:imgOffAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vCtrl.tabBarItem.selectedImage = [[UIImage imageNamed:imgOnAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
        if (i == 2) {
            vCtrl.tabBarItem.title = @"";
            vCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }
        
        CBNVC *navi = [[CBNVC alloc] initWithRootViewController:vCtrl];
        [array addObject:navi];
    }
    self.viewControllers = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    CBNVC *naviCtrl = (CBNVC *)viewController;
    id viewCtrl = [naviCtrl.viewControllers firstObject];
    
    if ([viewCtrl isKindOfClass:NSClassFromString(@"CBLiveVideoVC")]) {
        return NO;
    }
    
    return YES;
}

@end

























