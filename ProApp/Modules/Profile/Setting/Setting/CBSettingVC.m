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
#import "CBAboutVC.h"

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
    CBAboutVC *vc = [CBAboutVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionLogout:(id)sender {
    
}

@end
