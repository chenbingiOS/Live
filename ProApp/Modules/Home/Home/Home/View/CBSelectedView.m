//
//  CBSelectedView.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBSelectedView.h"

@interface CBSelectedView ()
@property (nonatomic, assign) NSInteger tempIndex;
@property (nonatomic, copy) NSArray *btnAry;
@end

@implementation CBSelectedView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnAry = @[self.btnA, self.btnB];
}

- (IBAction)actionBtnClick:(UIButton *)sender {
    self.btnA.selected = NO;
    self.btnB.selected = NO;
    sender.selected = YES;
    
    [UIView animateWithDuration:0.35 animations:^{
        self.lineView.centerX = sender.centerX;
    }];
    
    if ([self.delegate respondsToSelector:@selector(titleSelectView:selectIndex:)]) {
        [self.delegate titleSelectView:self selectIndex:sender.tag];
    }
}

- (void)setSelectIndex:(NSInteger)index {
    if (self.tempIndex != index) {
        self.btnA.selected = NO;
        self.btnB.selected = NO;
        UIButton *btn = self.btnAry[index];
        btn.selected = YES;
        [UIView animateWithDuration:0.35 animations:^{
            self.lineView.centerX = btn.centerX;
        }];
    }
    self.tempIndex = index;
}

@end
