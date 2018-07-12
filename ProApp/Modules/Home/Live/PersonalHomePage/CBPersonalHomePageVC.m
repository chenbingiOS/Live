//
//  CBPersonalHomePageVC.m
//  ProApp
//
//  Created by hxbjt on 2018/7/12.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPersonalHomePageVC.h"
#import "SwipeTableView.h"
#import "CustomCollectionView.h"
#import "CustomSegmentControl.h"
#import "STHeaderView.h"
#import "CustomTableView.h"
#import "CBPersonalHomePageNavView.h"
#import "CBPersonalHomePageBottomView.h"

#define RGBColorAlpha(r,g,b,f)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:f]
#define RGBColor(r,g,b)          RGBColorAlpha(r,g,b,1)

typedef NS_ENUM(NSInteger,STControllerType) {
    STControllerTypeNormal,
    STControllerTypeHybrid,
    STControllerTypeDisableBarScroll,
    STControllerTypeHiddenNavBar,
};

@interface CBPersonalHomePageVC () <SwipeTableViewDataSource,SwipeTableViewDelegate>

@property (nonatomic, assign) STControllerType type;

@property (nonatomic, strong) SwipeTableView * swipeTableView;
@property (nonatomic, strong) CustomCollectionView * collectionView;
@property (nonatomic, strong) CustomSegmentControl * segmentBar;
@property (nonatomic, strong) STHeaderView * tableViewHeader;
@property (nonatomic, strong) CustomTableView * tableView;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) NSMutableDictionary * dataDic;
@property (nonatomic, strong) CBPersonalHomePageNavView *navView;
@property (nonatomic, strong) CBPersonalHomePageBottomView *bottomView;

@end

@implementation CBPersonalHomePageVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _type = STControllerTypeHiddenNavBar;
    
    [self.view addSubview:self.swipeTableView];
    
    // edge gesture
    [_swipeTableView.contentView.panGestureRecognizer requireGestureRecognizerToFail:self.screenEdgePanGestureRecognizer];

    [self.view addSubview:self.navView];
    [self.view addSubview:self.bottomView];
    @weakify(self);
    [self.navView.backBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // init data
    _dataDic = [@{} mutableCopy];
    
    // 根据滚动后的下标请求数据
    //    [self getDataAtIndex:0];
    
    // 一次性请求所有item的数据
    [self getAllData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

#pragma mark -

- (void)tapHeader:(UITapGestureRecognizer *)tap {
    NSLog(@"头部点击");
}

// tap to change header's frame
- (void)_tapHeader:(UITapGestureRecognizer *)tap {
    
    CGFloat changeHeight = 50; // or -50, it will be parallax.
    UIScrollView * currentItem = _swipeTableView.currentItemView;
#if !defined(ST_PULLTOREFRESH_HEADER_HEIGHT)
    CGPoint contentOffset = currentItem.contentOffset;
    UIEdgeInsets inset = currentItem.contentInset;
    inset.top += changeHeight;
    contentOffset.y -= changeHeight;  // if you want the header change height from up, not do this.
    
    NSMutableDictionary * contentOffsetQuene = [self.swipeTableView valueForKey:@"contentOffsetQuene"];
    [contentOffsetQuene removeAllObjects];
    
    [UIView animateWithDuration:.35f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tableViewHeader.height += changeHeight;
        currentItem.contentInset = inset;
        currentItem.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
        [self.swipeTableView setValue:@(self.tableViewHeader.height) forKey:@"headerInset"];
    }];
#else
    UIView * tableHeaderView = ((UITableView *)currentItem).tableHeaderView;
    tableHeaderView.st_height += changeHeight;
    
    [UIView animateWithDuration:.35f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tableViewHeader.st_height += changeHeight;
        [currentItem setValue:tableHeaderView forKey:@"tableHeaderView"];
    } completion:^(BOOL finished) {
        [self.swipeTableView setValue:@(self.tableViewHeader.st_height) forKey:@"headerInset"];
    }];
#endif
    
}

- (void)shimmerHeaderTitle:(UILabel *)title {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.75f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        title.transform = CGAffineTransformMakeScale(0.98, 0.98);
        title.alpha = 0.3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.75f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            title.alpha = 1.0;
            title.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [weakSelf shimmerHeaderTitle:title];
        }];
    }];
}

- (CustomTableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[CustomTableView alloc]initWithFrame:_swipeTableView.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBColor(255, 255, 225);
    }
    return _tableView;
}

