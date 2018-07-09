//
//  EaseChatView.m
//  UCloudMediaRecorderDemo
//
//  Created by EaseMob on 16/5/9.
//  Copyright © 2016年 zilong.li All rights reserved.
//

#import "EaseChatView.h"
#import "EaseInputTextView.h"
#import "EaseChatCell.h"
#import "EaseLiveRoom.h"
#import "CBAppLiveVO.h"

#import "TSCChatModel.h"
#import "TSCChatViewCell.h"
#import "TSCSystemMsgCell.h"

#define kGiftAction @"cmd_gift"
#define kPraiseAction @"cmd_live_praise"
#define kPraiseCount @"live_praise_count"

#define kBarrageAction @"is_barrage_msg"

#define kButtonWitdh 50
#define kButtonHeight 50

#define kDefaultSpace 5.f
#define kDefaulfLeftSpace 10.f

@interface EaseChatView () <EMChatManagerDelegate,EMChatroomManagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,EMFaceDelegate>
{
    long long _curtime;
    CGFloat _previousTextViewContentHeight;
    CGFloat _defaultHeight;
}

@property (nonatomic, strong) CBAppLiveVO *room;        ///< 业务聊天室
@property (nonatomic, strong) EMChatroom *chatroom;     ///< 环信聊天室数据
@property (nonatomic, copy)   NSString *chatroomId;     ///< 聊天室
@property (nonatomic, assign) NSInteger praiseCount;    ///< 点赞数量

// 聊天功能
@property (strong, nonatomic) EMConversation *conversation;
@property (strong, nonatomic) NSMutableArray <TSCChatModel *> *datasource;  ///< 聊天数据
@property (strong, nonatomic) UITableView *tableView;       ///< 聊天消息界面
@property (strong, nonatomic) EaseInputTextView *textView;  ///< 键盘输入框
@property (strong, nonatomic) UIView *bottomSendMsgView;    ///< 底部输入框容器
@property (strong, nonatomic) UIButton *faceButton;         ///< 表情按钮
@property (strong, nonatomic) UIView *faceView;             ///< 表情容器
@property (strong, nonatomic) UIView *activityView;

// 菜单按钮
@property (strong, nonatomic) UIButton *menuBtn;            ///< 菜单按钮
@property (strong, nonatomic) UIButton *adminButton;        ///< 管理员界面
// 底部功能按钮
@property (strong, nonatomic) UIButton *sendTextBtn;     ///< 发送消息
@property (strong, nonatomic) UIButton *roseBtn;         ///< 玫瑰花
@property (strong, nonatomic) UIButton *giftBtn;            ///< 礼物
@property (strong, nonatomic) UIButton *directMessagesBtn;  ///< 私信
@property (strong, nonatomic) UIButton *shareBtn;           ///< 分享
@property (strong, nonatomic) UIButton *joinVipBtn;         ///< 加入Vip
// 主播端
@property (strong, nonatomic) UIButton *changeCameraBtn; ///< 摄像头颠倒
@property (strong, nonatomic) UIButton *faceUnityBeautyBtn; ///< 美颜按钮
@property (strong, nonatomic) UIButton *faceUnityPropBtn; ///< 道具按钮
@property (strong, nonatomic) UIButton *likeButton;         ///< 喜欢按钮

@end

static NSString * chatCellId = @"TSCChatViewId";
static NSString * chatSystemMsgId = @"TSCSystemMsgId";


@implementation EaseChatView

