//
//  CBLivePlayerVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLivePlayerVC.h"
// VC
#import "CBGuardVC.h"
#import "CBGuardRankVC.h"
#import "CBContributionRankVC.h"
// View
#import "EaseChatView.h"
#import "CBLiveAnchorView.h"
#import "CBLiveBottomView.h"
#import "CBOnlineUserView.h"
#import "CBAnchorInfoView.h"
#import "EaseProfileLiveView.h"
#import "EaseAdminView.h"
#import "EaseLiveHeaderListView.h"
#import "EaseHeartFlyView.h"
#import "CBShareView.h"
#import "CBLiveGuardianListView.h"
//
#import "CBAppLiveVO.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "UILabel+ShadowText.h"
#import "CBActionLiveDelegate.h"

@interface CBLivePlayerVC ()
<
UIGestureRecognizerDelegate,
EaseChatViewDelegate,
EMClientDelegate,
EMChatroomManagerDelegate,
TapBackgroundViewDelegate,
CBActionLiveDelegate
>
{
    BOOL _enableAdmin;
}

@property (nonatomic, strong) UIButton *closeButton;            ///< 关闭按钮
@property (nonatomic, strong) EMChatroom *chatroom;             ///< 房间UI

@property (nonatomic, strong) UIView *roomView;                 ///< 房间UI
@property (nonatomic, strong) UIScrollView *scrollView;         ///< 实现左滑清空数据
@property (nonatomic, strong) UIView *leftView;                 ///< 左边控件容器
@property (nonatomic, strong) UIView *rightView;                ///< 右边控件容器
@property (nonatomic, strong) UIImageView *topGradientView;     ///< 上部渐变
@property (nonatomic, strong) UIImageView *bottomGradientView;  ///< 下部渐变
@property (nonatomic, strong) UILabel *roomCodeLabel;           ///< 房间号

@property (nonatomic, strong) CBLiveAnchorView *anchorView;     ///< 顶部主播相关视图
@property (nonatomic, strong) CBAnchorInfoView *anchorInfoView; ///< 直播用户信息
@property (nonatomic, strong) EaseChatView *chatview;           ///< 底部聊天
@property (nonatomic, strong) EaseLiveHeaderListView *headerListView;   ///< 顶部用户信息
@property (nonatomic, strong) CBLiveGuardianListView *guardianListView; ///<  顶部守护
@property (nonatomic, strong) CBOnlineUserView *onlineUserView; ///< 在线用户
@property (nonatomic, strong) CBSharePopView *sharePopView; ///< 在线用户

// 键盘关闭功能
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGR;

@end

@implementation CBLivePlayerVC

- (void)dealloc {
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient] removeDelegate:self];
    _chatview.delegate = nil;
    _chatview = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.closeButton];
}

#pragma mark - 重写父类方法

- (void)joinChatRoom {
    NSLog(@"用户%@,加入的房间号 %@", self.liveVO.ID, self.liveVO.leancloud_room);
    [self _UI_setupLiveRoom];
    [self _UI_JoinChatRoom];
}

- (void)leaveChatRoom {
    NSLog(@"用户%@,离开的房间号 %@", self.liveVO.ID, self.liveVO.leancloud_room);
    [self _UI_LeaveChatRoom];
}

- (void)_UI_JoinChatRoom {
    [self.headerListView loadHeaderListWithChatroomId:[self.liveVO.leancloud_room copy]];
    [self.guardianListView loadHeaderListWithChatroomId:[self.liveVO.leancloud_room copy]];
    
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    @weakify(self);
    [self.chatview joinChatroomWithIsCount:YES completion:^(BOOL success) {
        @strongify(self);
        if (success) {
            self.chatroom = [[EMClient sharedClient].roomManager getChatroomSpecificationFromServerWithId:self.liveVO.leancloud_room error:nil];
        } else {
            [MBProgressHUD showAutoMessage:@"加入聊天室失败"];
        }
    }];
}

