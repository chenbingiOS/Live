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
#import "CBContributionRankVC.h"
#import "CBLivePlayerVC.h"
#import "CBLiveVC.h"
#import "CBGuardVC.h"
// VO
#import "CBAppLiveVO.h"
#import "CBAnchorInfoVO.h"
// View
#import "CBLiveAnchorGiftRecordView.h"
#import "EaseChatView.h"
#import "EaseLiveHeaderListView.h"
#import "CBLiveGuardianListView.h"
#import "EaseProfileLiveView.h"
#import "CBAnchorInfoView.h"
#import "EaseAdminView.h"
#import "CBOnlineUserView.h"
#import "LiveGiftShowCustom.h"
#import "CBLiveAnchorGuardianListVC.h"
#import "CBNVC.h"
#import "CBPersonalHomePageVC.h"
#import "CBGuardView.h"
#import "CBRechargeView.h"
#import "huanxinsixinview.h"
#import "CBAnchorInfoXibView.h"
// Delegate
#import "CBActionLiveDelegate.h"
// Category
#import "UIViewController+SuperViewCtrl.h"
#import "BlocksKit.h"
#import "UIImageView+YYWebImage.h"

@interface CBLiveChatViewVC ()
<
    UIGestureRecognizerDelegate,
    EaseChatViewDelegate,
    EMClientDelegate,
    EMChatroomManagerDelegate,
    TapBackgroundViewDelegate,
    CBActionLiveDelegate,
    CBLiveGiftViewDelegate,
    LiveGiftShowCustomDelegate,
    CBActionLiveDelegate,
    AnchorInfoViewDelegate
>
{
    BOOL _enableAdmin;
}

@property (nonatomic, strong) UIButton *closeButton;                ///< 关闭按钮
@property (nonatomic, strong) EMChatroom *chatroom;                 ///< 房间UI
@property (nonatomic, strong) EaseChatView *chatview;               ///< 底部聊天
@property (nonatomic, strong) EaseLiveHeaderListView *headerListView;   ///< 顶部用户信息
@property (nonatomic, strong) CBLiveGuardianListView *guardianListView; ///<  顶部守护
@property (nonatomic, strong) CBAnchorInfoView *anchorInfoView;     ///< 直播用户信息
@property (nonatomic, strong) CBSharePopView *sharePopView;         ///< 分享
@property (nonatomic, strong) CBOnlineUserView *onlineUserView;     ///< 在线用户
@property (nonatomic, strong) CBLiveGiftViewVC *liveGiftView;       ///< 礼物系统
@property (nonatomic, strong) LiveGiftShowCustom *customGiftShow;   ///< 显示普通礼物
@property (nonatomic, strong) YYAnimatedImageView *showGifImageView; ///< 显示Gif礼物
@property (nonatomic, strong) CBLiveAnchorGiftRecordPopView *giftRecordPopView; ///< 礼物记录
@property (nonatomic, strong) CBRechargePopView *rechargeView;      ///< 充值
@property (nonatomic, strong) huanxinsixinview *huanxinviews;       ///< 私信
@property (nonatomic, strong) chatsmallview *chatsmall;             ///< 私信
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forsixin:) name:@"sixinok" object:nil];
}

- (void)setLiveVO:(CBAppLiveVO *)liveVO {
    _liveVO = liveVO;
    
    [self.view addSubview:self.headerListView];
    [self.view addSubview:self.guardianListView];
    [self.view addSubview:self.chatview];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.showGifImageView];

    @weakify(self);
    [self addChildViewController:self.liveGiftView];
    [self.view addSubview:self.liveGiftView.view];
    [self.liveGiftView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
        make.top.offset(kScreenHeight);
    }];
    self.liveGiftView.superController = self;
}

- (void)joinChatRoom {    
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    @weakify(self);
    [self.chatview joinChatroomWithIsCount:YES completion:^(BOOL success) {
        @strongify(self);
        if (success) {
            self.chatroom = [[EMClient sharedClient].roomManager getChatroomSpecificationFromServerWithId:self.liveVO.leancloud_room error:nil];
            [self.headerListView loadHeaderListWithChatroomId:[self.liveVO.leancloud_room copy]];
            [self.guardianListView loadHeaderListWithChatroomId:[self.liveVO.leancloud_room copy]];
        } else {
            [MBProgressHUD showAutoMessage:@"加入聊天室失败"];
        }
    }];
    
    self.chatview.delegate = self;
    [self setupForDismissKeyboard];
}

