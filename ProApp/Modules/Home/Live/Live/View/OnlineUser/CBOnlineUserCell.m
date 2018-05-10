//
//  CBOnlineUserCell.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBOnlineUserCell.h"
#import "ALinUser.h"

@implementation CBOnlineUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avaterImageView.layer.masksToBounds = YES;
    self.avaterImageView.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(ALinUser *)data {
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:data.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.nameLabel.text = data.nickname;
}

@end
