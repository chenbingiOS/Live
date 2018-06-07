//
//  CBVideoVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBVideoVC.h"
#import "CBTitleSelectView.h"
#import "CBAppLiveVC.h"
#import "CBVideoHotVC.h"
#import "CBVideoAttentionVC.h"

@interface CBVideoVC() <UIScrollViewDelegate, CBTitleSelectViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;          ///< UIScrollView
@property(nonatomic, strong) CBTitleSelectView *selectedView;   ///< 顶部选择视图
@property(nonatomic, strong) CBVideoHotVC *videoHotVC;          ///< 推荐
@property(nonatomic, strong) CBVideoAttentionVC *videoAttentionVC;  ///< 最新


@end

@implementation CBVideoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup_UI];
}

- (void)setup_UI {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.selectedView];
    [self setup_childVC];
}

- (void)setup_childVC {
    [self addChildViewController:self.videoHotVC];
    [self.scrollView addSubview:self.videoHotVC.view];
    
    [self addChildViewController:self.videoAttentionVC];
    [self.scrollView addSubview:self.videoAttentionVC.view];
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
- (CBTitleSelectView *)selectedView {
    if (!_selectedView) {
        _selectedView = [CBTitleSelectView viewFromXib];
        CGFloat height = SafeAreaTopHeight;
        _selectedView.frame = CGRectMake(0, 0, kScreenWidth, height);
        _selectedView.delegate = self;
    }
    return _selectedView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat height = kScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 49;
        CGRect frame = CGRectMake(0, SafeAreaTopHeight, kScreenWidth, height);
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}


- (CBVideoHotVC *)videoHotVC {
    if (!_videoHotVC) {
        _videoHotVC = [CBVideoHotVC new];
        CGFloat height = kScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 49;
        _videoHotVC.view.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    return _videoHotVC;
}

- (CBVideoAttentionVC *)videoAttentionVC {
    if (!_videoAttentionVC) {
        _videoAttentionVC = [CBVideoAttentionVC new];
        CGFloat height = kScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 49;
        _videoAttentionVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, height);
    }
    return _videoAttentionVC;
}

@end
