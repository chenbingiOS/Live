//
//  CBMyVideoCell.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "CBMyVideoCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+CornerRadius.h"
#import "CBShortVideoVO.h"
#import "UIImageView+CornerRadius.h"

@interface CBMyVideoCell()

@property (weak, nonatomic) IBOutlet UILabel *videoCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLab;
@property (weak, nonatomic) IBOutlet UILabel *likesLab;

@end

@implementation CBMyVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.coverView zy_cornerRadiusAdvance:8 rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
    self.coverView.layer.masksToBounds = YES;
}

- (void)setVideo:(CBShortVideoVO *)video {
    _video = video;    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:video.thumb] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.videoTitleLabel.text = video.title;
    self.viewsLab.text = video.views;
    self.likesLab.text = video.likes;
}

@end
