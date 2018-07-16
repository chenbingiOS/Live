//
//  CBPersonalHomePageContriButionCell.m
//  ProApp
//
//  Created by hxbjt on 2018/7/16.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPersonalHomePageContriButionCell.h"
#import "CBAnchorInfoVO.h"

@implementation CBPersonalHomePageContriButionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfoVO:(CBAnchorInfoVO *)infoVO {
    _infoVO = infoVO;

    NSArray *AImgAry = @[self.AImageView, self.BImageView, self.CImageView];
    NSArray *BImgAry = @[self.AAImageView, self.BBImageView, self.CCImageView];
    for (NSUInteger i = 0; i < infoVO.guard.count; i++) {
        CBLiveUser *liveUser = infoVO.guard[i];
        UIImageView *imgView = AImgAry[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar]];
    }
    for (NSUInteger j = 0; j < infoVO.tag.count; j++) {
        CBLiveUser *liveUser = infoVO.tag[j];
        UIImageView *imgView = BImgAry[j];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:liveUser.avatar]];
    }
}

@end
