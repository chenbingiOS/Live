//
//  CBAppADCell.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/21.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAppADCell.h"
#import "CBAppADVO.h"
#import <UIImageView+CornerRadius.h>

@implementation CBAppADCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imageView zy_cornerRadiusAdvance:8.0f rectCornerType:UIRectCornerAllCorners];
}

- (void)setAppAdVO:(CBAppADVO *)appAdVO {
    _appAdVO = appAdVO;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:appAdVO.pic] placeholderImage:[UIImage imageNamed:@"placeHolder_ad_414x100"]];
}

@end
