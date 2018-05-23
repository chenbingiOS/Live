//
//  CBTBC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/8.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBTBC.h"
#import "CBNVC.h"
#import "CBHomeMenuView.h"
#import "CBApplyAnchorVC.h"

@interface CBTBC () <UITabBarControllerDelegate>

@property (nonatomic, strong) CBHomeMenuPopView *homeMenuPopView;

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
                         @"CBAttentionLiveVC",
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
    for (NSUInteger i = 0; i < ctrlArr.count; i++)
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
        [self.homeMenuPopView showIn:tabBarController.view];
        @weakify(self);
        [self.homeMenuPopView.homeMenuView.liveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            CBApplyAnchorVC *vc = [CBApplyAnchorVC new];
            CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:^{
                
            }];
        }];
        [self.homeMenuPopView.homeMenuView.videoButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            CBApplyAnchorVC *vc = [CBApplyAnchorVC new];
            CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:^{
                
            }];
        }];
        return NO;
    }
    
    return YES;
}


- (CBHomeMenuPopView *)homeMenuPopView {
    if (!_homeMenuPopView) {
        _homeMenuPopView = [[CBHomeMenuPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    }
    return _homeMenuPopView;
}

@end

























