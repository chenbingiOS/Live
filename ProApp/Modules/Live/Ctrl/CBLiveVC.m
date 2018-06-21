//
//  CBLiveVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveVC.h"
#import "CBAppLiveVO.h"
#import "CBLivePlayerVC.h"

@interface CBLiveVC () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation CBLiveVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self.view addSubview:self.closeButton];
//    [self.view insertSubview:self.closeButton atIndex:999];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate   = self;
    self.dataSource = self;

    for (UIView *subView in self.view.subviews ) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)subView;
            scrollView.delaysContentTouches = NO; // 默认值为YES；如果设置为NO，则无论手指移动的多么快，始终都会将触摸事件传递给内部控件；设置为NO可能会影响到UIScrollView的滚动功能。
        }
    }
    
    [self reloadCtrl];
}

- (void)reloadCtrl {
    if (self.lives.count) {
        CBLivePlayerVC *livePlayerVC = [[CBLivePlayerVC alloc] init];
        if (self.currentIndex < self.lives.count) {
            livePlayerVC.liveVO = self.lives[self.currentIndex];
        } else {
            livePlayerVC.liveVO = self.lives.firstObject;
            self.currentIndex = 0;
        }
        [self setViewControllers:@[livePlayerVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:^(BOOL finished) {
        }];
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    if (![viewController isKindOfClass:[CBLivePlayerVC class]]) return nil;
    
    NSInteger index = [self.lives indexOfObject:[(CBLivePlayerVC*)viewController liveVO]];
    if (NSNotFound == index) return nil;
    
    index --;
    if (index < 0) return nil;
    
    CBLivePlayerVC *livePlayerVC = [[CBLivePlayerVC alloc] init];
    livePlayerVC.liveVO = self.lives[index];
    self.currentIndex = index;
    
    return livePlayerVC;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    if (![viewController isKindOfClass:[CBLivePlayerVC class]]) return nil;
    
    NSInteger index = [self.lives indexOfObject:[(CBLivePlayerVC*)viewController liveVO]];
    if (NSNotFound == index) return nil;
    
    index ++;
    
    if (self.lives.count > index) {
        CBLivePlayerVC *livePlayerVC = [[CBLivePlayerVC alloc] init];
        livePlayerVC.liveVO = self.lives[index];
        self.currentIndex = index;
        
        return livePlayerVC;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
}

@end
