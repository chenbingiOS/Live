//
//  CBShortVideoVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBShortVideoVC.h"
#import "CBShortVideoVO.h"
#import "CBPlayVideoVC.h"

@interface CBShortVideoVC () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation CBShortVideoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view addSubview:self.closeButton];
    [self.view insertSubview:self.closeButton atIndex:999];
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
    if (self.videos.count) {
        CBPlayVideoVC *videoPlayerVC = [[CBPlayVideoVC alloc] init];
        if (self.currentIndex < self.videos.count) {
            videoPlayerVC.video = self.videos[self.currentIndex];
        } else {
            videoPlayerVC.video = self.videos.firstObject;
            self.currentIndex = 0;
        }
        [self setViewControllers:@[videoPlayerVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:^(BOOL finished) {
        }];
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    if (![viewController isKindOfClass:[CBPlayVideoVC class]]) return nil;
    
    NSInteger index = [self.videos indexOfObject:[(CBPlayVideoVC*)viewController video]];
    if (NSNotFound == index) return nil;
    
    index --;
    if (index < 0) return nil;
    
    CBPlayVideoVC *videoPlayerVC = [[CBPlayVideoVC alloc] init];
    videoPlayerVC.video = self.videos[index];
    self.currentIndex = index;
    
    return videoPlayerVC;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    if (![viewController isKindOfClass:[CBPlayVideoVC class]]) return nil;
    
    NSInteger index = [self.videos indexOfObject:[(CBPlayVideoVC*)viewController video]];
    if (NSNotFound == index) return nil;
    
    index ++;
    
    if (self.videos.count > index) {
        CBPlayVideoVC *videoPlayerVC = [[CBPlayVideoVC alloc] init];
        videoPlayerVC.video = self.videos[index];
        self.currentIndex = index;
        
        return videoPlayerVC;
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = kScreenHeight-60;
        if (iPhoneX) y -= 35;
        _closeButton.frame = CGRectMake(kScreenWidth - 60, y, 60, 60);
        [_closeButton setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - Action

- (void)closeAction: (UIButton *) button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
