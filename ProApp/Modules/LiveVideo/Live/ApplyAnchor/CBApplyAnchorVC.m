//
//  CBApplyAnchorVC.m
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBApplyAnchorVC.h"
#import "CBWebVC.h"
#import "CBSelectGuildVC.h"

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

- (IBAction)actionJoinGuild:(id)sender {
    CBSelectGuildVC *vc = [CBSelectGuildVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionPersonnel:(id)sender {
    NSLog(@"个人入住");
}

- (IBAction)actionUserAgreement:(id)sender {
    CBWebVC *vc = [CBWebVC new];
    [vc webViewloadRequestWithURLString:urlPolicy];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