- (instancetype)initWithFrame:(CGRect)frame chatroomId:(NSString*)chatroomId {
    return [self initWithFrame:frame chatroomId:chatroomId isPublish:NO];
}

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO*)room isPublish:(BOOL)isPublish {
    self = [self initWithFrame:frame chatroomId:room.leancloud_room isPublish:isPublish];
    if (self) {
        self.room = room;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame chatroomId:(NSString*)chatroomId isPublish:(BOOL)isPublish {
    self = [super initWithFrame:frame];
    if (self) {
        _chatroomId = chatroomId;
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];

        self.conversation = [[EMClient sharedClient].chatManager getConversation:_chatroomId type:EMConversationTypeChatRoom createIfNotExist:NO];

        // 聊天列表
        self.datasource = [NSMutableArray array];
        [self addSubview:self.tableView];
        //底部消息发送按钮
        [self addSubview:self.bottomSendMsgView];
        [self.bottomSendMsgView addSubview:self.textView];
        [self.bottomSendMsgView addSubview:self.faceButton];
        
        [self _setup_UI_isAnchor:isPublish];
        
        self.bottomSendMsgView.hidden = YES;
        _curtime = (long long)([[NSDate date] timeIntervalSince1970]*1000);
        _defaultHeight = self.height;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}


- (void)setDelegate:(id<EaseChatViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (!hidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(easeChatViewDidChangeFrameToHeight:)]) {
            CGFloat toHeight = self.frame.size.height;
            [self.delegate easeChatViewDidChangeFrameToHeight:toHeight];
        }
    }
}

- (void)dealloc {
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 设置UI
- (void)_setup_UI_isAnchor:(BOOL)isAnchor {
    if (isAnchor) {
        // 主播端
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.sendTextBtn];
        [self.bottomView addSubview:self.giftBtn];
        [self.bottomView addSubview:self.directMessagesBtn];
        [self.bottomView addSubview:self.shareBtn];
        
        [self.bottomView addSubview:self.changeCameraBtn];
        [self.bottomView addSubview:self.faceUnityBeautyBtn];
        [self.bottomView addSubview:self.faceUnityPropBtn];
        
        self.sendTextBtn.frame = CGRectMake(10, 8, 34, 34);
        self.giftBtn.frame  = CGRectMake(self.sendTextBtn.right+10, 8, 34, 34);
        self.directMessagesBtn.frame = CGRectMake(self.giftBtn.right+10, 8, 34, 34);
        self.shareBtn.frame = CGRectMake(self.directMessagesBtn.right+10, 8, 34, 34);
        self.changeCameraBtn.frame = CGRectMake(kScreenWidth-44, 8, 34, 34);
        self.faceUnityBeautyBtn.frame = CGRectMake(kScreenWidth-44-44, 8, 34, 34);
        self.faceUnityPropBtn.frame = CGRectMake(kScreenWidth-44-44-44, 8, 34, 34);
    } else {
        // 观众端
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.sendTextBtn];
        [self.bottomView addSubview:self.roseBtn];
        [self.bottomView addSubview:self.giftBtn];
        [self.bottomView addSubview:self.directMessagesBtn];
        [self.bottomView addSubview:self.shareBtn];
        [self.bottomView addSubview:self.joinVipBtn];
        
        self.sendTextBtn.frame = CGRectMake(10, 8, 34, 34);
        self.roseBtn.frame = CGRectMake(self.sendTextBtn.right+10, 8, 34, 34);
        self.giftBtn.frame  = CGRectMake(self.roseBtn.right+10, 8, 34, 34);
        self.directMessagesBtn.frame = CGRectMake(self.giftBtn.right+10, 8, 34, 34);
        self.shareBtn.frame = CGRectMake(self.directMessagesBtn.right+10, 8, 34, 34);
    }
}

#pragma mark - EMChatManagerDelegate
// 聊天收到消息
- (void)messagesDidReceive:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        if ([message.conversationId isEqualToString:self.chatroomId]) {
            if ([message.ext objectForKey:kBarrageAction]) {
                if (message.timestamp < _curtime) {
                    continue;
                }
                if (_delegate && [_delegate respondsToSelector:@selector(didReceiveBarrageWithCMDMessage:)]) {
                    [_delegate didReceiveBarrageWithCMDMessage:message];
                }
            } else {
                if ([self.datasource count] >= 200) {
                    [self.datasource removeObjectsInRange:NSMakeRange(0, 190)];
                }
                NSDictionary *dictDate = message.ext;
                TSCChatModel *model = [[TSCChatModel alloc] initWithDictinary:dictDate];
                [self.datasource addObject:model];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.datasource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
}

// 聊天礼物收到消息
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    for (EMMessage *message in aCmdMessages) {
        if ([message.conversationId isEqualToString:self.chatroomId]) {
            if (message.timestamp < _curtime) {
                continue;
            }
            EMCmdMessageBody *body = (EMCmdMessageBody*)message.body;
            if (body) {
                if ([body.action isEqualToString:kGiftAction]) {
                    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveGiftWithCMDMessage:)]) {
                        [_delegate didReceiveGiftWithCMDMessage:message];
                    }
                }
                
                if ([body.action isEqualToString:kPraiseAction]) {
                    if (_delegate && [_delegate respondsToSelector:@selector(didReceivePraiseWithCMDMessage:)]) {
                        [_delegate didReceivePraiseWithCMDMessage:message];
                    }
                }
            }
        }
    }
}

