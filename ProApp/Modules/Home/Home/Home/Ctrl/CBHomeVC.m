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

@interface CBHomeVC() <UIScrollViewDelegate, CBSelectedViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;      /** UIScrollView */
@property(nonatomic, strong) CBSelectedView *selectedView;  /** 顶部选择视图 */
@property(nonatomic, strong) CBAppLiveVC *appLiveVC;        /** 直播 */
@property(nonatomic, strong) CBHotVC *hotVC;                /** 热门 */


@end

@implementation CBHomeVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup_UI];
}

- (void)setup_UI {
    [self.view addSubview:self.selectedView];
    [self.view addSubview:self.scrollView];    
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
- (CBSelectedView *)selectedView {
    if (!_selectedView) {
        _selectedView = [CBSelectedView viewFromXib];
        if (iPhoneX) {
            _selectedView.frame = CGRectMake(0, 0, kScreenWidth, 108+20);
        } else {
            _selectedView.frame = CGRectMake(0, 0, kScreenWidth, 108);
        }
        _selectedView.delegate = self;
    }
    return _selectedView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGRect frame = CGRectMake(0, 108, kScreenWidth, kScreenHeight-49-108);
        if (iPhoneX) {
            frame = CGRectMake(0, 108+20, kScreenWidth, kScreenHeight-49-108-20-34);
        }
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

- (CBAppLiveVC *)appLiveVC {
    if (!_appLiveVC) {
        _appLiveVC = [CBAppLiveVC new];
        if (iPhoneX) {
            _appLiveVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-108-20-34);
        } else {
            _appLiveVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-108);
        }
    }
    return _appLiveVC;
}

- (CBHotVC *)hotVC {
    if (!_hotVC) {
        _hotVC = [CBHotVC new];
        if (iPhoneX) {
            _hotVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-49-108-20-34);
        } else {
            _hotVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-49-108);
        }
    }
    return _hotVC;
}

@end
