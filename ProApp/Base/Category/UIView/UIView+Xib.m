//
//  UIView+Xib.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "UIView+Xib.h"

@implementation UIView (Xib)

+ (instancetype)viewFromXib {
    
    NSBundle *bundle = [NSBundle mainBundle];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:bundle];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    __block UIView *returnView = nil;
    [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id view = obj;
        if ([view isKindOfClass:self]) {
            *stop = YES;
            returnView = view;
            return ;
        }
    }];
    
    return returnView;
}

@end