- (void)leaveChatRoom {
    @weakify(self);
    [self.chatview leaveChatroomWithIsCount:YES completion:^(BOOL success) {
        @strongify(self);
        if (success) {
            [[EMClient sharedClient].chatManager deleteConversation:self.liveVO.leancloud_room isDeleteMessages:YES completion:NULL];
        } else {
            [MBProgressHUD showAutoMessage:@"离开聊天室失败"];
        }
    }];
    
    [self.headerListView cancelRequest];
    [self.guardianListView cancelRequest];
    self.headerListView = nil;
    self.guardianListView = nil;
    self.chatview = nil;
    self.closeButton = nil;
    self.liveGiftView = nil;
}

#pragma mark - AnchorInfoViewDelegate
// 主播页面点击主页
- (void)anchorInfoXibView:(CBAnchorInfoXibView *)infoXibView actionTouchHomeBtn:(UIButton *)btn {
    CBPersonalHomePageVC *vc = [[CBPersonalHomePageVC alloc] initWithLiveVO:self.liveVO];
    CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

// 主播页面点击私信
- (void)anchorInfoXibView:(CBAnchorInfoXibView *)infoXibView actionTouchMessageBtn:(UIButton *)btn {
    if (!_chatsmall) {
        _chatsmall = [[chatsmallview alloc]init];
        _chatsmall.view.frame = CGRectMake(0, kScreenHeight*5, kScreenWidth, kScreenHeight*0.4);
        [self.view addSubview:_chatsmall.view];
        _chatsmall.view.hidden = YES;
    }
    _chatsmall.view.hidden = NO;
    @weakify(self);
    [UIView animateWithDuration:1.0 animations:^{
        @strongify(self);
        self.chatsmall.view.frame = CGRectMake(0, kScreenHeight-kScreenHeight*0.4, kScreenWidth, kScreenHeight*0.4);
    }];
    _chatsmall.chatID = infoXibView.infoVO.user.hx_uid;
    _chatsmall.chatname = infoXibView.infoVO.user.user_nicename;
    _chatsmall.icon = infoXibView.infoVO.user.avatar;
    NSDictionary *subdic = [NSDictionary dictionaryWithObject:infoXibView.infoVO.user.hx_uid forKey:@"uid"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chatsmall" object:nil userInfo:subdic];
}

//点击用户聊天
-(void)forsixin:(NSNotification *)ns{
    if (!_chatsmall) {
        _chatsmall = [[chatsmallview alloc]init];
        _chatsmall.view.frame = CGRectMake(0, kScreenHeight*5, kScreenWidth, kScreenHeight*0.4);
        [self.view addSubview:_chatsmall.view];
        _chatsmall.view.hidden = YES;
    }
    _chatsmall.view.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        self.chatsmall.view.frame = CGRectMake(0, kScreenHeight-kScreenHeight*0.4, kScreenWidth, kScreenHeight*0.4);
    }];
    NSDictionary *dic = [ns userInfo];
    _chatsmall.chatID = [dic valueForKey:@"id"];
    _chatsmall.chatname = [dic valueForKey:@"name"];
    _chatsmall.icon = [dic valueForKey:@"icon"];
    NSDictionary *subdic = [NSDictionary dictionaryWithObject:[dic valueForKey:@"id"] forKey:@"uid"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chatsmall" object:nil userInfo:subdic];
}

#pragma mark - CBActionLiveDelegate
// 显示主播信息
- (void)actionLiveShowAnchorInfo {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.anchorInfoView showIn:window];
    self.anchorInfoView.liveVO = _liveVO;
}

// 关注当前用户
- (void)actionLiveAttentionCurrentAnchor {
    
}

