//
//  CBLiveAnchorGrardianListCell.m
//  ProApp
//
//  Created by hxbjt on 2018/7/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveAnchorGrardianListCell.h"
#import "UIImageView+RoundedCorner.h"

@implementation CBLiveAnchorGrardianListCell

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

    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    [self.avaterImageView roundedCornerByDefault];
    self.userNameLab.text = liveUser.user_nicename;
    self.timeLab.text = liveUser.shouhu_time;
    if ([liveUser.level isEqualToString:@"4"]) {
        self.guardianImageView.image = [UIImage imageNamed:@"live_min_grardian"];
    } else {
        self.guardianImageView.image = [UIImage imageNamed:@"live_max_grardian"];
    }    
}

@end
