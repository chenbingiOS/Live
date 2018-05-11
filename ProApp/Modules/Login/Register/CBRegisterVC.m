//
//  CBRegisterVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/11.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBRegisterVC.h"
#import "UITextField+LeftImageView.h"

@interface CBRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation CBRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    [self.phoneTextField leftImageViewImageName:@"login_icon_phone"];
    [self.codeTextField leftImageViewImageName:@"login_icon_verificationcode"];
    [self.pwdTextField leftImageViewImageName:@"login_icon_password"];
}

- (IBAction)actionCode:(id)sender {
    NSLog(@"验证码");
}

- (IBAction)actionRegister:(id)sender {
    NSLog(@"注册");
}

- (IBAction)actionUserAgreement:(id)sender {
    NSLog(@"用户协议");
}

- (IBAction)actionUserAgreementCheck:(UIButton *)sender {
    sender.selected = !sender.selected;
}


- (IBAction)actionLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actoinClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
