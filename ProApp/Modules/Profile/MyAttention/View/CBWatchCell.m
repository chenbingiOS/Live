//
//  CBWatchCell.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBWatchCell.h"
#import "CBAttentionVO.h"

@implementation CBWatchCell

- (void)loadData:(CBAttentionVO *)data {
    [self.userAvaterImageView sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.titleLabel.text = data.user_nicename;
    self.descLabel.text = data.signature;
    if ([data.sex isEqualToString:@"0"]) {
        self.genderImageView.hidden = YES;
    } else if ([data.sex isEqualToString:@"2"]) {
        [self.genderImageView setImage:[UIImage imageNamed:@"female"]];
    } else if ([data.sex isEqualToString:@"1"]) {
        [self.genderImageView setImage:[UIImage imageNamed:@"men"]];
    }
    if ([data.channel_status isEqualToString:@"2"]) {
        self.liveView.hidden = NO;
    }
} 

@end
