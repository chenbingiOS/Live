
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
// config
#import "CBLiveSettingConfig.h"
#import "CBLiveUserConfig.h"

@interface CBProfileVC ()

// 用户信息 UI
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *userAvaterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userLevelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *userDescLab;
@property (weak, nonatomic) IBOutlet UILabel *userAttentionLab;
@property (weak, nonatomic) IBOutlet UILabel *userFansBtn;

@property (nonatomic, strong) NSArray *listArr;
@property (nonatomic, strong) NSDictionary *infoArray;//个人信息

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
    
    self.listArr = [NSArray arrayWithArray:[CBLiveSettingConfig getpersonc]];
    [self setupUI];
}

- (void)httpGetUserInfo {
    NSString *url = urlGetUserInfo;
    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken]};
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.contentHeightConstraint.constant = 750;
}

- (void)setupUI {
    [self.userAvaterImageView roundedCornerByDefault];
    [self loadDataByProfile];
}

// 加载头部信息
- (void)loadDataByProfile {
    [self.userAvaterImageView sd_setImageWithURL:[NSURL URLWithString:[CBLiveUserConfig getavatar]]];
    self.userNameLab.text = [CBLiveUserConfig getOwnNicename];
    if ([[CBLiveUserConfig getSex] isEqualToString:@"0"]) {
        [self.userSexImageView setImage:[UIImage imageNamed:@"female"]];        
    } else {
        [self.userSexImageView setImage:[UIImage imageNamed:@"men"]];
    }
    [self.userLevelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"v%@", [CBLiveUserConfig getLevel]]]];
//    [cell.level_anchorView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",[Config level_anchor]]]];
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
    NSLog(@"我的视频");
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
    NSLog(@"修改资料");
}

// 设置
- (IBAction)actionSetting:(id)sender {
    CBSettingVC *vc = [CBSettingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}








- (void)httpPersonSettingInfo{
    // 这个地方传版本号，做上架隐藏，只有版本号跟后台一致，才会隐藏部分上架限制功能，不会影响其他正常使用客户(后台位置：私密设置-基本设置 -IOS上架版本号)
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"]; //本地 build
    NSString *build = [NSString stringWithFormat:@"%@",app_build];
    NSString *url = [NSString stringWithFormat:urlGetBaseInfo, [CBLiveUserConfig getOwnID], [CBLiveUserConfig getOwnToken], build];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]]) {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"]) {
                CBLiveUser *user = [CBLiveUserConfig myProfile];
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                self.infoArray = info;
//                user.user_nicename = [NSString stringWithFormat:@"%@",[info valueForKey:@"user_nicename"]];
//                user.ID = [NSString stringWithFormat:@"%@", [info valueForKey:@"id"]];
//                user.sex = [NSString stringWithFormat:@"%@", [info valueForKey:@"sex"]];
//                user.level =[NSString stringWithFormat:@"%@", [info valueForKey:@"level"]];
//                user.avatar = [NSString stringWithFormat:@"%@", [info valueForKey:@"avatar"]];
//                user.city = [NSString stringWithFormat:@"%@", [info valueForKey:@"city"]];
//                user.level_anchor = [NSString stringWithFormat:@"%@", [info valueForKey:@"level_anchor"]];
//                [CBLiveUserConfig updateProfile:user];
                //保存靓号和vip信息
//                NSDictionary *liang = [info valueForKey:@"liang"];
//                NSString *liangnum = [NSString stringWithFormat:@"%@", [liang valueForKey:@"name"]];
//                NSDictionary *vip = [info valueForKey:@"vip"];
//                NSString *type = [NSString stringWithFormat:@"%@", [vip valueForKey:@"type"]];
//                NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[type,liangnum] forKeys:@[@"vip_type",@"liang"]];
//                [CBLiveUserConfig saveVipandliang:subdic];
                //                _model = [YBPersonTableViewModel modelWithDic:info];
                NSArray *list = [info valueForKey:@"list"];
                self.listArr = list;
                [CBLiveSettingConfig savepersoncontroller:self.listArr]; //保存在本地，防止没网的时候不显示
                [self loadDataByProfile];
            }
            
            if ([code isEqual:@"700"]) {
                // 退出登录
                //                [self quitLogin];
            }
            else{
                self.listArr = [NSArray arrayWithArray:[CBLiveSettingConfig getpersonc]];
                [self loadDataByProfile];
            }
        }
        else{
            self.listArr = [NSArray arrayWithArray:[CBLiveSettingConfig getpersonc]];
            [self loadDataByProfile];
        }
    } failure:^(NSError *error) {
        self.listArr = [NSArray arrayWithArray:[CBLiveSettingConfig getpersonc]];
        [self loadDataByProfile];
    }];
}

// 观看记录
- (IBAction)actionWatch:(id)sender {
    CBWatchVC *vc = [CBWatchVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 账户
- (IBAction)actionAccount:(id)sender {
    CBAccountVC *vc = [CBAccountVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 礼包
- (IBAction)actionGiftPackage:(id)sender {
    CBGiftPackageVC *vc = [CBGiftPackageVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionLogin:(id)sender {
    CBLoginVC *vc = [CBLoginVC new];
    CBNVC *navc = [[CBNVC alloc] initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}
@end
