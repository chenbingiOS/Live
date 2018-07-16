//
//  CBAnchorInfoXibView.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAnchorInfoXibView.h"
#import "UIImageView+RoundedCorner.h"
#import "CBAppLiveVO.h"
#import "CBAnchorInfoVO.h"

@interface CBAnchorInfoXibView ()

@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *isCer;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UILabel *signatureLab;
@property (weak, nonatomic) IBOutlet UILabel *focusLab;
@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UILabel *sentOutLab;
@property (weak, nonatomic) IBOutlet UILabel *coinLab;
@property (weak, nonatomic) IBOutlet UILabel *impressionA;
@property (weak, nonatomic) IBOutlet UILabel *impressionB;
@property (weak, nonatomic) IBOutlet UILabel *impressionC;
@property (weak, nonatomic) IBOutlet UIButton *addImpressionBtn;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation CBAnchorInfoXibView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avaterImageView roundedCornerByDefault];
}

- (void)setLiveVO:(CBAppLiveVO *)liveVO {
    _liveVO = liveVO;
    [self httpAnchorGetUserInfo];
}

- (void)_reloadData_UI:(CBAnchorInfoVO *)anchorInfoVO {
    CBLiveUser *user = anchorInfoVO.user;
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.isCer.hidden = [user.is_truename isEqualToString:@"1"] ? YES : NO;
    self.userNickName.text = user.user_nicename;
    self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%@", user.user_level]];
    if ([user.sex isEqualToString:@"0"]) {
        self.sexImageView.hidden = YES;
    } else if ([user.sex isEqualToString:@"2"]) {
        self.sexImageView.hidden = NO;
        [self.sexImageView setImage:[UIImage imageNamed:@"female"]];
    } else if ([user.sex isEqualToString:@"1"]) {
        self.sexImageView.hidden = NO;
        [self.sexImageView setImage:[UIImage imageNamed:@"men"]];
    }
    self.roomLab.text = [NSString stringWithFormat:@"房间号: %@", self.liveVO.room_id];
    self.locationLab.text = [NSString stringWithFormat:@"坐标: %@", user.location];
    self.signatureLab.text = user.signature.length ? user.signature : @"这个用户很懒，什么都没有～";    
    self.focusLab.text = user.attention_num;
    self.fansLab.text = user.fans_num;
    self.sentOutLab.text = user.total_spend;
    self.coinLab.text = user.total_earn;
}

- (void)httpAnchorGetUserInfo {
    [self.indicatorView startAnimating];
    self.indicatorView.hidden = NO;
    NSString *url = urlAnchorGetUserInfo;
    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken],
                            @"id": self.liveVO.ID};
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param responseCache:^(id responseCache) {
        @strongify(self);
        NSNumber *code = [responseCache valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSDictionary *data = [responseCache valueForKey:@"data"];
            self.infoVO = [CBAnchorInfoVO modelWithJSON:data];
            [self _reloadData_UI:self.infoVO];
        }
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
        [MBProgressHUD hideHUDForView:self animated:YES];
    } success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            self.infoVO = [CBAnchorInfoVO modelWithJSON:data];
            [self _reloadData_UI:self.infoVO];
        }
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(NSError *error) {
    }];
}

@end

















