
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
#import "CBRealNameVC.h"
#import "CBAccountVC.h"
#import "CBGiftPackageVC.h"
#import "CBSettingVC.h"
#import "CBNVC.h"
#import "CBEditUserInfoVC.h"
#import "CBMyVideoVC.h"
#import "CBCurrencyVC.h"

// config
#import "CBLiveSettingConfig.h"
#import "CBLiveUserConfig.h"

@interface CBProfileVC ()

// 用户信息 UI
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *userAvaterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userSexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userLevelImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *userDescLab;
@property (weak, nonatomic) IBOutlet UILabel *userAttentionLab;
@property (weak, nonatomic) IBOutlet UILabel *userFansLab;

@end

@implementation CBProfileVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self reloadByProfile];
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

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.contentHeightConstraint.constant = 750;
}

- (void)setupUI {
    [self.userAvaterImageView roundedCornerByDefault];
    [self reloadByProfile];
}

// 加载头部信息
- (void)reloadByProfile {
    CBLiveUser *user = [CBLiveUserConfig myProfile];
    [self.userAvaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    if ([user.sex isEqualToString:@"0"]) {
        self.userSexImageView.hidden = YES;
    } else if ([user.sex isEqualToString:@"2"]) {
        [self.userSexImageView setImage:[UIImage imageNamed:@"female"]];
    } else if ([user.sex isEqualToString:@"1"]) {
        [self.userSexImageView setImage:[UIImage imageNamed:@"men"]];
    }
    self.userNameLab.text = user.user_nicename;
    [self.userLevelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"v%@", user.user_level]]];
    self.userDescLab.text = user.signature;
    self.userAttentionLab.text = user.attention_num ? user.attention_num : @"0";
    self.userFansLab.text = user.fans_num ? user.fans_num : @"0";
}

- (IBAction)actionPlayVideoTime:(id)sender {
    NSLog(@"直播次数");
}

- (IBAction)actionMessage:(id)sender {
    NSLog(@"消息");
}

// 我的关注
- (IBAction)actionMyAttention:(id)sender {
    CBMyAttentionVC *vc = [CBMyAttentionVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 我的粉丝
- (IBAction)actionMyFans:(id)sender {
    CBMyFansVC *vc = [CBMyFansVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionGuardian:(id)sender {
    NSLog(@"守护");
}

- (IBAction)actionDiamond:(id)sender {
    NSLog(@"钻石");
}

// 蜂窝币
- (IBAction)actionCurrency:(id)sender {
    CBCurrencyVC *vc = [CBCurrencyVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionMyGuild:(id)sender {
    NSLog(@"我的公会");
}

- (IBAction)actionMyVideo:(id)sender {
    CBMyVideoVC *vc = [CBMyVideoVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionLiveTime:(id)sender {
    NSLog(@"直播时长");
}

// 实名认证
- (IBAction)actionRealName:(id)sender {
    CBRealNameVC *vc = [CBRealNameVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionEditUserInfo:(id)sender {
    CBEditUserInfoVC *vc = [CBEditUserInfoVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 设置
- (IBAction)actionSetting:(id)sender {
    CBSettingVC *vc = [CBSettingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
