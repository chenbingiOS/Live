//
//  CBAccountAndSecurityVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/26.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAccountAndSecurityVC.h"
#import "CBResetPwdVC.h"
#import "CBPhoneBindVC.h"

@interface CBAccountAndSecurityVC ()

@end

@implementation CBAccountAndSecurityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号与安全";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionResetPwd:(id)sender {
    CBResetPwdVC *vc = [CBResetPwdVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionPhoneBind:(id)sender {
    CBPhoneBindVC *vc = [CBPhoneBindVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
