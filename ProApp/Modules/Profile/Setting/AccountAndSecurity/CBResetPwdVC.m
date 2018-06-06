
//
//  CBResetPwdVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/26.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBResetPwdVC.h"

@interface CBResetPwdVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;

@property (nonatomic, assign) NSInteger authCodeTime;
@property (nonatomic, strong) NSTimer *messsageTimer;

@end

@implementation CBResetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
}

- (IBAction)actionCode:(id)sender {
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length!=11){
        [MBProgressHUD showAutoMessage:@"手机号输入错误"];
        return;
    }
    if (self.phoneTextField.text.length == 0){
        [MBProgressHUD showAutoMessage:@"请输入手机号"];
        return;
    }
    
    {
        self.authCodeTime = 60;
        self.authCodeBtn.userInteractionEnabled = NO;
        NSString *url = urlGetCode;
        NSDictionary *getcode = @{ @"mobile_num": self.phoneTextField.text,
                                   @"status": @"forgetPassword0" };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [PPNetworkHelper POST:url parameters:getcode success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSNumber *code = [responseObject valueForKey:@"code"];
            NSString *descrp = [responseObject valueForKey:@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
            if ([code isEqualToNumber:@200]) {
                if (self.messsageTimer == nil) {
                    self.messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTimeCountDown) userInfo:nil repeats:YES];
                }
            }
            self.authCodeBtn.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            [MBProgressHUD showAutoMessage:@"验证码获取失败"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.authCodeBtn.userInteractionEnabled = YES;
        }];
    }
}

//获取验证码倒计时
-(void)actionTimeCountDown{
    [self.authCodeBtn setTitle:[NSString stringWithFormat:@"%ds", (int)self.authCodeTime] forState:UIControlStateNormal];
    self.authCodeBtn.userInteractionEnabled = NO;
    if (self.authCodeTime <= 0) {
        [self.authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.authCodeBtn.userInteractionEnabled = YES;
        [self.messsageTimer invalidate];
        self.messsageTimer = nil;
        self.authCodeTime = 60;
    }
    self.authCodeTime -= 1;
}

- (IBAction)actionResetPwd:(id)sender {
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length == 0){
        [MBProgressHUD showAutoMessage:@"请输入手机号"];
        return;
    }
    if (self.phoneTextField.text.length!=11){
        [MBProgressHUD showAutoMessage:@"手机号输入错误"];
        return;
    }
    if (self.codeTextField.text.length == 0){
        [MBProgressHUD showAutoMessage:@"请输入验证码"];
        return;
    }
    if (self.pwdTextField.text.length == 0){
        [MBProgressHUD showAutoMessage:@"请输入6-16位登录密码"];
        return;
    }
 
    
    {
        NSString *url = rulRetrievePassword;
        NSDictionary *regDict = @{@"mobile_num":self.phoneTextField.text,
                                  @"password":self.pwdTextField.text,
                                  @"varcode":self.codeTextField.text,
                                  @"repassword":self.pwdTextField.text,
                                  @"token":[CBLiveUserConfig getOwnToken]};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        @weakify(self);
        [PPNetworkHelper POST:url parameters:regDict success:^(id responseObject) {
            @strongify(self);
            NSString *token = [responseObject valueForKey:@"token"];
            [self httpGetUserInfoWithToken:token];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showAutoMessage:@"重置密码失败"];
        }];
    }
}

- (void)httpGetUserInfoWithToken:(NSString *)token {
    NSString *url = urlGetUserInfo;
    NSDictionary *param = @{@"token": token};
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSDictionary *info = [responseObject valueForKey:@"data"];
            CBLiveUser *userInfo = [[CBLiveUser alloc] initWithDic:info];
            [CBLiveUserConfig saveProfile:userInfo];
            
            [MBProgressHUD showAutoMessage:@"重置密码成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"重置密码失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
