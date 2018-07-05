//
//  ANMusicPlayButton.m
//  ProApp
//
//  Created by 林景安 on 2018/7/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "ANMusicPlayButton.h"

@implementation ANMusicPlayButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self addAnimation];
    }else{
        [self.layer removeAllAnimations];
    }
    
}

/**
 *音乐播放时的动画
 */
- (void)addAnimation{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2];
    rotationAnimation.duration = 3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:rotationAnimation forKey:@"ANrotationAnimation"];
}

@end
