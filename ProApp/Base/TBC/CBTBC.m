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
#import "CBRecordVideoVC.h"
#import "RecordViewController.h"
#import "CBOpenLiveVC.h"
#import "CBRealNameVC.h"

@interface CBTBC () <UITabBarControllerDelegate>

@property (nonatomic, strong) CBHomeMenuPopView *homeMenuPopView;

@end

@implementation CBTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    @weakify(self);
    [self.homeMenuPopView.homeMenuView.liveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        UIViewController *vc = nil;
        // 实名认证
        if (![[CBLiveUserConfig myProfile].is_truename isEqualToString:@"1"]) {
            vc = [CBRealNameVC new];
            [(CBRealNameVC *)vc setupUICloseItem];
        } else {
            // 是否主播
            if ([[CBLiveUserConfig myProfile].is_host isEqualToString:@"1"]) {
                vc = [CBOpenLiveVC new];
            } else {
                vc = [CBApplyAnchorVC new];
            }
        }
        CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:vc];
        [self.selectedViewController presentViewController:nvc animated:YES completion:^{
            [self.homeMenuPopView hide];
        }];
    }];
    [self.homeMenuPopView.homeMenuView.videoButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        CBRecordVideoVC *recordVC = [[CBRecordVideoVC alloc] init];
        CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:recordVC];
        [self.selectedViewController presentViewController:nvc animated:YES completion:^{
            [self.homeMenuPopView hide];
        }];
    }];
    
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
    
    __block CBNVC *naviCtrl = (CBNVC *)viewController;
    id viewCtrl = [naviCtrl.viewControllers firstObject];
    
    if ([viewCtrl isKindOfClass:NSClassFromString(@"CBLiveVideoVC")]) {
        [self.homeMenuPopView showIn:tabBarController.view];
        return NO;
    }
    
    return YES;
}


- (CBHomeMenuPopView *)homeMenuPopView {
    if (!_homeMenuPopView) {
        CGFloat height = 180;
        if (iPhoneX) {
            height += 35;
        }
        _homeMenuPopView = [[CBHomeMenuPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    }
    return _homeMenuPopView;
}

@end

























