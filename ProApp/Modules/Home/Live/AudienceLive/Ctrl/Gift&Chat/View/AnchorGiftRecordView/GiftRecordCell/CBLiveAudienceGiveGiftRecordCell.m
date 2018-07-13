//
//  CBLiveAudienceGiveGiftRecordCell.m
//  ProApp
//
//  Created by hxbjt on 2018/7/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveAudienceGiveGiftRecordCell.h"

@implementation CBLiveAudienceGiveGiftRecordCell

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
    self.coinLab.text = liveUser.money;
}
@end
