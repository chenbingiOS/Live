//
//  CBLoginVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLoginVC.h"
#import "CBRegisterVC.h"
#import "UITextField+LeftImageView.h"

@interface CBLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation CBLoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.phoneTextField leftImageViewImageName:@"login_icon_phone"];
    [self.pwdTextField leftImageViewImageName:@"login_icon_password"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionRegister:(id)sender {
    CBRegisterVC *vc = [CBRegisterVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
