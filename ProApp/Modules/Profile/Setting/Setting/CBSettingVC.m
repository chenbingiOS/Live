//
//  CBSettingVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/26.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBSettingVC.h"
#import "CBAccountAndSecurityVC.h"
#import "CBNotificationsVC.h"
#import "CBFeedBackVC.h"
#import "CBBlackListVC.h"
#import "CBLoginVC.h"
#import "CBWebVC.h"
#import "CBNVC.h"

@interface CBSettingVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@end

@implementation CBSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.viewWidthConstraint.constant = kScreenWidth;
    self.viewHeightConstraint.constant = kScreenHeight;
}

- (IBAction)actionAccountAndSecurity:(id)sender {
    CBAccountAndSecurityVC *vc = [CBAccountAndSecurityVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionNotifications:(id)sender {
    CBNotificationsVC *vc = [CBNotificationsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionBlacklist:(id)sender {
    CBBlackListVC *vc = [CBBlackListVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionFeedback:(id)sender {
    CBFeedBackVC *vc = [CBFeedBackVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionToScore:(id)sender {
}

- (IBAction)actionAbout:(id)sender {
    CBWebVC *vc = [CBWebVC new];
    vc.title = @"关于蜂窝TV";
    [vc webViewloadRequestWithURLString:urlH5AboutUs];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionLogout:(id)sender {
    NSString *url = urlOutlogin;
    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        [CBLiveUserConfig clearProfile];
        [self logoutUI];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"退出登录失败"];
    }];
}

// 本地UI登录
- (void)logoutUI {
    CBLoginVC *vc = [CBLoginVC new];
    CBNVC *navc = [[CBNVC alloc] initWithRootViewController:vc];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = navc;
}


@end
