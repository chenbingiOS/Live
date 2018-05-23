//
//  CBApplyAnchorVC.m
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBApplyAnchorVC.h"

@interface CBApplyAnchorVC ()

@end

@implementation CBApplyAnchorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请成为主播";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionUserAgreement:(id)sender {
    NSLog(@"用户协议");
}

- (IBAction)actionJoinGuild:(id)sender {
    NSLog(@"工会");
}

- (IBAction)actionPersonnel:(id)sender {
    NSLog(@"个人入住");
}

@end