- (CustomCollectionView *)collectionView {
    if (nil == _collectionView) {
        _collectionView = [[CustomCollectionView alloc]initWithFrame:_swipeTableView.bounds];
        _collectionView.backgroundColor = RGBColor(255, 255, 225);
    }
    return _collectionView;
}

- (void)changeSwipeViewIndex:(UISegmentedControl *)seg {
    [_swipeTableView scrollToItemAtIndex:seg.selectedSegmentIndex animated:NO];
    // request data at current index
    [self getDataAtIndex:seg.selectedSegmentIndex];
}

#pragma mark - Data Reuqest

// 请求数据（根据视图滚动到相应的index后再请求数据）
- (void)getDataAtIndex:(NSInteger)index {
    if (nil != _dataDic[@(index)]) {
        return;
    }
    NSInteger numberOfRows = 0;
    switch (index) {
        case 0:
            numberOfRows = _type == STControllerTypeNormal?8:10;
            break;
        case 1:
            numberOfRows = _type == STControllerTypeNormal?10:8;
            break;
        case 2:
            numberOfRows = _type == STControllerTypeNormal?5:6;
            break;
        case 3:
            numberOfRows = _type == STControllerTypeNormal?12:12;
            break;
        default:
            break;
    }
    // 请求数据后刷新相应的item
    ((void (*)(void *, SEL, NSNumber *, NSInteger))objc_msgSend)((__bridge void *)(self.swipeTableView.currentItemView),@selector(refreshWithData:atIndex:), @(numberOfRows),index);
    // 保存数据
    [_dataDic setObject:@(numberOfRows) forKey:@(index)];
}

// 请求数据（一次性获取所有item的数据）
- (void)getAllData {
    if (_type == STControllerTypeNormal) {
        [_dataDic setObject:@(8) forKey:@(0)];
        [_dataDic setObject:@(10) forKey:@(1)];
        [_dataDic setObject:@(5) forKey:@(2)];
        [_dataDic setObject:@(12) forKey:@(3)];
    }else {
        [_dataDic setObject:@(10) forKey:@(0)];
        [_dataDic setObject:@(12) forKey:@(1)];
        [_dataDic setObject:@(8) forKey:@(2)];
        [_dataDic setObject:@(14) forKey:@(3)];
    }
}


#pragma mark - SwipeTableView M

- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 4;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    switch (_type) {
        case STControllerTypeNormal:
        {
            
            CustomTableView * tableView = (CustomTableView *)view;
            // 重用
            if (nil == tableView) {
                tableView = [[CustomTableView alloc]initWithFrame:swipeView.bounds style:UITableViewStylePlain];
                tableView.backgroundColor = RGBColor(255, 255, 225);
            }
            
            // 获取当前index下item的数据，进行数据刷新
            id data = _dataDic[@(index)];
            [tableView refreshWithData:data atIndex:index];
            
            view = tableView;
        }
            break;
        case STControllerTypeHybrid:
        case STControllerTypeDisableBarScroll:
        case STControllerTypeHiddenNavBar:
        {
            
            // 混合的itemview只有同类型的item采用重用
            if (index == 0 || index == 2) {
                
                // 懒加载保证同样类型的item只创建一次，以达到重用
                CustomTableView * tableView = self.tableView;
                
                // 获取当前index下item的数据，进行数据刷新
                id data = _dataDic[@(index)];
                [tableView refreshWithData:data atIndex:index];
                
                view = tableView;
            }else {
                
                CustomCollectionView * collectionView = self.collectionView;
                
                // 获取当前index下item的数据，进行数据刷新
                id data = _dataDic[@(index)];
                [collectionView refreshWithData:data atIndex:index];
                
                view = self.collectionView;
            }
            
        }
            break;
        default:
            break;
    }
    
    // 在没有设定下拉刷新宏的条件下，自定义的下拉刷新需要做 refreshheader 的 frame 处理
    [self configRefreshHeaderForItem:view];
    
    return view;
}

// swipetableView index变化，改变seg的index
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    _segmentBar.selectedSegmentIndex = swipeView.currentItemIndex;
}

// 滚动结束请求数据
- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView {
    [self getDataAtIndex:swipeView.currentItemIndex];
}

/**
 *  以下两个代理，在未定义宏 #define ST_PULLTOREFRESH_HEADER_HEIGHT，并自定义下拉刷新的时候，必须实现
 *  如果设置了下拉刷新的宏，以下代理可根据需要实现即可
 */
