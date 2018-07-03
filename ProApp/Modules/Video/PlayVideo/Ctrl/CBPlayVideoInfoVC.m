//
//  CBPlayVideoInfoVC.m
//  ProApp
//
//  Created by hxbjt on 2018/7/2.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPlayVideoInfoVC.h"
#import "CBShortVideoVO.h"
#import "UIImageView+RoundedCorner.h"
#import "CBShareView.h"

@interface CBPlayVideoInfoVC ()

@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic, strong) CBSharePopView *sharePopView;

@end

@implementation CBPlayVideoInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)joinVideoRoom {
    
}

- (void)leaveVideoRoom {
    
}

- (void)httpAddAttentionBtn:(UIButton *)sender {
    NSString *url = urlAddAttention;
    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken],
                            @"userid": self.shortVideoVO.uid};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            self.shortVideoVO.is_attention = @"1";
            sender.hidden = YES;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)httpLikeVideoBtn:(UIButton *)sender {
    NSString *url = urlLikeVideo;
    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken],
                            @"id": self.shortVideoVO.ID};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            self.shortVideoVO.is_like = @"1";
            self.shortVideoVO.likes = responseObject[@"data"][@"likes"];
            [self.likeBtn setTitle:self.shortVideoVO.likes forState:UIControlStateNormal];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

// 短视频
- (void)setShortVideoVO:(CBShortVideoVO *)shortVideoVO {
    _shortVideoVO = shortVideoVO;
    
    [_avaterImageView roundedCornerByDefault];
    [_avaterImageView sd_setImageWithURL:[NSURL URLWithString:shortVideoVO.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    _userNameLab.text = shortVideoVO.user_nicename;
    [_likeBtn setTitle:shortVideoVO.likes forState:UIControlStateNormal];
    [_messageBtn setTitle:shortVideoVO.comments forState:UIControlStateNormal];
    _attentionBtn.hidden = YES;
    if ([_shortVideoVO.is_attention isEqualToString:@"0"]) {
        _attentionBtn.hidden = NO;
    }
}

- (IBAction)actionCloseBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KNotificationCloseLiveVC" object:nil];
}

- (IBAction)actionShareBtn:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.sharePopView showIn:window];
}

- (IBAction)actionAttentionBtn:(UIButton *)sender {
    [self httpAddAttentionBtn:sender];
}

- (IBAction)actionLikeBtn:(UIButton *)sender {
    
    if ([self.shortVideoVO.is_like isEqualToString:@"0"]) {
        [self httpLikeVideoBtn:sender];
    }
}

#pragma mark - layz
- (CBSharePopView *)sharePopView {
    if (!_sharePopView) {
        CGFloat height = 180;
        if (iPhoneX) { height += 35;}
        _sharePopView = [[CBSharePopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    }
    return _sharePopView;
}

@end
