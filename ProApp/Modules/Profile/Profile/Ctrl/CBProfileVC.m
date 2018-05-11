
//
//  CBProfileVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBProfileVC.h"
#import "CBMyAttentionVC.h"
#import "CBMyFansVC.h"
#import "CBWatchVC.h"
#import "CBCurrencyVC.h"
#import "CBRealNameVC.h"
#import "CBAccountVC.h"
#import "CBGiftPackageVC.h"
#import "CBSettingVC.h"
#import "CBLoginVC.h"
#import "CBNVC.h"

@interface CBProfileVC ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *realNameLab;

@end

@implementation CBProfileVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self setupUI];
}


- (void)setupUI {
    // userAvaterImageView 
    [self.userAvaterImageView roundedCornerByDefault];
}

- (IBAction)actionLogin:(id)sender {
    CBLoginVC *vc = [CBLoginVC new];
    CBNVC *navc = [[CBNVC alloc] initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

- (IBAction)actionMyAttention:(id)sender {
    CBMyAttentionVC *vc = [CBMyAttentionVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionMyFans:(id)sender {
    CBMyFansVC *vc = [CBMyFansVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionCurrency:(id)sender {
    CBCurrencyVC *vc = [CBCurrencyVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionWatch:(id)sender {
    CBWatchVC *vc = [CBWatchVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionRealName:(id)sender {
    CBRealNameVC *vc = [CBRealNameVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionAccount:(id)sender {    
    CBAccountVC *vc = [CBAccountVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionGiftPackage:(id)sender {
    CBGiftPackageVC *vc = [CBGiftPackageVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionSetting:(id)sender {
    CBSettingVC *vc = [CBSettingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
