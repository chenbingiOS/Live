//
//  PLSStickerBar.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSStickerBar.h"
#import "UIView+PLSLightFrame.h"
#import "PLSToolBarCommon.h"

#define stickerRow 2
#define stickerSize 60
#define pageControlHeight 30

#define kImageExtensions @[@"png", @"jpg", @"jpeg", @"gif"]

@interface PLSStickerBar () <UIScrollViewDelegate>

@property (nonatomic, strong) NSString *resourcePath;
@property (nonatomic, strong) NSArray<NSString *> *files;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, weak) UIScrollView *scrollViewSticker;
@property (nonatomic, weak) UIPageControl *pageControlSticker;

@property (nonatomic, assign) BOOL external;

@end

@implementation PLSStickerBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame resourcePath:(NSString *)resourcePath
{
    self = [super initWithFrame:frame];
    if (self) {
        _resourcePath = resourcePath;
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    if (iOS8Later) {
        // 定义毛玻璃效果
        self.backgroundColor = [UIColor clearColor];
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
        effe.frame = self.bounds;
        [self addSubview:effe];
    } else {
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    }
    self.userInteractionEnabled = YES;
    /** 添加按钮获取点击 */
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = self.bounds;
    [self addSubview:bgButton];
    
    NSFileManager *fileManager = [NSFileManager new];
    if (self.resourcePath && [fileManager fileExistsAtPath:self.resourcePath]) {
        NSArray *files = [fileManager contentsOfDirectoryAtPath:self.resourcePath error:nil];
        NSMutableArray *newFiles = [@[] mutableCopy];
        for (NSString *fileName in files) {
            if ([kImageExtensions containsObject:[fileName.pathExtension lowercaseString]]) {
                [newFiles addObject:fileName];
            }
        }
        self.files = [newFiles copy];
        self.external = YES;
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:kStickersPath ofType:nil];
        self.files = [fileManager contentsOfDirectoryAtPath:path error:nil];
    }
    
    NSInteger count = self.files.count;
    [self setupScrollView:count];
    [self setupPageControl];
}

- (void)setupScrollView:(NSInteger)count
{
    
    UIScrollView *scrollViewSticker = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [scrollViewSticker setBackgroundColor:[UIColor clearColor]];
    NSInteger index = 0;
    
    NSInteger row = stickerRow;
    NSInteger column = self.frame.size.width / (stickerSize + self.frame.size.width * 0.1);
    
    CGFloat size = stickerSize;
    CGFloat marginRow = (scrollViewSticker.bounds.size.width-column*size)/(column+1);
    CGFloat marginColumn = (scrollViewSticker.bounds.size.height-row*size)/(row+1);
    
    NSInteger pageCount = count/(row*column);
    pageCount = count%(row*column) > 0 ? pageCount + 1 : pageCount;
    self.pageCount = pageCount;
    
    for (NSInteger pageIndex = 0; pageIndex < pageCount; pageIndex ++) {
        
        CGFloat x = pageIndex * self.bounds.size.width;
        
        for (NSInteger j=1; j<=row; j++) {
            for (NSInteger i=1;i<=column;i++) {
                if (index >= count) break;
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake((x + i * marginRow + (i - 1) * size), (j * marginColumn + (j - 1) * size), size, size)];
                [button setBackgroundColor:[UIColor clearColor]];
                UIImage * backImage = nil;
                if (self.external) {
                    backImage = [UIImage imageWithContentsOfFile:[self.resourcePath stringByAppendingPathComponent:self.files[index]]];
                } else {
                    backImage = bundleStickerImageNamed(self.files[index]);
                }
                [button setBackgroundImage:backImage forState:UIControlStateNormal];
                button.tag = index;
                [button addTarget:self action:@selector(stickerClicked:) forControlEvents:UIControlEventTouchUpInside];
                index++;
                [scrollViewSticker addSubview:button];
            }
        }
    }
    
    [scrollViewSticker setShowsVerticalScrollIndicator:NO];
    [scrollViewSticker setShowsHorizontalScrollIndicator:NO];
    scrollViewSticker.alwaysBounceHorizontal = YES;
    scrollViewSticker.contentSize=CGSizeMake(self.bounds.size.width * pageCount, 0);
    scrollViewSticker.pagingEnabled=YES;
    scrollViewSticker.delegate=self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testPressed)];
    [scrollViewSticker addGestureRecognizer:tap];
    [self addSubview:scrollViewSticker];
    self.scrollViewSticker = scrollViewSticker;
}

- (void)testPressed
{
    /** 接收scrollView的点击事件，避免传递到下层控件响应 */
}

- (void)setupPageControl
{
    if (self.pageCount > 1) {
        CGFloat width = 150.0;
        CGFloat x = self.bounds.size.width/2 - width/2;
        UIPageControl *pageControlSticker=[[UIPageControl alloc]initWithFrame:CGRectMake( x,self.height-pageControlHeight,width,pageControlHeight)];
        [pageControlSticker setCurrentPage:0];
        pageControlSticker.numberOfPages = self.pageCount;   //指定页面个数
        [pageControlSticker setBackgroundColor:[UIColor clearColor]];
        [pageControlSticker setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        [pageControlSticker setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [pageControlSticker addTarget:self action:@selector(stickerPageControl:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:pageControlSticker];
        self.pageControlSticker = pageControlSticker;
    }
}

- (void)stickerClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(stickerBar:didSelectImage:)]) {
        [self.delegate stickerBar:self didSelectImage:[button backgroundImageForState:UIControlStateNormal]];
    }
}

#pragma mark - pageControl滚动事件
- (void)stickerPageControl:(UIPageControl *)pageControl
{
    NSInteger page = pageControl.currentPage;//获取当前pagecontroll的值
    [self.scrollViewSticker setContentOffset:CGPointMake(self.bounds.size.width * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 设置pageCotrol 当前对应位置
    NSInteger currentPage = self.scrollViewSticker.contentOffset.x / self.bounds.size.width;
    [self.pageControlSticker setCurrentPage:currentPage];
}

@end
