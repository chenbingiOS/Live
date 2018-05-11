//
//  CBAttentionCell.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "CBAttentionCell.h"
#import "ALinUser.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+RoundedCorner.h"

@interface CBAttentionCell()

@property (weak, nonatomic) IBOutlet UILabel *videoCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation CBAttentionCell

- (void)setUser:(ALinUser *)user {
    
    _user = user;
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    [self.coverView roundedCornerRadius:8];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    [self.avaterImageView roundedCorner];
    self.userNameLabel.text = user.nickname;    
}

@end
