//
//  AppDelegate.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, EMClientDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIViewController *rootVC;

@end

