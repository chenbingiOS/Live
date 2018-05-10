//
//  CBHomeVC.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "CBHomeVC.h"
#import "CBSelectedView.h"
#import "CBAppLiveVC.h"
#import "CBHotVC.h"
#import "ALinNewStarViewController.h"

@interface CBHomeVC() <UIScrollViewDelegate, CBSelectedViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;      /** UIScrollView */
@property(nonatomic, strong) CBSelectedView *selectedView;  /** 顶部选择视图 */
@property(nonatomic, strong) CBAppLiveVC *appLiveVC;        /** 直播 */
@property(nonatomic, strong) CBHotVC *hotVC;                /** 热门 */


@end

@implementation CBHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup_UI];
}

- (void)setup_UI {
    [self.view addSubview:self.scrollView];
    [self.navigationController.navigationBar addSubview:self.selectedView];
    [self setup_childVC];
}

- (void)setup_childVC {
    [self addChildViewController:self.appLiveVC];
    [self.scrollView addSubview:self.appLiveVC.view];
    
    [self addChildViewController:self.hotVC];
    [self.scrollView addSubview:self.hotVC.view];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x / kScreenWidth;
    [self.selectedView setSelectIndex:(NSInteger)(page+0.5)];
}

#pragma mark - CBSelectedViewDelegate
- (void)titleSelectView:(CBSelectedView *)view selectIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:YES];
}

#pragma mark - layz
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (CBSelectedView *)selectedView {
    if (!_selectedView) {
        CGRect frame = self.navigationController.navigationBar.bounds;
        frame.origin.x = 45;
        frame.size.width = kScreenWidth - 45*2;
        _selectedView = [CBSelectedView viewFromXib];
        _selectedView.frame = frame;
        _selectedView.delegate = self;
    }
    return _selectedView;
}

- (CBAppLiveVC *)appLiveVC {
    if (!_appLiveVC) {
        _appLiveVC = [CBAppLiveVC new];
        _appLiveVC.view.frame = [UIScreen mainScreen].bounds;
        _appLiveVC.view.height = kScreenHeight - 49;
    }
    return _appLiveVC;
}

- (CBHotVC *)hotVC {
    if (!_hotVC) {
        _hotVC = [CBHotVC new];
        _hotVC.view.frame = [UIScreen mainScreen].bounds;
        _hotVC.view.height = kScreenHeight - 49;
        _hotVC.view.left = kScreenWidth;
    }
    return _hotVC;
}

@end