- (void)_UI_LeaveChatRoom {
    [self.headerListView cancelRequest];
    [self.guardianListView cancelRequest];

    @weakify(self);
    [self.chatview leaveChatroomWithIsCount:YES completion:^(BOOL success) {
        @strongify(self);
        if (success) {
            [[EMClient sharedClient].chatManager deleteConversation:self.liveVO.leancloud_room isDeleteMessages:YES completion:NULL];
        } else {
            [MBProgressHUD showAutoMessage:@"离开聊天室失败"];
        }
    }];    
}

- (void)_UI_setupLiveRoom {
    [self.view addSubview:self.roomView];
    [self.roomView addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.rightView];
    [self.leftView addSubview:self.roomCodeLabel];
    [self.rightView addSubview:self.topGradientView];
    [self.rightView addSubview:self.bottomGradientView];
    [self.rightView addSubview:self.headerListView];
    [self.rightView addSubview:self.guardianListView];
    [self.rightView addSubview:self.chatview];
    [self.view bringSubviewToFront:self.closeButton];
//    [self.view insertSubview:self.closeButton atIndex:999];
    [self setupForDismissKeyboard];
}

#pragma mark - Set
- (void)setLiveVO:(CBAppLiveVO *)liveVO {
    _liveVO = liveVO;
    self.thumbImageURL = [NSURL URLWithString:liveVO.thumb];
    self.url = [NSURL URLWithString:liveVO.channel_source];
    [self.roomCodeLabel shadowWtihText:[NSString stringWithFormat:@"房间号: %@", liveVO.room_id]];
}

#pragma mark - layz

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = SafeAreaTopHeight - 44;
        _closeButton.frame = CGRectMake(kScreenWidth - 50, y, 50, 50);
        [_closeButton setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(actionCloseLive:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

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
        CGFloat y = SafeAreaTopHeight - 40;
        _roomCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 100, 30)];
        _roomCodeLabel.textColor = [UIColor whiteColor];
        _roomCodeLabel.font = [UIFont systemFontOfSize:13];
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

- (CBAnchorInfoView *)anchorInfoView {
    if (!_anchorInfoView) {
        CGFloat height = 365;
        if (iPhoneX) height += SafeAreaBottomHeight;
        _anchorInfoView = [[CBAnchorInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height
                                                                             )];
    }
    return _anchorInfoView;
}

- (EaseChatView *)chatview {
    if (_chatview == nil) {
         CGFloat y = kScreenHeight - 200 - SafeAreaBottomHeight - 6;
        _chatview = [[EaseChatView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), 200) room:_liveVO isPublish:NO];
        _chatview.delegate = self;
    }
    return _chatview;
}

- (EaseLiveHeaderListView *)headerListView {
    if (!_headerListView) {
        CGFloat y = SafeAreaTopHeight - 44;
        CGRect frame = CGRectMake(0, y, kScreenWidth - 50, 50);
        _headerListView = [[EaseLiveHeaderListView alloc] initWithFrame:frame room:_liveVO];
        _headerListView.delegate = self;
    }
    return _headerListView;
}

- (CBLiveGuardianListView *)guardianListView {
    if (!_guardianListView ) {
        CGFloat y = SafeAreaTopHeight-4;
        CGRect frame = CGRectMake(0, y, kScreenWidth, 50);
        _guardianListView = [[CBLiveGuardianListView alloc] initWithFrame:frame room:_liveVO];
        _guardianListView.delegate = self;
    }
    return _guardianListView;
}

- (CBOnlineUserView *)onlineUserView {
    if (!_onlineUserView) {
        _onlineUserView = [[CBOnlineUserView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2) room:_liveVO];
    }
    return _onlineUserView;
}

