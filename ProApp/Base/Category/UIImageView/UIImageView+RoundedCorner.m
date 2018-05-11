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
    [self roundedCornerWithBorderColror:nil borderWidth:0 cornerRadius:self.frame.size.height/2];
}

- (void)roundedCornerByDefault {
    [self roundedCornerWithBorderColror:[UIColor whiteColor] borderWidth:1 cornerRadius:self.frame.size.height/2];
}

- (void)roundedCornerRadius:(CGFloat)radius {
    [self roundedCornerWithBorderColror:nil borderWidth:0 cornerRadius:radius];
}

- (void)roundedCornerWithBorderColror:(UIColor *)borderColor borderWidth:(CGFloat)broderWidth {
    [self roundedCornerWithBorderColror:borderColor borderWidth:broderWidth cornerRadius:self.frame.size.height/2];
}

- (void)roundedCornerWithBorderColror:(UIColor *)borderColor borderWidth:(CGFloat)broderWidth cornerRadius:(CGFloat)radius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = broderWidth;
}

@end
