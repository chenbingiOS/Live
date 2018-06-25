//
//  UIViewController+SuperViewCtrl.h
//  ProApp
//
//  Created by hxbjt on 2018/6/25.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SuperViewCtrl)

+ (UIViewController *_Nonnull)superViewController:(UIViewController *_Nullable)vc;

+ (UIViewController *_Nullable)getSuperViewController:(NSString *_Nullable)controllerName target:(nullable id)target;

@end
