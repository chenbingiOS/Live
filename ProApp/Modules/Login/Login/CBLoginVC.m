//
//  CBLoginVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

// VC
#import "CBLoginVC.h"
#import "CBRegisterVC.h"
#import "CBWebVC.h"
#import "CBTBC.h"
#import "CBForgetPwdVC.h"
// User
#import "CBLiveUser.h"
#import "CBLiveUserConfig.h"
// Category
#import "UITextField+LeftImageView.h"
// Third
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

//渠道ID
#define registerFlag @"11343"

@interface CBLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *wbBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@end

@implementation CBLoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionChangeBtnState) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setupUI {
    [self.phoneTextField leftImageViewImageName:@"login_icon_phone"];
    [self.pwdTextField leftImageViewImageName:@"login_icon_password"];
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
        self.wxBtn.hidden = NO;
    }
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo]) {
        self.wbBtn.hidden = NO;
    }
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
        self.qqBtn.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionClose:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionForgetPwd:(id)sender {
    [self.view endEditing:YES];
    CBForgetPwdVC *vc = [CBForgetPwdVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionRegister:(id)sender {
    [self.view endEditing:YES];
    CBRegisterVC *vc = [CBRegisterVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionPolicy:(id)sender {
    [self.view endEditing:YES];
    CBWebVC *vc = [CBWebVC new];
    vc.title = @"服务和隐私条款";
    [vc webViewloadRequestWithURLString:H5_protocol];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionLogin:(id)sender {
    [self.view endEditing:YES];
    NSString *url = urlUserLogin;
    NSDictionary *param = @{@"mobile_num": self.phoneTextField.text,
                            @"password": self.pwdTextField.text};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSDictionary *rdata = responseObject[@"data"];
            NSString *token = rdata[@"token"];
            [self httpGetUserInfoWithToken:token];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"登录失败"];
    }];
}

- (void)httpGetUserInfoWithToken:(NSString *)token {
    NSString *url = urlGetUserInfo;
    NSDictionary *param = @{@"token": token};
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSDictionary *info = [responseObject valueForKey:@"data"];
            CBLiveUser *userInfo = [[CBLiveUser alloc] initWithDic:info];
            [CBLiveUserConfig saveProfile:userInfo];
            
            [self loginENClient];
            [self loginJPUSH];
            [self loginUI];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"登录失败"];
    }];
}

- (void)actionChangeBtnState {
    if (self.phoneTextField.text.length > 0 && self.pwdTextField.text.length > 0) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}

- (IBAction)actionThirdLogin:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.tag == 11) {
        [self thirdLoginByPlatforms:SSDKPlatformTypeWechat];
    } else if (sender.tag == 22) {
        [self thirdLoginByPlatforms:SSDKPlatformTypeSinaWeibo];
    } else if (sender.tag == 33) {
        [self thirdLoginByPlatforms:SSDKPlatformTypeQQ];
    }
}

- (void)thirdLoginByPlatforms:(SSDKPlatformType)platform{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SSEThirdPartyLoginHelper loginByPlatform:platform onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
        [self requestLogin:user loginType:platform];
    } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"登录失败"];
    }];
}

- (void)requestLogin:(SSDKUser *)user loginType:(SSDKPlatformType)loginType {
    NSString *url = urlSendOauthUserInfo;
    NSDictionary *param = [self paramWithUser:user loginType:loginType];
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSDictionary *rdata = responseObject[@"data"];
            NSString *token = rdata[@"token"];
            [self httpGetUserInfoWithToken:token];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"登录失败"];
    }];
}

- (NSMutableDictionary *)paramWithUser:(SSDKUser *)user loginType:(SSDKPlatformType)loginType {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSString *logAuthTypeType = nil;
    switch (loginType) {
        case SSDKPlatformTypeWechat: logAuthTypeType = @"Wechat"; break;
        case SSDKPlatformTypeQQ: logAuthTypeType = @"QQ"; break;
        case SSDKPlatformTypeSinaWeibo: logAuthTypeType = @"SinaWeibo"; break;
        default: break;
    }
    
    switch (user.gender) {
        case SSDKGenderMale: [paramDict setObject:@"1" forKey:@"sex"]; break;
        case SSDKGenderFemale: [paramDict setObject:@"2" forKey:@"sex"]; break;
        case SSDKGenderUnknown: [paramDict setObject:@"0" forKey:@"sex"]; break;
        default: break;
    }
    
    //生日
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *dateStr = [dateFormatter stringFromDate:user.birthday];
    
    [paramDict setObject:user.uid ? : @"" forKey:@"openid"];                                       //openid
    [paramDict setObject:logAuthTypeType ? : @"" forKey:@"from"];                                  //authorType
    //    [paramDict setObject:[user.rawData objectForKey:@"unionid"] ? : @"" forKey:@"authUnionid"];        //authUnionid
    //    [paramDict setObject:[user.rawData objectForKey:@"age"] ? : @"" forKey:@"userAge"];                //userAge
    [paramDict setObject:user.icon ? : @"" forKey:@"head_img"];                                      //userAvatar
    //    [paramDict setObject:dateStr ? : @"" forKey:@"userBirthday"];                                      //userBirthday
    //    [paramDict setObject:[user.rawData objectForKey:@"city"]?:@"" forKey:@"userCity"];              //userCity
    [paramDict setObject:user.nickname ? : @"" forKey:@"name"];                                //userNickname
    //    [paramDict setObject:[user.rawData objectForKey:@"province"]?:@"" forKey:@"userProvince"];      //userProvince
    //    [paramDict setObject:user.verifyReason?:@"" forKey:@"verifiedReason"];                          //verifiedReason
    [paramDict setObject:user.credential.token ? : @"" forKey:@"access_token"];                          //access_token
    [paramDict setObject:user.credential.expired ? : @"" forKey:@"expires_date"];                          //expires_date
    return paramDict;
}

// 环信登录
-(void)loginENClient{
    [[EMClient sharedClient] loginWithUsername:[CBLiveUserConfig getHXuid] password:[CBLiveUserConfig getHXpwd] completion:^(NSString *aUsername, EMError *aError) {        
        if (aError) {
            NSLog(@"环信登录错误--%@",aError.errorDescription);
        } else {            
            NSLog(@"环信登录成功--%@",aUsername);
            [[EMClient sharedClient].options setIsAutoLogin:YES];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