// 开通守护
- (void)actionLiveOpenGuard {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CBGuardView *v = [[CBGuardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.75)];
    [v loadRequestWithAnchorId:self.liveVO.ID];
    [v showIn:window];
}

// 显示在线用户列表
- (void)actionLiveShowOnlineUserList {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [self.onlineUserView showIn:window];
}

// 显示贡献榜
- (void)actionLiveShowContributionList {
    CBContributionRankVC *vc = [CBContributionRankVC new];
    CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

// 显示守护榜
- (void)actionLiveShowGrardianList {
    CBLiveAnchorGuardianListVC *vc = [CBLiveAnchorGuardianListVC new];
    CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - EaseLiveHeaderListViewDelegate
// 选中头像
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
// 收到礼物消息
- (void)didReceiveGiftWithCMDMessage:(EMMessage *)message {
    NSLog(@"收到礼物 Ext %@", message.ext);
    CBChatGiftMessageVO *msgVO = [CBChatGiftMessageVO modelWithJSON:message.ext];
    if (msgVO.giftSwf.length > 0) {
        self.showGifImageView.hidden = NO;
        [self.view addSubview:self.showGifImageView];
        if ([msgVO.swfplay isEqualToString:@"2"]) {
            self.showGifImageView.frame = CGRectMake(0, SafeAreaTopHeight, kScreenWidth, kScreenHeight-SafeAreaTopHeight-SafeAreaBottomHeight);
        }
        @weakify(self);
        [self.showGifImageView setImageWithURL:[NSURL URLWithString:msgVO.giftSwf] placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            @strongify(self);
            self.showGifImageView.image = image;
        }];
        [self.showGifImageView bk_addObserverForKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld task:^(id obj, NSDictionary *change) {
            @strongify(self);
            NSNumber *newV =  change[@"new"];
            if ([newV isEqualToNumber:@0] ) {
                [self.showGifImageView stopAnimating];
                self.showGifImageView.hidden = YES;
                [self.showGifImageView removeFromSuperview];
            }
        }];
    } else {
        LiveGiftShowModel *model = [LiveGiftShowModel instancetypeGiftVOByGiftMessage:msgVO];
//        model.toNumber = msgVO.giftNum.integerValue;
        [self.customGiftShow animatedWithGiftModel:model];
    }
}

- (void)easeChatViewDidChangeFrameToHeight:(CGFloat)toHeight {
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

- (void)didReceivePraiseWithCMDMessage:(EMMessage *)message {
    [self showTheLoveAction];
}

// 选择用户，某一条消息
- (void)didSelectUserWithMessage:(EMMessage *)message {
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

// 选择管理员按钮
- (void)didSelectAdminButton:(BOOL)isOwner {
    EaseAdminView *adminView = [[EaseAdminView alloc] initWithChatroomId:self.liveVO.leancloud_room isOwner:isOwner];
    adminView.delegate = self;
    [adminView showFromParentView:self.view];
}

// 选择分享按钮
- (void)chatView:(EaseChatView *)chatView actionTouchShareBtn:(UIButton *)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.sharePopView showIn:window];
}

// 选择礼物按钮
- (void)chatView:(EaseChatView *)chatView actionTouchGiftBtn:(UIButton *)sender {
    if (self.isAnchor) {
        // 主播显示礼物赠送记录
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [self.giftRecordPopView showIn:window];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.liveGiftView.view.origin = CGPointMake(0, 0);
        }];
    }
}

// 选择菜单按钮
- (void)chatView:(EaseChatView *)chatView actionTouchMenuBtn:(UIButton *)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.rechargeView showIn:window];
}

// 美颜按钮
- (void)chatView:(EaseChatView *)chatView actionTouchFaceUnityBeautyBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveChatViewVC:actionTouchFaceUnityBeautyBtn:)]) {
        [self.delegate liveChatViewVC:self actionTouchFaceUnityBeautyBtn:sender];
    }
}

// 道具按钮
- (void)chatView:(EaseChatView *)chatView actionTouchFaceUnityPropBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveChatViewVC:actionTouchFaceUnityPropBtn:)]) {
        [self.delegate liveChatViewVC:self actionTouchFaceUnityPropBtn:sender];
    }
}