#pragma mark - EMChatroomManagerDelegate

- (void)chatroomAdminListDidUpdate:(EMChatroom *)aChatroom
                        addedAdmin:(NSString *)aAdmin;
{
    if ([aChatroom.chatroomId isEqualToString:self.chatroomId]) {
        if ([aAdmin isEqualToString:[EMClient sharedClient].currentUsername]) {
            [self.bottomView addSubview:self.adminButton];
            [self layoutSubviews];
        }
    }
}

- (void)chatroomAdminListDidUpdate:(EMChatroom *)aChatroom
                      removedAdmin:(NSString *)aAdmin
{
    if ([aChatroom.chatroomId isEqualToString:self.chatroomId]) {
        if ([aAdmin isEqualToString:[EMClient sharedClient].currentUsername]) {
            [self.adminButton removeFromSuperview];
            [self layoutSubviews];
        }
    }
}

- (void)chatroomOwnerDidUpdate:(EMChatroom *)aChatroom
                      newOwner:(NSString *)aNewOwner
                      oldOwner:(NSString *)aOldOwner
{
    
}

#pragma  mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    EMMessage *message = [self.datasource objectAtIndex:indexPath.row];
//    return [EaseChatCell heightForMessage:message];
    return MAX(35, self.datasource[indexPath.row].cellHeight.integerValue+10);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *CellIdentifier = @"cell";
//    TSCChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[TSCChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    TSCChatModel *message = [self.datasource objectAtIndex:indexPath.row];
////    [cell setMesssage:message];
//    cell.model = message;
//    return cell;
    
    if(self.datasource[indexPath.row].type.integerValue == 1){
        TSCSystemMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:chatSystemMsgId];
        cell.model = self.datasource[indexPath.row];
        return cell;
    }else{
        TSCChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCellId];
        cell.model = self.datasource[indexPath.row];
        return cell;
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.faceButton.selected = NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    EMMessage *message = [self.datasource objectAtIndex:indexPath.row];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectUserWithMessage:)]) {
//        [self.delegate didSelectUserWithMessage:message];
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length > 0 && [text isEqualToString:@"\n"]) {
        [self sendText];
        [self textViewDidChange:self.textView];
        return NO;
    }
    [self textViewDidChange:self.textView];
    return YES;
}

#pragma mark - EMFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.textView.text;
    
    if (!isDelete && str.length > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    } else {
        if (chatText.length > 0) {
            NSInteger length = 1;
            if (chatText.length >= 2) {
                NSString *subStr = [chatText substringFromIndex:chatText.length-2];
                if ([EaseEmoji stringContainsEmoji:subStr]) {
                    length = 2;
                }
            }
            self.textView.text = [chatText substringToIndex:chatText.length-length];
        }
    }
    [self textViewDidChange:self.textView];
}

- (void)sendFace
{
    NSString *chatText = self.textView.text;
    if (chatText.length > 0) {
        [self sendText];
        self.textView.text = @"";
    }
    [self textViewDidChange:self.textView];
}

- (void)sendFaceWithEmotion:(EaseEmotion *)emotion
{

}

#pragma mark - UIKeyboardNotification

- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.activityView) {
        [self _willShowBottomView:nil];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(easeChatViewDidChangeFrameToHeight:)]) {
        CGFloat toHeight = endFrame.size.height + self.frame.size.height + (self.textView.height - 30);
        [self.delegate easeChatViewDidChangeFrameToHeight:toHeight];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self _willShowBottomView:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:textView] refresh:NO];
}

