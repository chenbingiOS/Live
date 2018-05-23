//
//  CBRegisterVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/11.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBRegisterVC.h"
#import "UITextField+LeftImageView.h"
#import "CBWebVC.h"

//渠道ID
#define registerFlag @"11343"

@interface CBRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;

@property (nonatomic, assign) NSInteger authCodeTime;
@property (nonatomic, strong) NSTimer *messsageTimer;
@end

@implementation CBRegisterVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionChangeBtnState) name:UITextFieldTextDidChangeNotification object:nil];
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
        NSDictionary *getcode = @{ @"mobile": self.phoneTextField.text};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [PPNetworkHelper POST:url parameters:getcode success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSNumber *number = [responseObject valueForKey:@"ret"] ;
            if([number isEqualToNumber:[NSNumber numberWithInt:200]]) {
                NSArray *data = [responseObject valueForKey:@"data"];
                NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
                NSString *msg = [data valueForKey:@"msg"];
                if([code isEqual:@"0"]) {
                    if (self.messsageTimer == nil) {
                        self.messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTimeCountDown) userInfo:nil repeats:YES];
                    }
                    [MBProgressHUD showAutoMessage:@"发送成功"];
                } else {
                    [MBProgressHUD showAutoMessage:msg];
                }
            }
            self.authCodeBtn.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.authCodeBtn.userInteractionEnabled = YES;
        }];
    }
}

- (IBAction)actionRegister:(id)sender {
    
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
    if (self.agreementBtn.selected == NO) {
        [MBProgressHUD showAutoMessage:@"请先同意用户协议"];
        return;
    }
    
    {
        NSString *url = urlUserReg;
        NSDictionary *regDict = @{@"user_login":self.phoneTextField.text,
                                  @"user_pass":self.pwdTextField.text,
                                  @"user_pass2":self.pwdTextField.text,
                                  @"code":self.codeTextField.text,
                                  @"upper":registerFlag };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [PPNetworkHelper POST:url parameters:regDict success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSNumber *number = [responseObject valueForKey:@"ret"] ;
            if([number isEqualToNumber:[NSNumber numberWithInt:200]]) {
                NSArray *data = [responseObject valueForKey:@"data"];
                NSNumber *code = [data valueForKey:@"code"];
                NSString *msg = [data valueForKey:@"msg"];
                if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
                    [MBProgressHUD showAutoMessage:@"注册成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } else{
                    [MBProgressHUD showAutoMessage:msg];
                }
            } else{
                [MBProgressHUD showAutoMessage:[responseObject valueForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (IBAction)actionUserAgreement:(id)sender {
    CBWebVC *vc = [CBWebVC new];
    [vc webViewloadRequestWithURLString:urlPolicy];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)actionChangeBtnState {
    if (self.phoneTextField.text.length == 11) {
        self.authCodeBtn.enabled = YES;
    } else {
        self.authCodeBtn.enabled = NO;
    }
    if (self.phoneTextField.text.length == 11 && self.codeTextField.text.length == 6 && self.pwdTextField.text.length > 0) {
        self.registerBtn.enabled = YES;
    } else {
        self.registerBtn.enabled = NO;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.messsageTimer = nil;
}
@end
