//
//  UIView+CornerRadius.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/11.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (UIView *)cornerRadiusViewWithAllRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:YES andTopRight:YES andBottomLeft:YES andBottomRight:YES];
}

- (UIView *)cornerRadiusViewWithTopRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:YES andTopRight:YES andBottomLeft:NO andBottomRight:NO];
}

- (UIView *)cornerRadiusViewWithBottomRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:NO andTopRight:NO andBottomLeft:YES andBottomRight:YES];
}

- (UIView *)cornerRadiusViewWithLeftRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:YES andTopRight:NO andBottomLeft:YES andBottomRight:NO];
}

- (UIView *)cornerRadiusViewWithRightRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:NO andTopRight:YES andBottomLeft:NO andBottomRight:YES];
}

- (UIView *)cornerRadiusViewWithRadius:(CGFloat)radius
                            andTopLeft:(BOOL)topLeft
                           andTopRight:(BOOL)topRight
                         andBottomLeft:(BOOL)bottomLeft
                        andBottomRight:(BOOL)bottomRight {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:
                              (
                               (topLeft == YES ? UIRectCornerTopLeft : 0) |
                               (topRight == YES ? UIRectCornerTopRight : 0) |
                               (bottomLeft == YES ? UIRectCornerBottomLeft : 0) |
                               (bottomRight == YES ? UIRectCornerBottomRight : 0)
                               )
                                                         cornerRadii:CGSizeMake(radius, radius)];
    // 创建遮罩层
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;   // 轨迹
    self.layer.mask = maskLayer;
    
    return self;
}

@end
