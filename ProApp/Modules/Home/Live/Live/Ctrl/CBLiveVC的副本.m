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

@interface CBLiveVC () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>
@property (nonatomic, assign) BOOL isDecelerate; ///< 是否处于滚动
@end

@implementation CBLiveVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate   = self;
    self.dataSource = self;

    for (UIView *subView in self.view.subviews ) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView*)subView;
//            scrollView.delegate = self;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.isDecelerate = YES;
    NSLog(@"滚动中");
}

#pragma mark - 延迟加载关键
//tableView停止拖拽，停止滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //如果tableview停止滚动，开始加载图像
    if (!decelerate) {
//        self.isDecelerate = NO;
//        [self loadImagesForOnscreenRows];
        NSLog(@"滚动结束----");
    }
    NSLog(@"%s__%d__|%d",__FUNCTION__,__LINE__,decelerate);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    self.isDecelerate = NO;
    
//    CBLivePlayerVC *livePlayerVC = self.viewControllers[self.currentIndex];
//    livePlayerVC.liveVO = self.lives[self.currentIndex];
    
    NSLog(@"滚动结束");
    NSLog(@"%s__%d__",__FUNCTION__,__LINE__);
    //如果tableview停止滚动，开始加载图像
//    [self loadImagesForOnscreenRows];
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSLog(@"%s__%d__",__FUNCTION__,__LINE__);
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
    NSLog(@"%s__%d__",__FUNCTION__,__LINE__);
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

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    NSLog(@"%@", [pendingViewControllers description]);
    NSLog(@"%s__%d__",__FUNCTION__,__LINE__);
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSLog(@"%@", [previousViewControllers description]);
    NSLog(@"%s__%d__",__FUNCTION__,__LINE__);
}

@end