- (CBSharePopView *)sharePopView {
    if (!_sharePopView) {
        CGFloat height = 180;
        if (iPhoneX) { height += 35;}
        _sharePopView = [[CBSharePopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    }
    return _sharePopView;
}

#pragma mark - CBActionLiveDelegate
// 开通守护
- (void)actionLiveOpenGuard {
    CBGuardVC *vc = [CBGuardVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 在线用户列表
- (void)actionLiveShowOnlineUserList {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.onlineUserView showIn:keyWindow];
}

// 贡献币，贡献榜
- (void)actionLiveShowContributionList {
    
}

#pragma mark - EaseLiveHeaderListViewDelegate

- (void)didSelectHeaderWithUsername:(NSString *)username {
    if ([self.window isKeyWindow]) {
        [self closeAction];
        return;
    }
    BOOL isOwner = self.chatroom.permissionType == EMChatroomPermissionTypeOwner;
    BOOL ret = self.chatroom.permissionType == EMChatroomPermissionTypeAdmin || isOwner;
    if (ret || _enableAdmin) {
        EaseProfileLiveView *profileLiveView = [[EaseProfileLiveView alloc] initWithUsername:username chatroomId:self.liveVO.leancloud_room isOwner:isOwner];
        profileLiveView.delegate = self;
        [profileLiveView showFromParentView:self.view];
    } else {
//        EaseProfileLiveView *profileLiveView = [[EaseProfileLiveView alloc] initWithUsername:username chatroomId:self.liveVO.leancloud_room];
//        profileLiveView.delegate = self;
//        [profileLiveView showFromParentView:self.view];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [self.anchorInfoView showIn:window];
        self.anchorInfoView.liveVO = _liveVO;
    }
}

#pragma  mark - TapBackgroundViewDelegate

- (void)didTapBackgroundView:(EaseBaseSubView *)profileView
{
    [profileView removeFromParentView];
}

#pragma mark - EaseChatViewDelegate

- (void)easeChatViewDidChangeFrameToHeight:(CGFloat)toHeight
{
    if ([self.window isKeyWindow]) {
        return;
    }
    
    if (toHeight == 200) {
        [self.view removeGestureRecognizer:self.singleTapGR];
        toHeight += SafeAreaBottomHeight+6;
    } else {
        [self.view addGestureRecognizer:self.singleTapGR];
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

- (void)didSelectUserWithMessage:(EMMessage *)message
{
    [self.view endEditing:YES];
    BOOL isOwner = self.chatroom.permissionType == EMChatroomPermissionTypeOwner;
    BOOL ret = self.chatroom.permissionType == EMChatroomPermissionTypeAdmin || isOwner;
    if (ret || _enableAdmin) {
        EaseProfileLiveView *profileLiveView = [[EaseProfileLiveView alloc] initWithUsername:message.from
                                                                                  chatroomId:self.liveVO.leancloud_room
                                                                                     isOwner:isOwner];
        profileLiveView.delegate = self;
        [profileLiveView showFromParentView:self.view];
    }
}

- (void)didSelectAdminButton:(BOOL)isOwner
{
    EaseAdminView *adminView = [[EaseAdminView alloc] initWithChatroomId:self.liveVO.leancloud_room isOwner:isOwner];
    adminView.delegate = self;
    [adminView showFromParentView:self.view];
}

- (void)didSelectShareButton {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.sharePopView showIn:window];
}

#pragma mark - EaseLiveGiftViewDelegate

- (void)didSelectGiftWithGiftId:(NSString *)giftId
{
    if (_chatview) {
        [_chatview sendGiftWithId:giftId];
    }
}

#pragma mark - EaseProfileLiveViewDelegate

#pragma mark - EMChatroomManagerDelegate

- (void)userDidJoinChatroom:(EMChatroom *)aChatroom
                       user:(NSString *)aUsername
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        if (![aChatroom.owner isEqualToString:aUsername]) {

        }
    }
}

- (void)userDidLeaveChatroom:(EMChatroom *)aChatroom
                        user:(NSString *)aUsername
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        if (![aChatroom.owner isEqualToString:aUsername]) {
        }
    }
}

- (void)didDismissFromChatroom:(EMChatroom *)aChatroom
                        reason:(EMChatroomBeKickedReason)aReason {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"被踢出直播聊天室" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [self actionCloseButton];
}

- (void)chatroomAdminListDidUpdate:(EMChatroom *)aChatroom
                        addedAdmin:(NSString *)aAdmin;
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        if ([aAdmin isEqualToString:[EMClient sharedClient].currentUsername]) {
            _enableAdmin = YES;
            [self.view layoutSubviews];
        }
    }
}

