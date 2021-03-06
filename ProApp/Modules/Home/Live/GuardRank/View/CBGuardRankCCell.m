 //
//  CBGuardRankCCell.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBGuardRankCCell.h"

@implementation CBGuardRankCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLiveUser:(CBLiveUser *)liveUser {
    _liveUser = liveUser;
    
    self.orderLab.text = liveUser.orderId;
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    [self.avaterImageView roundedCornerByDefault];
    self.userNickLab.text = liveUser.user_nicename;
    self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%@", liveUser.user_level]];
    self.coinLab.text = liveUser.user_money;
}

@end