+ (NSString *)latestMessageTitleForConversationModel:(EMMessage*)lastMessage;
{
    NSString *latestMessageTitle = @"";
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = ((EMTextMessageBody *)messageBody).text;
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[语音]";
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
    }
    latestMessageTitle = [NSString stringWithFormat:@"%@: %@",lastMessage.from,latestMessageTitle];
    return latestMessageTitle;
}

#pragma mark - private

- (EMMessage *)_sendTextMessage:(NSString *)text
                             to:(NSString *)toUser
                    messageType:(EMChatType)messageType
                     messageExt:(NSDictionary *)messageExt

{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

- (EMMessage *)_sendCMDMessageTo:(NSString *)toUser
                     messageType:(EMChatType)messageType
                      messageExt:(NSDictionary *)messageExt
                          action:(NSString*)action

{
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:action];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

// 设置当前是否处于发送消息状态
- (void)_setSendState:(BOOL)state {
    if (state) {
        self.bottomSendMsgView.hidden = NO;
        self.bottomView.hidden = YES;
        [self.textView becomeFirstResponder];
    } else {
        self.bottomSendMsgView.hidden = YES;
        self.bottomView.hidden = NO;
        [self.textView resignFirstResponder];
    }
}

- (void)_willShowBottomView:(UIView *)bottomView
{
    if (![self.activityView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        if (bottomView != nil) {
            self.height = bottomHeight + _defaultHeight + (self.textView.height - 30);
        } else {
            self.height = bottomHeight + _defaultHeight;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(easeChatViewDidChangeFrameToHeight:)]) {
            [self.delegate easeChatViewDidChangeFrameToHeight:self.height];
        }
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.bottomSendMsgView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        if (self.activityView) {
            [self.activityView removeFromSuperview];
        }
        self.activityView = bottomView;
    }
}

- (void)_setupEmotion
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *emotion = [emotions objectAtIndex:0];
    EaseEmotionManager *manager= [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:emotion.emotionId]];
    [(EaseFaceView *)self.faceView setEmotionManagers:@[manager]];
}

- (CGFloat)_getTextViewContentH:(UITextView *)textView {
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}

- (void)_willShowInputTextViewToHeight:(CGFloat)toHeight refresh:(BOOL)refresh
{
    if (toHeight < 30.f) {
        toHeight = 30.f;
    }
    if (toHeight > 90.f) {
        toHeight = 90.f;
    }
    
    if (toHeight == _previousTextViewContentHeight && !refresh) {
        return;
    } else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.bottomSendMsgView.frame;
        rect.size.height += changeHeight;
        self.bottomSendMsgView.frame = rect;
        [self.textView setContentOffset:CGPointMake(0.0f, (self.textView.contentSize.height - self.textView.frame.size.height) / 2) animated:YES];
        _previousTextViewContentHeight = toHeight;
    }
}

#pragma mark - public

- (BOOL)endEditing:(BOOL)force {
    BOOL result = [super endEditing:force];
    [self _willShowBottomView:nil];
    [self _setSendState:NO];
    self.faceButton.selected = NO;
    return result;
}

- (void)joinChatroomWithIsCount:(BOOL)aIsCount completion:(void (^)(BOOL success))aCompletion {
    @weakify(self);
    [[EaseHttpManager sharedInstance] joinLiveRoomWithRoomId:self.room.room_id chatroomId:self.room.leancloud_room isCount:aIsCount completion:^(BOOL success, id responseObject) {
        @strongify(self);
        BOOL ret = NO;
        if (success) {
            // 获取聊天室详情
            EMError *error = nil;
            self.chatroom = [[EMClient sharedClient].roomManager getChatroomSpecificationFromServerWithId:self.chatroomId error:&error];
            ret = YES;
            if (!error) {
                BOOL ret = self.chatroom.permissionType == EMChatroomPermissionTypeAdmin || self.chatroom.permissionType == EMChatroomPermissionTypeOwner;
                if (ret) {
                    [self.bottomView addSubview:self.adminButton];
                    [self layoutSubviews];
                }
            }            
            NSArray *msgAry = responseObject[@"data"][@"msg"];
            for (NSDictionary *dictMsg in msgAry) {
                NSDictionary *dictDate = @{@"name":dictMsg[@"title"],
                                           @"context":dictMsg[@"msg"],
                                           @"type":@1};
                TSCChatModel *model = [[TSCChatModel alloc] initWithDictinary:dictDate];
                [self.datasource addObject:model];
            }
            [self.tableView reloadData];
        }
        aCompletion(ret);
    }];
}

