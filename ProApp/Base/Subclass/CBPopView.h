//
//  CBPopView.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PopTypeNormal = 0, /**< 动画弹出类型:Normal */
    PopTypeScale = 1,  /**< 动画弹出类型:Scale */
    PopTypeMove = 2,   /**< 动画弹出类型:Move */
} PopType;

// 仅针对 动画弹出类型:Move
typedef enum : NSUInteger {
    MoveAppearDirectionFromTop = 0,
    MoveAppearDirectionFromLeft = 1,
    MoveAppearDirectionFromBottom= 2,
    MoveAppearDirectionFromRight = 3,
} MoveAppearDirection;

typedef enum : NSUInteger {
    MoveDisappearDirectionToTop = 0,
    MoveDisappearDirectionToLeft = 1,
    MoveDisappearDirectionToBottom = 2,
    MoveDisappearDirectionToRight = 3,
} MoveDisappearDirection;

@interface CBPopView : UIView

@property (assign, nonatomic) PopType  popType;         //动画弹出类型
@property (assign, nonatomic) CGFloat  animateDuration; //动画时间
@property (strong, nonatomic) UIColor *shadowColor;     //阴影颜色
@property (assign, nonatomic) CGFloat  shadowAlpha;     //阴影透明度
@property (assign, nonatomic) CGFloat  radius;          //圆角弧度

// 仅针对 动画弹出类型:Move
@property (assign, nonatomic) MoveAppearDirection       moveAppearDirection;
@property (assign, nonatomic) MoveDisappearDirection    moveDisappearDirection;
@property (assign, nonatomic) CGFloat                   moveAppearCenterX;
@property (assign, nonatomic) CGFloat                   moveAppearCenterY;

/**
 *  在父视图显示
 */
- (void)showIn:(UIView *)superView;

/**
 *  隐藏
 */
- (void)hide;

@end
