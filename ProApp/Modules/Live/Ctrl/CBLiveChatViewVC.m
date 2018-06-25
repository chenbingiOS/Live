//
//  CBLiveChatViewVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/22.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveChatViewVC.h"
// VC
#import "CBLiveGiftViewVC.h"
// VO
#import "CBAppLiveVO.h"
// View
#import "EaseChatView.h"
#import "EaseLiveHeaderListView.h"
#import "CBLiveGuardianListView.h"
#import "EaseLiveGiftView.h"
#import "EaseProfileLiveView.h"
#import "CBAnchorInfoView.h"
#import "EaseAdminView.h"
#import "CBOnlineUserView.h"

@interface CBLiveChatViewVC ()
<
    UIGestureRecognizerDelegate,
    EaseChatViewDelegate,
    EMClientDelegate,
    EMChatroomManagerDelegate,
    TapBackgroundViewDelegate,
    EaseLiveGiftViewDelegate,
    CBActionLiveDelegate
>
{
    BOOL _enableAdmin;
}

@property (nonatomic, strong) UIButton *closeButton;            ///< 关闭按钮
@property (nonatomic, strong) EMChatroom *chatroom;             ///< 房间UI
@property (nonatomic, strong) EaseChatView *chatview;           ///< 底部聊天
@property (nonatomic, strong) EaseLiveHeaderListView *headerListView;   ///< 顶部用户信息
@property (nonatomic, strong) CBLiveGuardianListView *guardianListView; ///<  顶部守护
@property (nonatomic, strong) CBAnchorInfoView *anchorInfoView; ///< 直播用户信息
@property (nonatomic, strong) CBSharePopView *sharePopView;     ///< 分享
@property (nonatomic, strong) CBOnlineUserView *onlineUserView; ///< 在线用户

@property (nonatomic, strong) CBLiveGiftViewVC *liveGiftView;   ///< 礼物系统
// 键盘关闭功能
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGR;


@end

@implementation CBLiveChatViewVC

- (void)dealloc {
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setLiveVO:(CBAppLiveVO *)liveVO {
    _liveVO = liveVO;
    
    [self.view addSubview:self.headerListView];
    [self.view addSubview:self.guardianListView];
    [self.view addSubview:self.chatview];
    [self.view addSubview:self.closeButton];
    
    @weakify(self);
    [self addChildViewController:self.liveGiftView];
    [self.view addSubview:self.liveGiftView.view];
    [self.liveGiftView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
        make.top.offset(kScreenHeight);
    }];
}

- (void)joinChatRoom {

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
    
    
    [self setupForDismissKeyboard];
}

- (void)leaveChatRoom {
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

- (void)didSelectGiftButton {
    self.chatview.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.liveGiftView.view.origin = CGPointMake(0, 0);
    }];
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
//    EaseHeartFlyView* heart = [[EaseHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, 55, 50)];
//    [_chatview addSubview:heart];
//    CGPoint fountainSource = CGPointMake(kScreenWidth - (20 + 50/2.0), _chatview.height);
//    heart.center = fountainSource;
//    [heart animateInView:_chatview];
}

- (void)actionCloseButton {
    //    [self.playerManager.mediaPlayer.player.view removeFromSuperview];
    //    [self.playerManager.controlVC.view removeFromSuperview];
    //    [self.playerManager.mediaPlayer.player shutdown];
    //    self.playerManager.mediaPlayer = nil;
    //    self.playerManager = nil;
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerPlaybackDidFinishNotification object:nil];
    
//    [self _UI_LeaveChatRoom];
    
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

//关闭礼物界面
- (void)closeGiftView{
    [UIView animateWithDuration:0.5 animations:^{
        self.liveGiftView.view.origin = CGPointMake(0, kScreenHeight);
    }];
    self.chatview.hidden = NO;
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

#pragma mark - lazy

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

- (CBAnchorInfoView *)anchorInfoView {
    if (!_anchorInfoView) {
        CGFloat height = 365;
        if (iPhoneX) height += SafeAreaBottomHeight;
        _anchorInfoView = [[CBAnchorInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height
                                                                             )];
    }
    return _anchorInfoView;
}

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

//- (CBOnlineUserView *)onlineUserView {
//    if (!_onlineUserView) {
//        _onlineUserView = [[CBOnlineUserView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2) room:_liveVO];
//    }
//    return _onlineUserView;
//}

- (CBSharePopView *)sharePopView {
    if (!_sharePopView) {
        CGFloat height = 180;
        if (iPhoneX) { height += 35;}
        _sharePopView = [[CBSharePopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    }
    return _sharePopView;
}

- (CBLiveGiftViewVC *)liveGiftView {
    if (!_liveGiftView) {
        _liveGiftView = [CBLiveGiftViewVC new];
    }
    return _liveGiftView;
}

@end
