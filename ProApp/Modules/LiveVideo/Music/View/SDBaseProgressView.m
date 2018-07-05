//
//  SDBaseProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-19.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBaseProgressView.h"

@implementation SDBaseProgressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = SDProgressViewBackgroundColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (progress >= 1.0) {
            [self removeFromSuperview];
        } else {
            [self setNeedsDisplay];
        }
    });
    
}



- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes
{
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = self.frame.size.height * 0.5;
    
    CGSize strSize = [text sizeWithAttributes:attributes];
    CGFloat strX = xCenter - strSize.width * 0.5;
    CGFloat strY = yCenter - strSize.height * 0.5;
    [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
    
}

// 清除指示器
- (void)dismiss
{
    self.progress = 1.0;
}

+ (id)progressView
{
    return [[self alloc] init];
}

@end
