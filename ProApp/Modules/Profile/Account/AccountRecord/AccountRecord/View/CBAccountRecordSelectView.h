//
//  CBAccountRecordSelectView.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/27.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBAccountRecordSelectView;
@protocol CBAccountRecordSelectViewDelegate <NSObject>

- (void)accountRecordSelectView:(CBAccountRecordSelectView *)view selectIndex:(NSInteger)index;

@end

@interface CBAccountRecordSelectView : UIView

@property (nonatomic, weak) id <CBAccountRecordSelectViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setSelectIndex:(NSInteger)index;

@end
