//
//  UIView+CornerRadius.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/11.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)

- (UIView *)cornerRadiusViewWithAllRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithTopRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithBottomRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithLeftRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithRightRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithRadius:(CGFloat)radius
                            andTopLeft:(BOOL)topLeft
                           andTopRight:(BOOL)topRight
                         andBottomLeft:(BOOL)bottomLeft
                        andBottomRight:(BOOL)bottomRight;

@end
