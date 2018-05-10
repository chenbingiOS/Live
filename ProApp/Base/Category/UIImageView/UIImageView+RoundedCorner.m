//
//  UIImageView+RoundedCorner.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/26.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "UIImageView+RoundedCorner.h"

@implementation UIImageView (RoundedCorner)

- (void)roundedCorner {
    [self roundedCornerWithBorderColror:nil borderWidth:0];
}

- (void)roundedCornerByDefault {
    [self roundedCornerWithBorderColror:[UIColor whiteColor] borderWidth:1];
}

- (void)roundedCornerWithBorderColror:(UIColor *)borderColor borderWidth:(CGFloat)broderWidth {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.size.height/2.0;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = broderWidth;
}

@end
