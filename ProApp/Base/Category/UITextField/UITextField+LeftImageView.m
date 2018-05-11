//
//  UITextField+LeftImageView.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/11.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "UITextField+LeftImageView.h"

@implementation UITextField (LeftImageView)

- (void)leftImageViewImageName:(NSString *)imgName {
    [self leftImageViewWidth:44.0f andImageName:imgName];
}

- (void)leftImageViewWidth:(CGFloat)leftWidth andImageName:(NSString *)imgName{
    CGRect frame = self.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftview;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, leftWidth, frame.size.height)];
    imgV.contentMode = UIViewContentModeCenter;
    imgV.image = [UIImage imageNamed:imgName];
    [leftview addSubview:imgV];
}

@end
