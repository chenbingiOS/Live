//
//  CBLiveAndienceAnchorRecordCell.m
//  ProApp
//
//  Created by hxbjt on 2018/7/13.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveAndienceAnchorRecordCell.h"

@implementation CBLiveAndienceAnchorRecordCell

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
    
    self.userNickNameLab.text = liveUser.user_nicename;
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:liveUser.gifticon_25] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.giftCountLab.text = liveUser.object_num;
}

@end
