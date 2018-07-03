//
//  CBVideoScrollVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBVideoScrollVC.h"
#import "CBShortVideoVO.h"
#import "CBPlayVideoVC.h"

@interface CBVideoScrollVC () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray <CBShortVideoVO *> *roomDatas;  /** 直播 */
@property (nonatomic, assign) NSInteger index;      /** 当前的index */
/**所有视图*/
@property (nonatomic, strong) NSMutableArray* subViews;
/**正在显示的视图*/
@property (nonatomic, strong) UIView *showView;
/** 直播 */
@property (nonatomic, strong) CBPlayVideoVC *roomShowView;

@end

@implementation CBVideoScrollVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLive) name:@"KNotificationCloseLiveVC" object:nil];
}

- (instancetype)initWithLives:(NSArray *)lives currentIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        _roomDatas = lives;
        _index = index;
        
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:frame];
        scrollerView.delegate = self;
        scrollerView.bounces = NO;
        scrollerView.pagingEnabled = YES;
        scrollerView.showsHorizontalScrollIndicator = NO;
        scrollerView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:scrollerView];
        
        for (NSInteger i = 0; i < 3; i ++ ){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self generateDimImage:imageView];
            CGFloat imageY = CGRectGetHeight(self.view.bounds)*i;
            imageView.frame = CGRectMake(0, imageY, kScreenWidth, kScreenHeight);
            [scrollerView addSubview:imageView];
            [self.subViews addObject:imageView];
        }
        scrollerView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*3);
        scrollerView.contentOffset = CGPointMake(0, kScreenHeight);
        
        [self setUpImageWith:index];
    }
    return self;
}

- (void)closeLive {
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置当前图片根据当前的索引
- (void)setUpImageWith:(NSInteger )index{
    NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.subViews.count; i ++) {
        UIImageView *imageView = self.subViews[i];
        imageView.userInteractionEnabled = YES;
        if (i==0) {
            currentIndex = index==0 ? self.roomDatas.count-1 : index -1;
        } else if (i==1) {
            currentIndex = index;
        } else{
            currentIndex = index==self.roomDatas.count-1 ? 0 : index + 1;
        }
        /**此处非常重要 可以根据自己是实际需要选折是显示本地照片或者网路照片,若显示网路照片,请将下面的方法换成sdwebimage显示图片方法*/
//        imageView.image = [UIImage imageNamed:self.roomDatas[currentIndex]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.roomDatas[currentIndex].thumb]];
    }
    
    //主需要将播放视图展示在 i==1 的界面即可
    UIView *currentView = self.subViews[1];
    [currentView addSubview:self.roomShowView.view];
    // 加载数据
    if (currentIndex == 0) {
        currentIndex = self.roomDatas.count-1;
    } else if (currentIndex > 0) {
        currentIndex--;
    }
    self.roomShowView.video = self.roomDatas[currentIndex];
}

#pragma mark UIScrollViewDelegate 此处解决了scrollerview的循环引用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index  = scrollView.contentOffset.y/kScreenHeight;
    if (index==1) return;
    for (NSInteger i = 0; i < self.subViews.count; i ++ ) {
        UIView *subView = self.subViews[i];
        if (index == i) {
            self.showView = subView;
            continue;
        }
        [subView removeFromSuperview];
    }
    [self.subViews removeAllObjects];
    self.index = scrollView.contentOffset.y/kScreenHeight < 1 ? --self.index : ++self.index;
    if (self.index < 0) {
        self.index = self.roomDatas.count - 1;
    } else if (self.index >= self.roomDatas.count){
        self.index = 0;
    }
    for (NSInteger i = 0; i < 3; i ++ ) {
        if (i == 1) {
            self.showView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
            [self.subViews addObject:self.showView];
            continue;
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self generateDimImage:imageView];
        CGFloat imageY = CGRectGetHeight(self.view.bounds)*i;
        imageView.frame = CGRectMake(0, imageY, kScreenWidth, kScreenHeight);
        [scrollView addSubview:imageView];
        [self.subViews addObject:imageView];
    }
    scrollView.contentOffset = CGPointMake(0, kScreenHeight);
    
    // 设置直播间
    [self setUpImageWith:self.index];
}

// 生成磨玻璃图片
- (void)generateDimImage:(UIImageView *)imageView{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    [imageView addSubview:effectView];
}

#pragma mark - layz

- (CBPlayVideoVC *)roomShowView{
    if (!_roomShowView) {
        _roomShowView = [[CBPlayVideoVC alloc] init];
    }
    return _roomShowView;
}

- (NSMutableArray *)subViews{
    if (!_subViews) {
        _subViews = [NSMutableArray arrayWithCapacity:3];
    }
    return _subViews;
}


@end
