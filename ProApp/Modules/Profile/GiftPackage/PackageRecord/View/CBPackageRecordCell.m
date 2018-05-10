//
//  CBPackageRecordCell.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/27.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPackageRecordCell.h"
#import "CBPackageRecordVO.h"

@implementation CBPackageRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(CBPackageRecordVO *)data {
    self.titleLabel.text = data.title;
    self.timeLabel.text = data.time;
    self.moneyLabel.text = data.money;
    
}

@end
