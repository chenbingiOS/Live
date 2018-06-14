//
//  CBLivePlayerVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLivePlayerVC.h"
#import "CBAppLiveVO.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "EaseChatView.h"
#import "CBLiveAnchorView.h"
#import "CBLiveBottomView.h"
#import "UILabel+ShadowText.h"
#import "CBOnlineUserView.h"
#import "CBAnchorInfoView.h"
#import "CBGuardVC.h"
#import "CBGuardRankVC.h"
#import "CBContributionRankVC.h"

#import "JPGiftView.h"
#import "JPGiftCellModel.h"
#import "JPGiftModel.h"
#import "JPGiftShowManager.h"
#import "UIImageView+WebCache.h"
#import "NSObject+YYModel.h"
#import "EaseHeartFlyView.h"

@interface CBLivePlayerVC () <UIGestureRecognizerDelegate, EaseChatViewDelegate> {
    EaseLiveRoom *_room;
}

@property (nonatomic, strong) UIView *roomView;                 ///< 房间UI
@property (nonatomic, strong) UIScrollView *scrollView;         ///< 实现左滑清空数据
@property (nonatomic, strong) UIView *leftView;                 ///< 左边控件容器
@property (nonatomic, strong) UIView *rightView;                ///< 右边控件容器
@property (nonatomic, strong) UIImageView *topGradientView;     ///< 上部渐变
@property (nonatomic, strong) UIImageView *bottomGradientView;  ///< 下部渐变
@property (nonatomic, strong) UILabel *roomCodeLabel;           ///< 房间号

@property (nonatomic, strong) CBLiveAnchorView *anchorView;     ///< 顶部主播相关视图
@property (nonatomic, strong) CBOnlineUserView *onlineUserView; ///< 在线用户
@property (nonatomic, strong) CBAnchorInfoView *anchorInfoView; ///< 直播用户信息
@property (nonatomic, strong) EaseChatView *chatview;           ///< 底部聊天
@property (nonatomic, strong) JPGiftView *giftView;             /** gift */
@property (nonatomic, strong) UIImageView *gifImageView;        /** gifimage */


// 键盘关闭功能
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGR;

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

#pragma mark - 重写父类方法
- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
        self.thumbImageView.hidden = YES;
    }
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error {
    NSString *info = [NSString stringWithFormat:@"发生错误,error = %@, code = %ld", error.description, (long)error.code];
    NSLog(@"%@",info);
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setup_UI];
//    [self setupForDismissKeyboard];
}

- (void)reloadData_UI {
    
}

- (void)setup_UI {
    [self.view addSubview:self.roomView];
    [self.roomView addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.rightView];
    [self.leftView addSubview:self.roomCodeLabel];
    [self.rightView addSubview:self.topGradientView];
    [self.rightView addSubview:self.bottomGradientView];
    [self.rightView addSubview:self.anchorView];
    [self.rightView addSubview:self.chatview];
    
//    [self setup_starTap];
}

#pragma mark - layz
- (UIView *)roomView {
    if (!_roomView) {
        _roomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _roomView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight);
        _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _leftView.backgroundColor = [UIColor clearColor];
    }
    return _leftView;
}

- (UILabel *)roomCodeLabel {
    if (!_roomCodeLabel) {
        _roomCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 100, 30)];
        _roomCodeLabel.textColor = [UIColor whiteColor];
        _roomCodeLabel.font = [UIFont systemFontOfSize:13];
        [_roomCodeLabel shadowWtihText:@"房间号:11214"];
    }
    return _roomCodeLabel;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        _rightView.backgroundColor = [UIColor clearColor];
    }
    return _rightView;
}

- (UIImageView *)topGradientView {
    if (!_topGradientView) {
        _topGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
        _topGradientView.image = [UIImage imageNamed:@"topGradient"];
    }
    return _topGradientView;
}

- (UIView *)bottomGradientView {
    if (!_bottomGradientView) {
        _bottomGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-205, kScreenWidth, 205)];
        _bottomGradientView.image = [UIImage imageNamed:@"bottomGradient"];
    }
    return _bottomGradientView;
}

