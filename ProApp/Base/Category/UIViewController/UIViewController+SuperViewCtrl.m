//
//  UIViewController+SuperViewCtrl.m
//  ProApp
//
//  Created by hxbjt on 2018/6/25.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "UIViewController+SuperViewCtrl.h"

@implementation UIViewController (SuperViewCtrl)

+ (UIViewController *)superViewController:(UIViewController *)vc
{
    for (UIView* next = [vc.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (UIViewController *)getSuperViewController:(NSString *)controllerName target:(nullable id)target{
    
    for (UIView* next = [target superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[controllerName class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