- (void)chatroomAdminListDidUpdate:(EMChatroom *)aChatroom
                      removedAdmin:(NSString *)aAdmin
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        if ([aAdmin isEqualToString:[EMClient sharedClient].currentUsername]) {
            _enableAdmin = NO;
            [self.view layoutSubviews];
        }
    }
}

- (void)chatroomMuteListDidUpdate:(EMChatroom *)aChatroom
                addedMutedMembers:(NSArray *)aMutes
                       muteExpire:(NSInteger)aMuteExpire
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        NSMutableString *text = [NSMutableString string];
        for (NSString *name in aMutes) {
            [text appendString:name];
        }
        [self showHint:[NSString stringWithFormat:@"禁言成员:%@",text]];
    }
}

- (void)chatroomMuteListDidUpdate:(EMChatroom *)aChatroom
              removedMutedMembers:(NSArray *)aMutes
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        NSMutableString *text = [NSMutableString string];
        for (NSString *name in aMutes) {
            [text appendString:name];
        }
        [self showHint:[NSString stringWithFormat:@"解除禁言:%@",text]];
    }
}

- (void)chatroomOwnerDidUpdate:(EMChatroom *)aChatroom
                      newOwner:(NSString *)aNewOwner
                      oldOwner:(NSString *)aOldOwner
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"聊天室创建者有更新:%@",aChatroom.chatroomId] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"publish.ok", @"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self actionCloseButton];
        }];
        
        [alert addAction:ok];
    }
}

#pragma mark - EMClientDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    [self actionCloseButton];
}

#pragma mark - Action

- (void)actionCloseLive: (UIButton *) button {
    [self actionCloseButton];
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        [self.closeButton removeFromSuperview];
    }];
}

- (void)closeAction {
    [self.window resignKeyWindow];
    [UIView animateWithDuration:0.3 animations:^{
        self.window.top = kScreenHeight;
    } completion:^(BOOL finished) {
        self.window.hidden = YES;
        [self.view.window makeKeyAndVisible];
    }];
}

- (void)showTheLoveAction {
    EaseHeartFlyView* heart = [[EaseHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, 55, 50)];
    [_chatview addSubview:heart];
    CGPoint fountainSource = CGPointMake(kScreenWidth - (20 + 50/2.0), _chatview.height);
    heart.center = fountainSource;
    [heart animateInView:_chatview];
}

- (void)actionCloseButton {
//    [self.playerManager.mediaPlayer.player.view removeFromSuperview];
//    [self.playerManager.controlVC.view removeFromSuperview];
//    [self.playerManager.mediaPlayer.player shutdown];
//    self.playerManager.mediaPlayer = nil;
//    self.playerManager = nil;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerPlaybackDidFinishNotification object:nil];
    
    [self _UI_LeaveChatRoom];
    
//    [_burstTimer invalidate];
//    _burstTimer = nil;
    
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = endFrame.origin.y;
    
    if ([self.window isKeyWindow]) {
        if (y == kScreenHeight) {
            [UIView animateWithDuration:0.3 animations:^{
                self.window.top = kScreenHeight - 290.f;
                self.window.height = 290.f;
            }];
        } else  {
            [UIView animateWithDuration:0.3 animations:^{
                self.window.top = 0;
                self.window.height = kScreenHeight;
            }];
        }
    }
}

#pragma mark - override

- (void)setupForDismissKeyboard
{
    _singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(tapAnywhereToDismissKeyboard:)];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    [self.chatview endEditing:YES];
}

@end

/**
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
 // 点亮功能
 @property (nonatomic, strong) UITapGestureRecognizer *starTap;// 点亮手势
 @property (nonatomic, assign) BOOL firstStar;                 // 第一次点亮
 @property (nonatomic, strong) UIImageView *starImage;         // 点亮图片
 @property (nonatomic, strong) NSNumber *heartNum;
 @property (nonatomic, assign) NSInteger starisok;
 @property (nonatomic, strong) UITableView *tableView;
 //--------------------------------------------------------

//--------------------------------------------------------

**/
