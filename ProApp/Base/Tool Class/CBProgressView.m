//
//  CBProgressView.m
//  CBProgressView
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "CBProgressView.h"

#define KProgressBorderWidth 2.0f
#define KProgressPadding 1.0f
#define KProgressColor [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]

@interface CBProgressView ()

@property (nonatomic, weak) UIView *tView;


@end

@implementation CBProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //边框
        UIView *borderView = [[UIView alloc] initWithFrame:self.bounds];
        borderView.layer.cornerRadius = self.bounds.size.height * 0.5;
        borderView.layer.masksToBounds = YES;
        borderView.backgroundColor = [UIColor whiteColor];
        borderView.layer.borderColor = [UIColor mainColor].CGColor;
        borderView.layer.borderWidth = KProgressBorderWidth;
        [self addSubview:borderView];
        
        //进度
        UIView *tView = [[UIView alloc] init];
        tView.backgroundColor = [UIColor mainColor];;
        tView.layer.cornerRadius = (self.bounds.size.height - (KProgressBorderWidth + KProgressPadding) * 2) * 0.5;
        tView.layer.masksToBounds = YES;
        [self addSubview:tView];
        self.tView = tView;
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    CGFloat margin = KProgressBorderWidth + KProgressPadding;
    CGFloat maxWidth = self.bounds.size.width - margin * 2;
    CGFloat heigth = self.bounds.size.height - margin * 2;
    
    _tView.frame = CGRectMake(margin, margin, maxWidth * progress, heigth);
}


@end
