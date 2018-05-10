//
//  CBVideoVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBVideoVC.h"
#import "CBTitleSelectView.h"

#import "CBSelectedView.h"
#import "CBAppLiveVC.h"
#import "CBHotVC.h"
#import "ALinNewStarViewController.h"

#import "CBRecommendVC.h"
#import "CBNewestVC.h"
#import "CBNearbyVC.h"

@interface CBVideoVC() <UIScrollViewDelegate, CBTitleSelectViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;      /** UIScrollView */
@property(nonatomic, strong) CBTitleSelectView *selectedView;  /** 顶部选择视图 */
@property(nonatomic, strong) CBRecommendVC *recommendVC;    ///< 推荐
@property(nonatomic, strong) CBNewestVC *newestVC;          ///< 最新
@property(nonatomic, strong) CBNearbyVC *nearbyVC;          ///< 附近


@end

@implementation CBVideoVC

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
    [self addChildViewController:self.recommendVC];
    [self.scrollView addSubview:self.recommendVC.view];
    
    [self addChildViewController:self.newestVC];
    [self.scrollView addSubview:self.newestVC.view];
    
    [self addChildViewController:self.nearbyVC];
    [self.scrollView addSubview:self.nearbyVC.view];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x / kScreenWidth;
    [self.selectedView setSelectIndex:(NSInteger)(page+0.5)];
}

#pragma mark - CBTitleSelectViewDelegate
- (void)titleSelectView:(CBTitleSelectView *)view selectIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:YES];
}

#pragma mark - layz
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (CBTitleSelectView *)selectedView {
    if (!_selectedView) {
        CGRect frame = self.navigationController.navigationBar.bounds;
        frame.origin.x = 45;
        frame.size.width = kScreenWidth - 45*2;
        _selectedView = [CBTitleSelectView viewFromXib];
        _selectedView.frame = frame;
        _selectedView.delegate = self;
    }
    return _selectedView;
}

- (CBRecommendVC *)recommendVC {
    if (!_recommendVC) {
        _recommendVC = [CBRecommendVC new];
        _recommendVC.view.frame = [UIScreen mainScreen].bounds;
        _recommendVC.view.height = kScreenHeight - 49;
    }
    return _recommendVC;
}

- (CBNewestVC *)newestVC {
    if (!_newestVC) {
        _newestVC = [CBNewestVC new];
        _newestVC.view.frame = [UIScreen mainScreen].bounds;
        _newestVC.view.height = kScreenHeight - 49;
        _newestVC.view.left = kScreenWidth;
    }
    return _newestVC;
}

- (CBNearbyVC *)nearbyVC {
    if (!_nearbyVC) {
        _nearbyVC = [CBNearbyVC new];
        _nearbyVC.view.frame = [UIScreen mainScreen].bounds;
        _nearbyVC.view.height = kScreenHeight - 49;
        _nearbyVC.view.left = kScreenWidth * 2;
    }
    return _nearbyVC;
}



@end
