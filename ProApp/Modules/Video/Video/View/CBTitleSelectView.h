//
//  CBTitleSelectView.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBTitleSelectView;
@protocol CBTitleSelectViewDelegate <NSObject>

- (void)titleSelectView:(CBTitleSelectView *)view selectIndex:(NSInteger)index;

@end

@interface CBTitleSelectView : UIView

@property (nonatomic, weak) id <CBTitleSelectViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnC;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setSelectIndex:(NSInteger)index;

@end