- (void)leaveChatroomWithIsCount:(BOOL)aIsCount
                      completion:(void (^)(BOOL success))aCompletion
{
    
    @weakify(self);
    [[EaseHttpManager sharedInstance] leaveLiveRoomWithRoomId:self.room.room_id chatroomId:self.room.leancloud_room isCount:aIsCount completion:^(BOOL success) {
        @strongify(self);
        BOOL ret = NO;
        if (success) {
            // 移除聊天数据
            [self.datasource removeAllObjects];
            [[EMClient sharedClient].chatManager deleteConversation:self.chatroomId isDeleteMessages:YES completion:NULL];
            ret = YES;
        }
        aCompletion(ret);
    }];
}

- (void)sendGiftWithId:(NSString*)giftId
{
    EMMessage *message = [self _sendCMDMessageTo:self.chatroomId messageType:EMChatTypeChatRoom messageExt:nil action:kGiftAction];
    @weakify(self);
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        @strongify(self);
        if (!error) {
            EMCmdMessageBody *body = (EMCmdMessageBody*)message.body;
            if (body) {
                if ([body.action isEqualToString:kGiftAction]) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveGiftWithCMDMessage:)]) {
                        [self.delegate didReceiveGiftWithCMDMessage:message];
                    }
                }
            }
        } else {
            //发送失败
        }
    }];
}

// 发送礼物消息
- (void)sendGiftDict:(NSDictionary *)giftDict {
    EMMessage *message = [self _sendCMDMessageTo:self.chatroomId messageType:EMChatTypeChatRoom messageExt:giftDict action:kGiftAction];
    @weakify(self);
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        @strongify(self);
        if (!error) {
            EMCmdMessageBody *body = (EMCmdMessageBody*)message.body;
            if (body) {
                if ([body.action isEqualToString:kGiftAction]) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveGiftWithCMDMessage:)]) {
                        [self.delegate didReceiveGiftWithCMDMessage:message];
                    }
                }
            }
        } else {
            //发送失败
        }
    }];
}

- (void)sendMessageAtWithUsername:(NSString *)username
{
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"@%@ ",username]];
    [self _setSendState:YES];
}


#pragma mark - action
// 消息按钮触发
- (void)actionSendTextBtn:(UIButton *)sender {
    [self _setSendState:YES];
    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.textView] refresh:YES];
}

// 私信按钮触发
- (void)actionDirectMessagesBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatView:actionTouchDirectMessageBtn:)]) {
        [self.delegate chatView:self actionTouchDirectMessageBtn:sender];
    }
}

// 礼物按钮触发
- (void)actionGiftBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatView:actionTouchGiftBtn:)]) {
        [self.delegate chatView:self actionTouchGiftBtn:sender];
    }
}

// 分享按钮触发
- (void)actionShareBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatView:actionTouchShareBtn:)]) {
        [self.delegate chatView:self actionTouchShareBtn:sender];
    }
}

// 菜单按钮触发
- (void)actionMenuBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatView:actionTouchMenuBtn:)]) {
        [self.delegate chatView:self actionTouchMenuBtn:sender];
    }
}

// FaceUnity美颜按钮触发
- (void)actionFaceUnityBeautyBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatView:actionTouchFaceUnityBeautyBtn:)]) {
        [self.delegate chatView:self actionTouchFaceUnityBeautyBtn:sender];
    }
}

// FaceUnity道具按钮触发
- (void)actionFaceUnityPropBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatView:actionTouchFaceUnityPropBtn:)]) {
        [self.delegate chatView:self actionTouchFaceUnityPropBtn:sender];
    }
}

// 旋转相机
- (void)actionChangeCameraBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatView:actionTouchChangeCameraBtn:)]) {
        [self.delegate chatView:self actionTouchChangeCameraBtn:sender];
    }
}

