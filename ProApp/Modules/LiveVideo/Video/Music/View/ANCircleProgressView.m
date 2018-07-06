//
//  ANCircleProgressView.m
//  ProApp
//
//  Created by 林景安 on 2018/7/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "ANCircleProgressView.h"
#import "SDPieLoopProgressView.h"

#define Margin 10

@interface ANCircleProgressView ()

@property(nonatomic,weak)SDPieLoopProgressView *pregressView;
@end



@implementation ANCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self subViewInit];
    }
    return self;
}



- (void)subViewInit {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = SDColorMaker(208, 208,208, 0.9);
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-60);
        make.size.mas_offset(CGSizeMake(120, 140));
    }];
    backView.layer.cornerRadius = 5;
    backView.clipsToBounds=YES;
    
    SDPieLoopProgressView *pregressView = [[SDPieLoopProgressView alloc] init];
    [backView addSubview:pregressView];
    [pregressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(Margin);
        make.right.mas_offset(-Margin);
        make.height.mas_offset(100);
    }];
    self.pregressView = pregressView;
    
    UILabel *text = [[UILabel alloc] init];
    text.font = [UIFont systemFontOfSize:16];
    text.textColor = [UIColor lightGrayColor];
    text.text=@"下载中";
    text.textAlignment = NSTextAlignmentCenter;
    text.backgroundColor = [UIColor clearColor];
    [backView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(pregressView.mas_bottom);
    }];
}

-(void)setProgress:(CGFloat)progress{
    
    self.pregressView.progress = progress;
    if (progress>=1) {
        [self removeFromSuperview];
    }
}
@end
