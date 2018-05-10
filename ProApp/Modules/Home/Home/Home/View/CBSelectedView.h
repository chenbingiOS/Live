//
//  CBSelectedView.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBSelectedView;
@protocol CBSelectedViewDelegate <NSObject>

- (void)titleSelectView:(CBSelectedView *)view selectIndex:(NSInteger)index;

@end

@interface CBSelectedView : UIView

@property (nonatomic, weak) id <CBSelectedViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setSelectIndex:(NSInteger)index;

@end