// 发送文本消息
- (void)sendText {
    if (self.textView.text.length > 0) {
        NSDictionary *userExt = @{
                                  @"userName":[CBLiveUserConfig myProfile].user_nicename,
                                  @"userLevel":[CBLiveUserConfig myProfile].user_level,
                                  @"context" : self.textView.text,
                                  @"type": @"0"
                                  };
        EMMessage *message = [self _sendTextMessage:self.textView.text to:self.chatroomId messageType:EMChatTypeChatRoom messageExt:userExt];
        __weak EaseChatView *weakSelf = self;
        [[EMClient sharedClient].chatManager sendMessage:message progress:NULL completion:^(EMMessage *message, EMError *error) {
            if (!error) {
                if ([weakSelf.datasource count] >= 200) {
                    [weakSelf.datasource removeObjectsInRange:NSMakeRange(0, 190)];
                }
                NSDictionary *dictDate = message.ext;
                TSCChatModel *model = [[TSCChatModel alloc] initWithDictinary:dictDate];
                [self.datasource addObject:model];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.datasource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            } else {
                [MBProgressHUD showError:@"消息发送失败" toView:weakSelf];
            }
        }];
        self.textView.text = @"";
    }
}

- (void)faceAction
{
    _faceButton.selected = !_faceButton.selected;
    
    if (_faceButton.selected) {
        [self.textView resignFirstResponder];
        [self _willShowBottomView:self.faceView];
    } else {
        [self.textView becomeFirstResponder];
    }
}

- (void)adminAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectAdminButton:)]) {
        BOOL isOwner = NO;
        if (self.chatroom && self.chatroom.permissionType == EMChatroomPermissionTypeOwner) {
            isOwner = YES;
        }
        [_delegate didSelectAdminButton:isOwner];
        _adminButton.selected = !_adminButton.selected;
    }
}

- (void)praiseAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_uploadPraiseCountToServer) object:nil];
    EMMessage *message = [self _sendCMDMessageTo:self.chatroomId messageType:EMChatTypeChatRoom messageExt:@{kPraiseCount:@(1)} action:kPraiseAction];
    @weakify(self);
    [[EMClient sharedClient].chatManager sendMessage:message progress:NULL completion:^(EMMessage *message, EMError *error) {
        @strongify(self);
        if (!error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didReceivePraiseWithCMDMessage:)]) {
                [self.delegate didReceivePraiseWithCMDMessage:message];
            }
            self.praiseCount++;
            [self performSelector:@selector(_uploadPraiseCountToServer) withObject:nil afterDelay:10.f];
        }
    }];
}

- (void)_uploadPraiseCountToServer {
    @weakify(self);
    [[EaseHttpManager sharedInstance] savePraiseCountToServerWithRoomId:self.room.room_id count:self.praiseCount completion:^(NSInteger count, BOOL success) {
        @strongify(self);
        if (success) {
            self.praiseCount = 0;
        }
    }];
}

#pragma mark - layz

// 消息表格
- (UITableView*)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth*0.7, CGRectGetHeight(self.bounds) - 48.f) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"TSCChatViewCell" bundle:nil] forCellReuseIdentifier:chatCellId];
        [_tableView registerNib:[UINib nibWithNibName:@"TSCSystemMsgCell" bundle:nil] forCellReuseIdentifier:chatSystemMsgId];
    }
    return _tableView;
}

// 菜单按钮
- (UIButton *)menuBtn {
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setImage:[UIImage imageNamed:@"live_notice-board"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(actionMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}

// 底部输入框容器
- (UIView*)bottomSendMsgView {
    if (_bottomSendMsgView == nil) {
        _bottomSendMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.bounds), 50.f)];
        _bottomSendMsgView.backgroundColor = RGBACOLOR(255, 255, 255, 1);
    }
    return _bottomSendMsgView;
}

// 键盘输入框
- (EaseInputTextView*)textView {
    if (_textView == nil) {
        //输入框
        _textView = [[EaseInputTextView alloc] initWithFrame:CGRectMake(kDefaulfLeftSpace, 10.f, CGRectGetWidth(self.bounds) - CGRectGetWidth(self.faceButton.frame) - kDefaulfLeftSpace*3, 30.f)];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.scrollEnabled = YES;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        _textView.placeHolder = NSLocalizedString(@"chat.input.placeholder", @"input a new message");
        _textView.delegate = self;
        _textView.backgroundColor = RGBACOLOR(236, 236, 236, 1);
        _textView.layer.cornerRadius = 4.0f;
        _previousTextViewContentHeight = [self _getTextViewContentH:_textView];
    }
    return _textView;
}

