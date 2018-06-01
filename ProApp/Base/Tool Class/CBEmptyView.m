//
//  CBEmptyView.m
//  ProApp
//
//  Created by hxbjt on 2018/6/1.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBEmptyView.h"

@implementation CBEmptyView

+ (instancetype)diyEmptyView{
    
    return [CBEmptyView emptyViewWithImageStr:@"noNetwork"
                                       titleStr:@"暂无数据"
                                      detailStr:@"请稍后再试!"];
}

+ (instancetype)diyEmptyActionViewWithTarget:(id)target action:(SEL)action {
    
    return [CBEmptyView emptyActionViewWithImageStr:@"noData"
                                             titleStr:@"暂无数据"
                                            detailStr:@"请检查网络或重新加载!"
                                          btnTitleStr:@"重新加载"
                                               target:target
                                               action:action];
}

- (void)prepare{
    [super prepare];
    
    self.autoShowEmptyView = NO;
    
    self.titleLabTextColor =  [UIColor colorWithRed:180/255.0 green:30/255.0 blue:50/255.0 alpha:1];
    self.titleLabFont = [UIFont systemFontOfSize:18];
    
    self.detailLabTextColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
}


@end
