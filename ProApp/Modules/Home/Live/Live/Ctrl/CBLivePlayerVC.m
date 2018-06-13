//
//  CBLivePlayerVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLivePlayerVC.h"
#import "CBAppLiveVO.h"
#import "CBRoomView.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "EaseChatView.h"

@interface CBLivePlayerVC () <UIGestureRecognizerDelegate, EaseChatViewDelegate>
{
    EaseLiveRoom *_room;
}

@property (nonatomic, strong) EaseChatView *chatview;

@property (nonatomic, strong) CBRoomView *roomView;
//--------------------------------------------------------
// 点亮功能
@property (nonatomic, strong) UITapGestureRecognizer *starTap;// 点亮手势
@property (nonatomic, assign) BOOL firstStar;                 // 第一次点亮
@property (nonatomic, strong) UIImageView *starImage;         // 点亮图片
@property (nonatomic, strong) NSNumber *heartNum;
@property (nonatomic, assign) NSInteger starisok;
@property (nonatomic, strong) UITableView *tableView;
//--------------------------------------------------------

@end

@implementation CBLivePlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupRoom {
    [self.view addSubview:self.roomView];
    [self setup_starTap];
    [self.roomView.rightView addSubview:self.chatview];
}

#pragma mark - 重写父类方法
- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
        self.thumbImageView.hidden = YES;
        [self setupRoom];
    }
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error {
    NSString *info = [NSString stringWithFormat:@"发生错误,error = %@, code = %ld", error.description, (long)error.code];
    NSLog(@"%@",info);
}

#pragma mark - layz
- (CBRoomView *)roomView {
    if (!_roomView) {
        _roomView = [[CBRoomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _roomView;
}

#pragma mark - Set 
- (void)setLive:(CBAppLiveVO *)live {
    _live = live;
    self.url = [NSURL URLWithString:live.channel_source];
    self.thumbImageURL = [NSURL URLWithString:live.thumb];
}

//--------------------------------------------------------
- (EaseChatView*)chatview {
    if (!_chatview) {
        CGFloat y = KScreenHeight - 250 - SafeAreaBottomHeight;
        CGRect frame = CGRectMake(0, y, kScreenWidth, 250);
        _chatview = [[EaseChatView alloc] initWithFrame:frame room:_room isPublish:NO];
        _chatview.delegate = self;
    }
    return _chatview;
}
// 以上聊天功能
//--------------------------------------------------------
// 点亮功能
- (void)setup_starTap {
    self.starTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
    self.starTap.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.starTap.numberOfTapsRequired = 1;
    self.starTap.numberOfTouchesRequired = 1;
    [self.roomView.scrollView addGestureRecognizer:self.starTap];
}

//点亮星星
- (void)starok{
//    self.tableView.frame = CGRectMake(_window_width + 10,setFrontV.frame.size.height - _window_height*0.25 - 50,_window_width*0.95 + 30,_window_height*0.25);
//    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
//    [keyField resignFirstResponder];
//    [setFrontV showBTN:_livetype];
//    keyBTN.hidden = NO;
//    //♥
//    if (firstStar == 0) {
//        [self staredMove];
//        firstStar = 1;
//        [socketDelegate starlight:level :heartNum];
//        titleColor = @"0";
//    }
    [self staredMove];
}

- (void)staredMove {
    CGFloat starX = self.chatview.bottomView.centerX-15;
    CGFloat starY = self.chatview.bottomView.centerY-15;
    NSInteger random = arc4random()%4;
    self.starImage = [[UIImageView alloc]initWithFrame:CGRectMake(starX+random,starY-random,30,30)];
    self.starImage.alpha = 0;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"plane_heart_cyan.png",@"plane_heart_pink.png",@"plane_heart_red.png",@"plane_heart_yellow.png", nil];
    srand((unsigned)time(0));
    self.starImage.image = [UIImage imageNamed:[array objectAtIndex:random]];
    self.heartNum = [NSNumber numberWithInteger:random];
    [UIView animateWithDuration:0.2 animations:^{
        self.starImage.alpha = 1.0;
        self.starImage.frame = CGRectMake(starX+random - 10, starY-random - 30, 30, 30);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
        self.starImage.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [self.roomView.rightView addSubview:self.starImage];
    
    CGFloat finishX = kScreenWidth - round(arc4random() % 200);
    CGFloat finishY = 200;                                                                  //  动画结束点的Y值
    CGFloat scale = round(arc4random() % 2) + 0.7;                                          //  imageView在运动过程中的缩放比例
    CGFloat speed = 1 / round(arc4random() % 900) + 0.6;                                    // 生成一个作为速度参数的随机数
    NSTimeInterval duration = 4 * speed;                                                    //  动画执行时间
    if (duration == INFINITY) duration = 2.412346;                                          //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(self.starImage)];        //  开始动画
    [UIView setAnimationDuration:duration];                                                 //  设置动画时间
    self.starImage.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);           //  设置imageView的结束frame
    [UIView animateWithDuration:duration animations:^{                                      //  设置渐渐消失的效果，这里的时间最好和动画时间一致
        self.starImage.alpha = 0;
    }];
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];  //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDelegate:self];                                                     //  设置动画代理
    [UIView commitAnimations];
    
//    if (starisok == 0) {
//        starisok = 1;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            starisok = 0;
//        });
//        [socketDelegate starlight];
//    }
}

/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageViewsss = (__bridge UIImageView *)(context);
    [imageViewsss removeFromSuperview];
    imageViewsss = nil;
}
// 以上是点亮功能
//--------------------------------------------------------

@end
 
