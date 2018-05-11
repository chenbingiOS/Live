//
//  UIImageView+RoundedCorner.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/26.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RoundedCorner)

- (void)roundedCorner;
- (void)roundedCornerByDefault;
- (void)roundedCornerRadius:(CGFloat)radius;
- (void)roundedCornerWithBorderColror:(UIColor *)borderColor borderWidth:(CGFloat)broderWidth;
- (void)roundedCornerWithBorderColror:(UIColor *)borderColor borderWidth:(CGFloat)broderWidth cornerRadius:(CGFloat)radius;

@end
