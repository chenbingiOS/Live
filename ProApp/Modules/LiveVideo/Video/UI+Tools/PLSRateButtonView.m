//
//  PLSRateButtonView.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/8/21.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSRateButtonView.h"

#define KINDICATORHEIGHT 2.f
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define COLOR_RGB(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]
#define BUTTON_BACKGROUNDCOLOR COLOR_RGB(30, 30, 30, 0.8)

@interface PLSRateButtonView ()

@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, assign) CGFloat totalWidth;

@end

@implementation PLSRateButtonView

- (NSMutableArray *)totalTitleArray {
    if (_totalLabelArray == nil) {
        _totalLabelArray = [NSMutableArray array];
    }
    return _totalLabelArray;
}

- (instancetype)initWithFrame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRGB:0x444444 alpha:0.4];
        self.layer.cornerRadius = frame.size.height/2;
        self.totalWidth = frame.size.width;
        self.index = defaultIndex;
    }
    return self;
}

- (void)setStaticTitleArray:(NSArray *)staticTitleArray {
    _staticTitleArray = staticTitleArray;
    
    
    CGFloat scrollViewWith = _totalWidth;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelWidth = (scrollViewWith-0)/staticTitleArray.count;
    CGFloat labelHeight = self.frame.size.height - KINDICATORHEIGHT;
    
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 28)];
    [self addSubview:self.indicatorView];

    
    self.totalLabelArray = [NSMutableArray array];
    for (int i = 0; i < staticTitleArray.count; i++) {
        UILabel *staticLabel = [[UILabel alloc] init];
        staticLabel.userInteractionEnabled = YES;
        staticLabel.textAlignment = NSTextAlignmentCenter;
        staticLabel.text = staticTitleArray[i];
        staticLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];

        staticLabel.tag = i+1;
        staticLabel.textColor = [UIColor whiteColor];
        
        staticLabel.highlightedTextColor = [UIColor shortVideoSelectBtnColor];
        labelX = i * labelWidth;
        staticLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        [self.totalLabelArray addObject:staticLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(staticLabelClick:)];
        [staticLabel addGestureRecognizer:tap];
        
        if (i == self.index) {
            staticLabel.highlighted = YES;
            staticLabel.textColor = [UIColor shortVideoSelectBtnColor];
            staticLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
            _selectedLabel = staticLabel;
        }
        [self addSubview:staticLabel];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shortVideo_btn_bg"]];
    imageView.frame = CGRectMake(0, 0, labelWidth, 28);
    [self.indicatorView addSubview:imageView];
    self.indicatorView.centerX = self.totalLabelArray[2].centerX;
}

- (void)staticLabelClick:(UITapGestureRecognizer *)tap {
    UILabel *titleLabel = (UILabel *)tap.view;
    [self staticLabelSelectedColor:titleLabel];
    
    NSInteger index = titleLabel.tag - 1;
    if (self.rateDelegate != nil && [self.rateDelegate respondsToSelector:@selector(rateButtonView:didSelectedTitleIndex:)]) {
        [self.rateDelegate rateButtonView:self didSelectedTitleIndex:index];
        for (UILabel *titleLab in self.totalLabelArray) {
            if (titleLab.tag == index + 1) {
                [self staticLabelSelectedColor:titleLab];
            }
        }
    }
}

- (void)staticLabelSelectedColor:(UILabel *)titleLabel {
    _selectedLabel.highlighted = NO;
    _selectedLabel.textColor = [UIColor whiteColor];
    _selectedLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    
    titleLabel.highlighted = YES;
    titleLabel.textColor = [UIColor shortVideoSelectBtnColor];
    titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];

    _selectedLabel = titleLabel;
    @weakify(self);
    [UIView animateWithDuration:0.20 animations:^{
        @strongify(self);
        CGFloat XSpace = 0;
        XSpace = self.space + self.totalWidth/self.staticTitleArray.count * (titleLabel.tag - 1);
        self.indicatorView.center = CGPointMake(titleLabel.centerX, self.indicatorView.centerY);
    }];
}

@end
