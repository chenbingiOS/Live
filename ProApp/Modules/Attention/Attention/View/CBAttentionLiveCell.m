//
//  CBAttentionLiveCell.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/14.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAttentionLiveCell.h"
#import "ALinUser.h"

@interface CBAttentionLiveCell ()

@property (weak, nonatomic) IBOutlet UILabel *videoCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation CBAttentionLiveCell

- (void)setUser:(ALinUser *)user {
    
    _user = user;
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    [self.coverView roundedCornerWithBorderColror:[UIColor mainColor] borderWidth:1];
    self.userNameLabel.text = user.nickname;
}

@end