- (CBLiveAnchorView *)anchorView {
    if (!_anchorView) {
        _anchorView = [CBLiveAnchorView viewFromXib];
        CGFloat y = 0;
        if (iPhoneX) y += 10;
        _anchorView.frame = CGRectMake(0, y, kScreenWidth, 130);
    }
    return _anchorView;
}

- (CBOnlineUserView *)onlineUserView {
    if (!_onlineUserView) {
        _onlineUserView = [[CBOnlineUserView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
    }
    return _onlineUserView;
}

- (CBAnchorInfoView *)anchorInfoView {
    if (!_anchorInfoView) {
        _anchorInfoView = [[CBAnchorInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 365)];
    }
    return _anchorInfoView;
}

- (UIImageView *)gifImageView{
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 0, 360, 225)];
        _gifImageView.hidden = YES;
    }
    return _gifImageView;
}

- (JPGiftView *)giftView{
    if (!_giftView) {
        _giftView = [[JPGiftView alloc] init];
        _giftView.delegate = self;
    }
    return _giftView;
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
        CGFloat y = KScreenHeight - 200 - SafeAreaBottomHeight;
        CGRect frame = CGRectMake(0, y, kScreenWidth, 200);
        _chatview = [[EaseChatView alloc] initWithFrame:frame room:_room isPublish:NO];
        _chatview.delegate = self;
    }
    return _chatview;
}
#pragma mark - EaseChatViewDelegate

- (void)easeChatViewDidChangeFrameToHeight:(CGFloat)toHeight
{
    if ([self.window isKeyWindow]) {
        return;
    }
    
    if (toHeight == 200) {
        [self.scrollView removeGestureRecognizer:self.singleTapGR];
    } else {
        [self.scrollView addGestureRecognizer:self.singleTapGR];
    }
    
    if (!self.chatview.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.chatview.frame;
            rect.origin.y = self.view.frame.size.height - toHeight;
            self.chatview.frame = rect;
        }];
    }
}

- (void)didReceivePraiseWithCMDMessage:(EMMessage *)message
{
    [self showTheLoveAction];
}

-(void)showTheLoveAction
{
    EaseHeartFlyView* heart = [[EaseHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, 55, 50)];
    [_chatview addSubview:heart];
    CGPoint fountainSource = CGPointMake(KScreenWidth - (20 + 50/2.0), _chatview.height);
    heart.center = fountainSource;
    [heart animateInView:_chatview];
}


- (void)didSelectUserWithMessage:(EMMessage *)message
{
    //    [self.view endEditing:YES];
    //    BOOL isOwner = _chatroom.permissionType == EMChatroomPermissionTypeOwner;
    //    BOOL ret = _chatroom.permissionType == EMChatroomPermissionTypeAdmin || isOwner;
    //    if (ret || _enableAdmin) {
    //        EaseProfileLiveView *profileLiveView = [[EaseProfileLiveView alloc] initWithUsername:message.from
    //                                                                                  chatroomId:_room.chatroomId
    //                                                                                     isOwner:isOwner];
    //        profileLiveView.delegate = self;
    //        [profileLiveView showFromParentView:self.view];
    //    }
}

- (void)didSelectAdminButton:(BOOL)isOwner
{
    //    EaseAdminView *adminView = [[EaseAdminView alloc] initWithChatroomId:_room.chatroomId
    //                                                                 isOwner:isOwner];
    //    adminView.delegate = self;
    //    [adminView showFromParentView:self.view];
}

- (void)setupForDismissKeyboard {
    _singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    [self.chatview endEditing:YES];
}



// 以上聊天功能
//--------------------------------------------------------
// 点亮功能
- (void)setup_starTap {
    self.starTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
    self.starTap.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.starTap.numberOfTapsRequired = 1;
    self.starTap.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:self.starTap];
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
    [self.rightView addSubview:self.starImage];
    
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
 
