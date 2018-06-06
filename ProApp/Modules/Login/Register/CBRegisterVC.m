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
#import "CBTBC.h"

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
                                   @"status": @"register0" };
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

- (IBAction)actionRegister:(id)sender {
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
    if (self.agreementBtn.selected == NO) {
        [MBProgressHUD showAutoMessage:@"请先同意用户协议"];
        return;
    }
    
    {
        NSString *url = urlUserReg;
        NSDictionary *regDict = @{@"mobile_num":self.phoneTextField.text,
                                  @"password":self.pwdTextField.text,
                                  @"varcode":self.codeTextField.text };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        @weakify(self);
        [PPNetworkHelper POST:url parameters:regDict success:^(id responseObject) {
            @strongify(self);
            NSString *token = [responseObject valueForKey:@"token"];
            [self httpGetUserInfoWithToken:token];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showAutoMessage:@"注册失败"];
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
            NSDictionary *info = [responseObject valueForKey:@"info"];
            CBLiveUser *userInfo = [[CBLiveUser alloc] initWithDic:info];
            [CBLiveUserConfig saveProfile:userInfo];
            
            [self loginENClient];
            [self loginJPUSH];
            [self loginUI];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"登录失败"];
    }];
}

// 环信登录
-(void)loginENClient{
    [[EMClient sharedClient] loginWithUsername:[CBLiveUserConfig getHXuid] password:[CBLiveUserConfig getHXpwd] completion:^(NSString *aUsername, EMError *aError) {
        if (aError) {
            NSLog(@"环信登录错误--%@",aError.errorDescription);
        } else {
            NSLog(@"环信登录成功--%@",aUsername);
        }
    }];
}

// 登录极光
- (void)loginJPUSH {
    NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH", [CBLiveUserConfig getOwnID]];
    //    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
}

// 本地UI登录
- (void)loginUI {
    CBTBC *tbc = [CBTBC new];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tbc;
}

- (IBAction)actionUserAgreement:(id)sender {
    [self.view endEditing:YES];
    CBWebVC *vc = [CBWebVC new];
    vc.title = @"服务和隐私条款";
    [vc webViewloadRequestWithURLString:urlH5Policy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionUserAgreementCheck:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
}

- (IBAction)actionLogin:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actoinClose:(id)sender {
    [self.view endEditing:YES];
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
