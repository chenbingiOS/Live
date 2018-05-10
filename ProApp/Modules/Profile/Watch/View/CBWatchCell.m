//
//  CBWatchCell.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBWatchCell.h"
#import "CBWatchVO.h"

@implementation CBWatchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.userAvaterImageView roundedCorner];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(CBWatchVO *)data {
    self.userAvaterImageView.image = [UIImage imageNamed:data.userAvater];
    
    self.titleLabel.text = data.title;
    self.descLabel.text = data.desc;
    NSString *genderImageTitle = [data.gender isEqualToString:@"1"] ? @"female": @"female";
    self.genderImageView.image = [UIImage imageNamed:genderImageTitle];
    if (data.time) {
        self.timeLabel.hidden = NO;
        self.timeLabel.text = data.time;
    }
    
    if ([data.liveing isEqualToString:@"1"]) {
        self.liveView.hidden = NO;
    }
    if ([data.attention isEqualToString:@"1"] || [data.attention isEqualToString:@"2"]) {
        self.attentionBtn.hidden = NO;
        if ([data.attention isEqualToString:@"2"]) {
            [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [self.attentionBtn setBackgroundColor:[UIColor btnSelectColor]];
        }
    }
}

@end
