//
//  CBLiveAnchorBeginView.m
//  ProApp
//
//  Created by hxbjt on 2018/6/8.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveAnchorBeginView.h"
#import "UIImageView+CornerRadius.h"
#import "UIView+CornerRadius.h"

@implementation CBLiveAnchorBeginView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.coverImageView zy_cornerRadiusAdvance:8 rectCornerType:UIRectCornerAllCorners];
    self.coverImageView.layer.masksToBounds = YES;
    [self.changeCoverBtn cornerRadiusViewWithBottomRadius:8];
}

@end
