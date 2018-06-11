//
//  CBRealNameVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBRealNameVC.h"
#import "CBFillInfoWebVC.h"

@interface CBRealNameVC ()

@property (weak, nonatomic) IBOutlet UIView *notYetRealNameView;        ///< 未实名认证
@property (weak, nonatomic) IBOutlet UIView *inTheAuthenticationView;   ///< 实名认证中
@property (weak, nonatomic) IBOutlet UIView *alreadyRealNameView;       ///< 已经实名认证
//返回按钮
@property (nonatomic) UIBarButtonItem* customBackBarItem;

@end

@implementation CBRealNameVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self httpGetUserInfoWithToken:[CBLiveUserConfig getOwnToken]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    
    [self relaodData];
    
    self.notYetRealNameView.hidden = NO;
}

- (void)relaodData {
    if ([[CBLiveUserConfig myProfile].is_truename isEqualToString:@"0"]) {
        self.notYetRealNameView.hidden = NO;
    } else if ([[CBLiveUserConfig myProfile].is_truename isEqualToString:@"1"]) {
        self.alreadyRealNameView.hidden = NO;
    } else if ([[CBLiveUserConfig myProfile].is_truename isEqualToString:@"2"]) {
        self.inTheAuthenticationView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCertification:(id)sender {
    CBFillInfoWebVC *vc = [CBFillInfoWebVC new];    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUICloseItem {
    [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
}

- (void)customBackItemClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"login_close"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIButton *backButton = [[UIButton alloc] init];
        backButton.size = CGSizeMake(44, 44);
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
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
            [self relaodData];
        }
    } failure:^(NSError *error) {
    }];
}

@end
