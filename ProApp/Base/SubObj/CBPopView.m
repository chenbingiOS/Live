//
//  CBPopView.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPopView.h"

@interface CBPopView ()

@property (nonatomic, strong) UIView *shadowView;

@end

@implementation CBPopView

#pragma mark - tool
// 设置参数默认值
- (void)setDefaults {
    //动画时间默认值
    if (!_animateDuration) {
        _animateDuration = 0.2;
    }
    //阴影颜色默认值
    if (!_shadowColor) {
        _shadowColor = [UIColor grayColor];
    }
    //阴影透明度默认值
    if (!_shadowAlpha) {
        _shadowAlpha = 0.5;
    }
    //圆角弧度默认值
    if (!_radius) {
        _radius = 10;
    }
}

#pragma mark - setter
//动画弹出类型
- (void)setPopType:(PopType)popType {
    _popType = popType;
    
    if (_popType == PopTypeScale) {
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
}

// 仅针对 动画弹出类型:Move
- (void)setMoveAppearDirection:(MoveAppearDirection)moveAppearDirection {
    _moveAppearDirection = moveAppearDirection;
    
    switch (_moveAppearDirection) {
        case 0: {
            self.bottom = 0;
        }
            break;
        case 1: {
            self.right = 0;
        }
            break;
        case 2: {
            self.top = [UIScreen mainScreen].bounds.size.height;
        }
            break;
        case 3: {
            self.left = [UIScreen mainScreen].bounds.size.width;
        }
            break;
        default:
            break;
    }
}

//圆角弧度
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    
    self.layer.cornerRadius = _radius;
}

#pragma mark - public
/**
 *  在父视图显示
 */
- (void)showIn:(UIView *)superView
{
    // 1.半透明阴影
    self.shadowView = [[UIView alloc] initWithFrame:superView.bounds];
    self.shadowView.backgroundColor = self.shadowColor;
    self.shadowView.alpha = 0;
    [self.shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PopViewShadowTapped:)]];
    [superView addSubview:self.shadowView];
    
    // 2.添加到父视图上面去
    [superView addSubview:self];
    
    // 3.动画
    @weakify(self);
    [UIView animateWithDuration:_animateDuration animations:^{
        @strongify(self);
        self.shadowView.alpha = self.shadowAlpha;
        self.alpha = 1;
        
        if (self.popType == PopTypeMove)
        {
            if (self.moveAppearCenterX) {
                self.centerX = self.moveAppearCenterX;
            }
            if (self.moveAppearCenterY) {
                self.centerY = self.moveAppearCenterY;
            }
        } else if (self.popType == PopTypeScale) {
            self.transform = CGAffineTransformIdentity;
        }
    }];
}

/**
 *  隐藏
 */
- (void)hide
{
    @weakify(self);
    if (self.popType == PopTypeMove)
    {
        switch (self.moveDisappearDirection) {
            case 0:
            {
                [UIView animateWithDuration:self.animateDuration animations:^{
                    @strongify(self);
                    self.bottom = 0;
                    self.shadowView.alpha = 0;
                } completion:^(BOOL finished) {
                    @strongify(self);
                    self.shadowView.alpha = 0;
                    self.alpha = 0;
                    
                    [self.shadowView removeFromSuperview];
                    self.shadowView = nil;
                    [self removeFromSuperview];
                }];
            }
                break;
            case 1:
            {
                [UIView animateWithDuration:self.animateDuration animations:^{
                    @strongify(self);
                    self.right = 0;
                    self.shadowView.alpha = 0;
                } completion:^(BOOL finished) {
                    @strongify(self);
                    self.shadowView.alpha = 0;
                    self.alpha = 0;
                    
                    [self.shadowView removeFromSuperview];
                    self.shadowView = nil;
                    [self removeFromSuperview];
                }];
            }
                break;
            case 2:
            {
                [UIView animateWithDuration:self.animateDuration animations:^{
                    @strongify(self);
                    self.top = [UIScreen mainScreen].bounds.size.height;
                    self.shadowView.alpha = 0;
                } completion:^(BOOL finished) {
                    @strongify(self);
                    self.shadowView.alpha = 0;
                    self.alpha = 0;
                    
                    [self.shadowView removeFromSuperview];
                    self.shadowView = nil;
                    [self removeFromSuperview];
                }];
            }
                break;
            case 3:
            {
                [UIView animateWithDuration:self.animateDuration animations:^{
                    @strongify(self);
                    self.left = [UIScreen mainScreen].bounds.size.width;
                    self.shadowView.alpha = 0;
                } completion:^(BOOL finished) {
                    @strongify(self);
                    self.shadowView.alpha = 0;
                    self.alpha = 0;
                    
                    [self.shadowView removeFromSuperview];
                    self.shadowView = nil;
                    [self removeFromSuperview];
                }];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        [UIView animateWithDuration:self.animateDuration animations:^{
            @strongify(self);
            self.shadowView.alpha = 0;
            self.alpha = 0;
            
            if (self.popType == PopTypeScale) {
                self.transform = CGAffineTransformMakeScale(0.01, 0.01);
            }
        } completion:^(BOOL finished) {
            @strongify(self);
            [self.shadowView removeFromSuperview];
            self.shadowView = nil;
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置参数默认值
        [self setDefaults];
        
        self.alpha = 0;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.radius;
    }
    
    return self;
}

#pragma mark - target action
- (void)PopViewShadowTapped:(UITapGestureRecognizer *)tap
{
    [self hide];
}

@end