// 表情按钮
- (UIButton*)faceButton {
    if (_faceButton == nil) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 30 - kDefaulfLeftSpace, 10.f, 30, 30);
        [_faceButton setImage:[UIImage imageNamed:@"input_bar_1_icon_face"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"input_bar_1_icon_keyboard"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(faceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

// 表情容器
- (UIView*)faceView {
    if (_faceView == nil) {
        _faceView = [[EaseFaceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomSendMsgView.frame), self.frame.size.width, 180)];
        [(EaseFaceView *)_faceView setDelegate:self];
        _faceView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self _setupEmotion];
    }
    return _faceView;
}

// 管理员
- (UIButton*)adminButton {
    if (_adminButton == nil) {
        _adminButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_adminButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        [_adminButton addTarget:self action:@selector(adminAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adminButton;
}

// 底部菜单按钮容器控件
- (UIView*)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.bounds), kButtonHeight)];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

// 发生消息按钮
- (UIButton *)sendTextBtn {
    if (!_sendTextBtn) {
        _sendTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendTextBtn setImage:[UIImage imageNamed:@"live_barrage"] forState:UIControlStateNormal];
        [_sendTextBtn addTarget:self action:@selector(actionSendTextBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendTextBtn;
}

// 私信按钮
- (UIButton *)directMessagesBtn {
    if (!_directMessagesBtn) {
        _directMessagesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_directMessagesBtn setImage:[UIImage imageNamed:@"live_message"] forState:UIControlStateNormal];
        [_directMessagesBtn addTarget:self action:@selector(actionDirectMessagesBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _directMessagesBtn;
}

// 礼物按钮
- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setImage:[UIImage imageNamed:@"live_gift"] forState:UIControlStateNormal];
        [_giftBtn addTarget:self action:@selector(actionGiftBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftBtn;
}

// 分享按钮
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"live_share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(actionShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

// 摄像头颠倒
- (UIButton*)changeCameraBtn {
    if (!_changeCameraBtn) {
        _changeCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeCameraBtn setImage:[UIImage imageNamed:@"live_camera"] forState:UIControlStateNormal];
        [_changeCameraBtn addTarget:self action:@selector(actionChangeCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeCameraBtn;
}

// 美颜按钮
- (UIButton*)faceUnityBeautyBtn {
    if (!_faceUnityBeautyBtn) {
        _faceUnityBeautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceUnityBeautyBtn setImage:[UIImage imageNamed:@"live_beauty"] forState:UIControlStateNormal];
        [_faceUnityBeautyBtn addTarget:self action:@selector(actionFaceUnityBeautyBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceUnityBeautyBtn;
}

// 道具按钮
- (UIButton*)faceUnityPropBtn {
    if (!_faceUnityPropBtn) {
        _faceUnityPropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceUnityPropBtn setImage:[UIImage imageNamed:@"live_beauty"] forState:UIControlStateNormal];
        [_faceUnityPropBtn addTarget:self action:@selector(actionFaceUnityPropBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceUnityPropBtn;
}

// 喜欢按钮
- (UIButton*)likeButton {
    if (_likeButton == nil) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(praiseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

// 加入Vip按钮
- (UIButton *)joinVipBtn {
    if (!_joinVipBtn) {
        _joinVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinVipBtn.frame = CGRectMake(kScreenWidth-80, 0, 80, 50);
        [_joinVipBtn setImage:[UIImage imageNamed:@"live_joinVip"] forState:UIControlStateNormal];
        [_joinVipBtn addTarget:self action:@selector(actionShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinVipBtn;
}

// 玫瑰按钮
- (UIButton *)roseBtn {
    if (!_roseBtn) {
        _roseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_roseBtn setImage:[UIImage imageNamed:@"live_rose"] forState:UIControlStateNormal];
        [_roseBtn addTarget:self action:@selector(actionShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _roseBtn;
}

@end
