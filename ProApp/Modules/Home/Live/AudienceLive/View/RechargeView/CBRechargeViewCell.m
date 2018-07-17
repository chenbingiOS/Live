//
//  CBRechargeViewCell.m
//  ProApp
//
//  Created by hxbjt on 2018/7/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBRechargeViewCell.h"
#import "CBRechargeVO.h"

@implementation CBRechargeViewCell

- (void)setRechargeVO:(CBRechargeVO *)rechargeVO {
    _rechargeVO = rechargeVO;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 6;
    self.titleLab.text = [rechargeVO.diamond_num stringByAppendingString:@"钻石"];
    self.moneyLab.text = [@"¥" stringByAppendingString:rechargeVO.money_num];
    [self layoutIfNeeded];

    if (rechargeVO.select) {
        self.bgView.layer.borderColor = [UIColor mainColor].CGColor;
        self.titleLab.textColor = [UIColor mainColor];
        self.moneyLab.textColor = [UIColor mainColor];
    } else {
        self.bgView.layer.borderColor = [UIColor grayColor].CGColor;
        self.titleLab.textColor = [UIColor titleNormalColor];
        self.moneyLab.textColor = [UIColor btnSelectColor];
    }
}

@end
