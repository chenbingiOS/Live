//
//  CBRealNameVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBRealNameVC.h"
#import "CBFillInfoViewController.h"

@interface CBRealNameVC ()

@property (weak, nonatomic) IBOutlet UIView *notYetRealNameView;        ///< 未实名认证
@property (weak, nonatomic) IBOutlet UIView *inTheAuthenticationView;   ///< 实名认证中
@property (weak, nonatomic) IBOutlet UIView *alreadyRealNameView;       ///< 已经实名认证


@end

@implementation CBRealNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.notYetRealNameView.hidden = NO;
//    self.inTheAuthenticationView.hidden = NO;
//    self.alreadyRealNameView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCertification:(id)sender {
    CBFillInfoViewController *fillInfoVC = [CBFillInfoViewController new];
    [self.navigationController pushViewController:fillInfoVC animated:YES];
}

@end
