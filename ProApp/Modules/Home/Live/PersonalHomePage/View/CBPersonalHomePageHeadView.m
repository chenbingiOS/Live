//
//  CBPersonalHomePageHeadView.m
//  ProApp
//
//  Created by hxbjt on 2018/7/12.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPersonalHomePageHeadView.h"

@implementation CBPersonalHomePageHeadView

- (void)setLiveUser:(CBLiveUser *)liveUser {
    _liveUser = liveUser;
    
    self.userNickNameLab.text = liveUser.user_nicename;
    self.numberLab.text = [NSString stringWithFormat:@"蜂窝号：%@", liveUser.ID];
    self.attentionLab.text = liveUser.attention_num;
    self.fansLab.text = liveUser.fans_num;
    self.guardLab.text = liveUser.guard_num;
    
    if ([liveUser.sex isEqualToString:@"0"]) {
        self.sexImageView.hidden = YES;
    } else if ([liveUser.sex isEqualToString:@"2"]) {
        self.sexImageView.hidden = NO;
        [self.sexImageView setImage:[UIImage imageNamed:@"female"]];
    } else if ([liveUser.sex isEqualToString:@"1"]) {
        self.sexImageView.hidden = NO;
        [self.sexImageView setImage:[UIImage imageNamed:@"men"]];
    }
    self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%@", liveUser.user_level]];
    self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"lv%@", liveUser.user_vip_level]];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
}

@end
