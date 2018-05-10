//
//  CBPlayerScrollView.h
//  inke
//
//  Created by Sam on 2/7/17.
//  Copyright © 2017 Zhejiang University of Tech. All rights reserved.
//


// 上下滑动切换直播控件

#import <UIKit/UIKit.h>

@class CBPlayerScrollView;
@protocol CBPlayerScrollViewDelegate <NSObject>

- (void)playerScrollView:(CBPlayerScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index;

@end

@interface CBPlayerScrollView : UIScrollView

@property (nonatomic, weak) id<CBPlayerScrollViewDelegate> playerDelegate;
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger) index;

@end