// 旋转相机
- (void)chatView:(EaseChatView *)chatView actionTouchChangeCameraBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveChatViewVC:actionTouchChangeCameraBtn:)]) {
        [self.delegate liveChatViewVC:self actionTouchChangeCameraBtn:sender];
    }
}

// 私信按钮
- (void)chatView:(EaseChatView *)chatView actionTouchDirectMessageBtn:(UIButton *)sender {
    if (!_huanxinviews) {
        _huanxinviews = [[huanxinsixinview alloc]init];
        _huanxinviews.view.frame = CGRectMake(0, kScreenHeight*5, kScreenWidth, kScreenHeight*0.4);
        [self.view addSubview:_huanxinviews.view];
    }
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self);
        self.huanxinviews.view.frame = CGRectMake(0, kScreenHeight - kScreenHeight*0.4,kScreenWidth, kScreenHeight*0.4);
    }];
}

#pragma mark - CBLiveGiftViewDelegate

// 礼物选择
- (void)actionLiveSentGiftDict:(NSDictionary *)giftDict {
    if (self.chatview) {
        [self.chatview sendGiftDict:giftDict];
    }
}

- (void)giftDidRemove:(LiveGiftShowModel *)showModel {
    WLog(@"用户：%@ 送出了 %li 个 %@", showModel.user.name, showModel.currentNumber, showModel.giftModel.name);
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
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"被踢出直播聊天室" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KNotificationCloseLiveVC" object:nil];
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
}

#pragma mark - override

- (void)setupForDismissKeyboard {
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
        _chatview = [[EaseChatView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), 200) room:_liveVO isPublish:_isAnchor];
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
        _anchorInfoView.delelgate = self;
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

- (CBSharePopView *)sharePopView {
    if (!_sharePopView) {
        CGFloat height = 180;
        if (iPhoneX) { height += 35;}
        _sharePopView = [[CBSharePopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    }
    return _sharePopView;
}

- (CBRechargePopView *)rechargeView {
    if (!_rechargeView) {
        CGFloat height = 295;
        if (iPhoneX) { height += 35;}
        _rechargeView = [[CBRechargePopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    }
    return _rechargeView;
}

- (CBLiveGiftViewVC *)liveGiftView {
    if (!_liveGiftView) {
        _liveGiftView = [CBLiveGiftViewVC new];
        _liveGiftView.delegate = self;
    }
    return _liveGiftView;
}

/* 礼物视图支持很多配置属性，开发者按需选择。*/
- (LiveGiftShowCustom *)customGiftShow{
    if (!_customGiftShow) {
        _customGiftShow = [LiveGiftShowCustom addToView:self.view];
        _customGiftShow.addMode = LiveGiftAddModeAdd;
        [_customGiftShow setMaxGiftCount:2];
        [_customGiftShow setShowMode:LiveGiftShowModeFromBottomToTop];
        [_customGiftShow setAppearModel:LiveGiftAppearModeLeft];
        [_customGiftShow setHiddenModel:LiveGiftHiddenModeNone];
//        [_customGiftShow enableInterfaceDebug:YES];
        _customGiftShow.delegate = self;
        
        _customGiftShow.backgroundColor = [UIColor redColor];
    }
    return _customGiftShow;
}

- (YYAnimatedImageView *)showGifImageView {
    if (!_showGifImageView) {
        _showGifImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        _showGifImageView.centerX = self.view.centerX;
        _showGifImageView.centerY = kScreenHeight*0.35;
    }
    return _showGifImageView;
}

// 主播礼物列表
- (CBLiveAnchorGiftRecordPopView *)giftRecordPopView {
    if (!_giftRecordPopView) {
        CGFloat height = kScreenHeight*0.75+SafeAreaBottomHeight;
        _giftRecordPopView = [[CBLiveAnchorGiftRecordPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    }
    return _giftRecordPopView;
}

// 在线用户
- (CBOnlineUserView *)onlineUserView {
    if (!_onlineUserView) {
        _onlineUserView = [[CBOnlineUserView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2) room:_liveVO];
    }
    return _onlineUserView;
}

@end
