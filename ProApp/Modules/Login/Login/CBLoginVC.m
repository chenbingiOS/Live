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
    
    self.wxBtn.hidden = YES;
    self.wbBtn.hidden = YES;
    self.qqBtn.hidden = YES;
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
    [vc webViewloadRequestWithURLString:urlH5Policy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionLogin:(id)sender {
    [self.view endEditing:YES];
    NSString *url = urlUserLogin;
    NSDictionary *param = @{@"mobile_num": self.phoneTextField.text,
                            @"password": self.pwdTextField.text};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber *code = [responseObject valueForKey:@"code"];
        NSString *descrp = [responseObject valueForKey:@"descrp"];        
        [MBProgressHUD showAutoMessage:descrp];
        if ([code isEqualToNumber:@200]) {
            NSString *token = [responseObject valueForKey:@"token"];
            NSDictionary *info = [responseObject valueForKey:@"info"];
            CBLiveUser *userInfo = [[CBLiveUser alloc] initWithDic:info];
            userInfo.token = token;
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
        [self thirdLogin:@"wx" platforms:SSDKPlatformTypeWechat];
    } else if (sender.tag == 22) {
        [self thirdLogin:@"wb" platforms:SSDKPlatformTypeSinaWeibo];
    } else if (sender.tag == 33) {
        [self thirdLogin:@"qq" platforms:SSDKPlatformTypeQQ];
    }
}

- (void)thirdLogin:(NSString *)types platforms:(SSDKPlatformType)platform{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SSEThirdPartyLoginHelper loginByPlatform:platform onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
        [self requestLogin:user loginType:types];
    } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [MBProgressHUD showAutoMessage:@"登录失败"];
        }
    }];
}

- (void)requestLogin:(SSDKUser *)user loginType:(NSString *)LoginType {
    NSString *icon = nil;
    if ([LoginType isEqualToString:@"qq"]) {
        icon = [user.rawData valueForKey:@"figureurl_qq_2"];
    } else {
        icon = user.icon;
    }
    if (!icon) {
        [MBProgressHUD showAutoMessage:@"未获取到授权，请重试"];
        return;
    }
    
    NSString *url = urlUserLoginByThird;
    NSDictionary *parma = @{ @"openid": [user.uid stringByURLEncode],
                             @"type": [LoginType stringByURLEncode],
                             @"nicename": [user.nickname stringByURLEncode],
                             @"avatar": [icon stringByURLEncode],
                             @"upper": registerFlag};
    [PPNetworkHelper POST:url parameters:parma success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *MsgData = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[MsgData valueForKey:@"code"]];
            NSString *msg = [MsgData valueForKey:@"msg"];
            if([code isEqual:@"0"]) {
                NSDictionary *info = [[MsgData valueForKey:@"info"] objectAtIndex:0];
                CBLiveUser *userInfo = [[CBLiveUser alloc] initWithDic:info];
                [CBLiveUserConfig saveProfile:userInfo];
                [self loginENClient];
                [self loginJPUSH];
                [self loginUI];
//判断第一次登陆
//                NSString *isreg = minstr([info valueForKey:@"isreg"]);
//                _isreg = isreg;
                
            } else {
                [MBProgressHUD showAutoMessage:msg];
            }
        }
        else{
            [MBProgressHUD showAutoMessage:[responseObject valueForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