- (BOOL)swipeTableView:(SwipeTableView *)swipeTableView shouldPullToRefreshAtIndex:(NSInteger)index {
    return YES;
}

- (CGFloat)swipeTableView:(SwipeTableView *)swipeTableView heightForRefreshHeaderAtIndex:(NSInteger)index {
    return 60;
}

/**
 *  采用自定义修改下拉刷新，此时不会定义宏 #define ST_PULLTOREFRESH_HEADER_HEIGHT
 *  对于一些下拉刷新控件，可能会在`layouSubViews`中设置RefreshHeader的frame。所以，需要在itemView有效的方法中改变RefreshHeader的frame，如 `scrollViewDidScroll:`
 */
- (void)configRefreshHeaderForItem:(UIScrollView *)itemView {
    if (_type == STControllerTypeDisableBarScroll) {
        itemView.header = nil;
        return;
    }
//#if !defined(ST_PULLTOREFRESH_HEADER_HEIGHT)
//    STRefreshHeader * header = itemView.header;
//    header.st_y = - (header.st_height + (_segmentBar.st_height + _headerImageView.st_height));
//#endif
}


#pragma mark - Header & Bar

- (UIView *)tableViewHeader {
    if (nil == _tableViewHeader) {
        UIImage * headerImage = [UIImage imageNamed:@"onepiece_kiudai"];
        // swipe header
        self.tableViewHeader = [[STHeaderView alloc]init];
        _tableViewHeader.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * (4/4));
        _tableViewHeader.backgroundColor = [UIColor whiteColor];
        _tableViewHeader.layer.masksToBounds = YES;
        
        // image view
        self.headerImageView = [[UIImageView alloc]initWithImage:headerImage];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.frame = _tableViewHeader.bounds;
        _headerImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        // title label
        UILabel * title = [[UILabel alloc]init];
        title.textColor = RGBColor(255, 255, 255);
        title.font = [UIFont boldSystemFontOfSize:17];
        title.text = @"Tap To Full Screen";
        title.textAlignment = NSTextAlignmentCenter;
        title.size = CGSizeMake(200, 30);
        title.centerX = _headerImageView.centerX;
        title.bottom = _headerImageView.bottom - 20;
        
        // tap gesture
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeader:)];
        
        [_tableViewHeader addSubview:_headerImageView];
        [_tableViewHeader addSubview:title];
        [_headerImageView addGestureRecognizer:tap];
        [self shimmerHeaderTitle:title];
    }
    return _tableViewHeader;
}

- (CustomSegmentControl * )segmentBar {
    if (nil == _segmentBar) {
        self.segmentBar = [[CustomSegmentControl alloc]initWithItems:@[@"Item0",@"Item1"]];
        _segmentBar.size = CGSizeMake(kScreenWidth, 40);
        _segmentBar.font = [UIFont systemFontOfSize:15];
        _segmentBar.textColor = RGBColor(100, 100, 100);
        _segmentBar.selectedTextColor = RGBColor(0, 0, 0);
        _segmentBar.backgroundColor = RGBColor(249, 251, 198);
        _segmentBar.selectionIndicatorColor = RGBColor(249, 104, 92);
        _segmentBar.selectedSegmentIndex = _swipeTableView.currentItemIndex;
        [_segmentBar addTarget:self action:@selector(changeSwipeViewIndex:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentBar;
}

- (CBPersonalHomePageNavView *)navView {
    if (!_navView) {
        _navView = [CBPersonalHomePageNavView viewFromXib];
        _navView.frame = CGRectMake(0, 0, kScreenWidth, SafeAreaTopHeight);
    }
    return _navView;
}

- (CBPersonalHomePageBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [CBPersonalHomePageBottomView viewFromXib];
        CGFloat height = kScreenHeight - SafeAreaBottomHeight - 50;
        _bottomView.frame = CGRectMake(0, height, kScreenWidth, 50);
    }
    return _bottomView;
}

- (SwipeTableView *)swipeTableView {
    if (!_swipeTableView) {
        _swipeTableView = [[SwipeTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-SafeAreaBottomHeight)];
        _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _swipeTableView.delegate = self;
        _swipeTableView.dataSource = self;
        _swipeTableView.shouldAdjustContentSize = YES;
        _swipeTableView.swipeHeaderView = self.tableViewHeader;
        _swipeTableView.swipeHeaderBar = self.segmentBar;
        _swipeTableView.swipeHeaderBarScrollDisabled = NO;
        _swipeTableView.swipeHeaderTopInset = 0;
    }
    return _swipeTableView;
}
@end
