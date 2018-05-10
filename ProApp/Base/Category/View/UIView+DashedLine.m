//
//  UIView+DashedLine.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "UIView+DashedLine.h"

@implementation UIView (DashedLine)


- (void)dashedLine {
    [self dashedLineWithCornerRadius:6 borderWidth:1 dashPattern:0 spacePattern:0 borderColor:[UIColor lightGrayColor]];
}

- (void)dashedLineWithCornerRadius:(CGFloat)cornerRadius {
    [self dashedLineWithCornerRadius:cornerRadius borderWidth:1 dashPattern:0 spacePattern:0 borderColor:[UIColor lightGrayColor]];
}

- (void)dashedLineWithBorderColor:(UIColor *)borderColor {
    [self dashedLineWithCornerRadius:6 borderWidth:1 dashPattern:1 spacePattern:0 borderColor:borderColor];
}

- (void)dashedLineWithCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor {
    [self dashedLineWithCornerRadius:cornerRadius borderWidth:1 dashPattern:0 spacePattern:0 borderColor:borderColor];
}

- (void)dashedLineWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    [self dashedLineWithCornerRadius:cornerRadius borderWidth:borderWidth dashPattern:0 spacePattern:0 borderColor:borderColor];
}

- (void)dashedLineWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth dashPattern:(NSUInteger)dashPattern spacePattern:(NSUInteger)spacePattern borderColor:(UIColor *)borderColor {
    
    UIColor *lineColor = borderColor ? borderColor : [UIColor blackColor];
    
    // draw frame
    CGRect frame = self.bounds;
    // creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    // drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path;
    CGPathRelease(path);
    
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    shapeLayer.frame = frame;
    shapeLayer.masksToBounds = NO;
    [shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.strokeColor = [lineColor CGColor];
    shapeLayer.lineWidth = borderWidth;
    if (dashPattern == 0 && spacePattern == 9) {
        shapeLayer.lineDashPattern = nil;
    } else {
        shapeLayer.lineDashPattern = [NSArray arrayWithObjects:@(dashPattern), @(spacePattern), nil];
    }
    shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [self.layer addSublayer:shapeLayer];
    self.layer.cornerRadius = cornerRadius;
}

@end
