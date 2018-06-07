//
//  CBAttentionCell.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "CBAttentionCell.h"
#import "UIImageView+CornerRadius.h"
#import "UIView+CornerRadius.h"
#import "CBShortVideoVO.h"

@interface CBAttentionCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLab;
@property (weak, nonatomic) IBOutlet UILabel *likesLab;

@end

@implementation CBAttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.coverView zy_cornerRadiusAdvance:8 rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
    self.coverView.layer.masksToBounds = YES;
    [self.avaterImageView zy_cornerRadiusRoundingRect];
    self.avaterImageView.layer.masksToBounds = YES;
}

- (void)setVideo:(CBShortVideoVO *)video {
    _video = video;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:video.thumb] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.videoTitleLabel.text = video.title;
    self.viewsLab.text = video.views;
    self.likesLab.text = video.likes;
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:video.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.userNameLabel.text = video.user_nicename;
}


@end
