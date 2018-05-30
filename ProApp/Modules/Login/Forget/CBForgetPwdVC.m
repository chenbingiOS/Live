//
//  CBForgetPwdVC.m
//  ProApp
//
//  Created by hxbjt on 2018/5/29.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBForgetPwdVC.h"

@interface CBForgetPwdVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, assign) NSInteger authCodeTime;
@property (nonatomic, strong) NSTimer *messsageTimer;

@end

@implementation CBForgetPwdVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self.phoneTextField becomeFirstResponder];
    self.authCodeTime = 60;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionChangeBtnState) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)actionChangeBtnState {
    if (self.phoneTextField.text.length == 11) {
        self.codeButton.enabled = YES;
    } else {
        self.codeButton.enabled = NO;
    }
    if (self.phoneTextField.text.length == 11 && self.codeTextField.text.length == 6 && self.pwdTextField.text.length > 0 && self.checkPwdTextField.text.length >0) {
        self.okButton.enabled = YES;
    } else {
        self.okButton.enabled = NO;
    }
}

//获取验证码倒计时
-(void)actionTimeCountDown{
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ds", (int)self.authCodeTime] forState:UIControlStateNormal];
    self.codeButton.userInteractionEnabled = NO;
    if (self.authCodeTime <= 0) {
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeButton.userInteractionEnabled = YES;
        [self.messsageTimer invalidate];
        self.messsageTimer = nil;
        self.authCodeTime = 60;
    }
    self.authCodeTime -= 1;
}


- (IBAction)actionGetCode:(id)sender {
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
        self.codeButton.userInteractionEnabled = NO;
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
            self.codeButton.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            [MBProgressHUD showAutoMessage:@"验证码获取失败"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.codeButton.userInteractionEnabled = YES;
        }];
    }
}

- (IBAction)actionOKPwd:(id)sender {
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
    if (self.checkPwdTextField.text.length == 0){
        [MBProgressHUD showAutoMessage:@"请输入6-16位登录密码"];
        return;
    }
    
    {
        NSString *url = urlUserForget;
        NSDictionary *regDict = @{@"mobile_num":self.phoneTextField.text,
                                  @"varcode":self.codeTextField.text,
                                  @"password":self.pwdTextField.text,
                                  @"repassword":self.checkPwdTextField.text};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [PPNetworkHelper POST:url parameters:regDict success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSNumber *code = [responseObject valueForKey:@"code"];
            NSString *descrp = [responseObject valueForKey:@"descrp"];
            NSString *token = [responseObject valueForKey:@"token"];
            [MBProgressHUD showAutoMessage:descrp];
            if ([code isEqualToNumber:@200]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showAutoMessage:@"注册失败"];
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.messsageTimer = nil;
}

@end
