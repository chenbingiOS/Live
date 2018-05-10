//
//  UIView+DashedLine.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DashedLine)

- (void)dashedLine;

- (void)dashedLineWithCornerRadius:(CGFloat)cornerRadius;

- (void)dashedLineWithBorderColor:(UIColor *)borderColor;

- (void)dashedLineWithCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor;

- (void)dashedLineWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (void)dashedLineWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth dashPattern:(NSUInteger)dashPattern spacePattern:(NSUInteger)spacePattern borderColor:(UIColor *)borderColor;

@end
