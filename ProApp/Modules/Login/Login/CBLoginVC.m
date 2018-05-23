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
// User
#import "CBLiveUser.h"
#import "CBLiveUserConfig.h"
// Category
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

- (IBAction)actionPolicy:(id)sender {
    CBWebVC *vc = [CBWebVC new];
    [vc webViewloadRequestWithURLString:urlPolicy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionLogin:(id)sender {
    
    NSString *url = urlUserLogin;
    NSDictionary *param = @{@"user_login": self.phoneTextField.text,
                            @"user_pass": self.pwdTextField.text};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
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
                
//                NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[CBLiveUserConfig getOwnID]];
//                [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
                
//                [self HYLOgin];
                //判断第一次登陆
//                NSString *isreg = minstr([info valueForKey:@"isreg"]);
//                _isreg = isreg;
//                [self login];
                
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


////注册环信
//-(void)HYLOgin{
//    NSString *passWord = [@"fmscms" stringByAppendingFormat:@"%@",[Config getOwnID]];
//    [[EMClient sharedClient] registerWithUsername:[Config getOwnID] password:passWord completion:^(NSString *aUsername, EMError *aError) {
//        NSLog(@"NewLoginController---%@",aError.errorDescription);
//    }];
//}
//
//-(void)login{
//    ZYTabBarController *root = [[ZYTabBarController alloc]init];
//    [cityDefault saveisreg:_isreg];
//    [self.navigationController pushViewController:root animated:YES];
//
//
//    UIApplication *app =[UIApplication sharedApplication];
//    AppDelegate *app2 = app.delegate;
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
//    app2.window.rootViewController = nav;
//
//
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
