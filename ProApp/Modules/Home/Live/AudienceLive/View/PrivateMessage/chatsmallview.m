#import "chatsmallview.h"
#import "chatmessageModel.h"
#import "chatmessageCell.h"
#import "AFHTTPSessionManager.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
@implementation chatsmallview
static int a = 0;
static int newHeight;
-(instancetype)init{
    self = [super init];
    if (self) {
        sendok = 1;
        self.view.userInteractionEnabled = YES;
        
        [self getnew];
        [self setview];
        self.chatothsersattention = nil;
        self.chatothsersattention  = [NSString string];
//        //判断是否关注
//        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//        NSString *userBaseUrl = [purl stringByAppendingFormat:@"?service=User.getPmUserInfo&uid=%@&touid=%@",[Config getOwnID],self.chatID];
//        [session GET:userBaseUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSNumber *number = [responseObject valueForKey:@"ret"] ;
//            if([number isEqualToNumber:[NSNumber numberWithInt:200]])
//            {
//                NSArray *data = [responseObject valueForKey:@"data"];
//                NSNumber *code = [data valueForKey:@"code"];
//                if([code isEqualToNumber:[NSNumber numberWithInt:0]])
//                {
//                    NSDictionary *info = [[data valueForKey:@"info"] firstObject];
//                    self.chatothsersattention = [info valueForKey:@"isattention2"];
//                }
//            }
//            else
//            {
//                
//            }
//        }
//             failure:^(NSURLSessionDataTask *task, NSError *error)
//         {
//         }];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(formessage:) name:@"chatsmall" object:nil];
        
    }
    return self;
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"chatsmall" object:nil];
}
-(void)getnew{
    [conversation markAllMessagesAsRead:nil];
}

-(void)formessage{
    [testActivityIndicator startAnimating]; // 开始旋转
    self.emojyArray = [NSArray array];
    self.allArray = nil;
    self.allArray = [NSMutableArray array];
    [self.tableView reloadData];
    self.emojyArray = [self defaultEmoticons];
    labell.text = self.chatname;
    
    conversation =  [[EMClient sharedClient].chatManager getConversation:self.chatID type:EMConversationTypeChat createIfNotExist:YES];
    [conversation markAllMessagesAsRead:nil];
    [conversation loadMessagesStartFromId:nil count:40 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        for (EMMessage *emm in aMessages) {
            EMMessageBody *msgBody = emm.body;
            switch (msgBody.type) {
                case EMMessageBodyTypeText:
                {
                    // 收到的文字消息
                    EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                    NSString *txt = textBody.text;
                    int direction;
                    if (emm.direction == 1) {
                        direction =1;
                        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.icon,txt,[NSString stringWithFormat:@"%d",direction]] forKeys:@[@"avatar",@"text",@"type"]];
                        [self.allArray addObject:dic];
                        
                    }
                    else
                    {
                        CBLiveUser *user = [CBLiveUserConfig myProfile];
//                        LiveUser *user = [Config myProfile];
                        direction =0;
                        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[user.avatar,txt,[NSString stringWithFormat:@"%d",direction]] forKeys:@[@"avatar",@"text",@"type"]];
                        [self.allArray addObject:dic];
                    }
                    
                    [self.tableView reloadData];
                    [self jumpLast];
                }
                    [testActivityIndicator stopAnimating]; // 结束旋转
                    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
            }
        }
    }];
    
    
    
    
}

-(void)formessage:(NSNotification *)uid{
    [testActivityIndicator startAnimating]; // 开始旋转
    
    NSDictionary *subdic = [uid userInfo];
    self.emojyArray = [self defaultEmoticons];
    labell.text = self.chatname;
    //创建会话
    NSString *strid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"uid"]];
    
    self.chatID = strid;
    
    NSLog(@"----snfbnahbhabjbhabfbjhbfhbajfbabf-----------------%@",self.chatID);
    
    self.allArray = nil;
    self.allArray = [NSMutableArray array];
    [self.tableView reloadData];
    
    NSLog(@"666666666");
    //获取历史纪录
    conversation =  [[EMClient sharedClient].chatManager getConversation:self.chatID type:EMConversationTypeChat createIfNotExist:YES];
    [conversation markAllMessagesAsRead:nil];
    [conversation loadMessagesStartFromId:nil count:40 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        for (EMMessage *emm in aMessages) {
            EMMessageBody *msgBody = emm.body;
            switch (msgBody.type) {
                case EMMessageBodyTypeText:
                {
                    // 收到的文字消息
                    EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                    NSString *txt = textBody.text;
                    int direction;
                    if (emm.direction == 1) {
                        direction =1;
                        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.icon,txt,[NSString stringWithFormat:@"%d",direction]] forKeys:@[@"avatar",@"text",@"type"]];
                        [self.allArray addObject:dic];
                        
                    }
                    else
                    {
                        
//                        LiveUser *user = [Config myProfile];
                        CBLiveUser *user = [CBLiveUserConfig myProfile];
                        direction =0;
                        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[user.avatar,txt,[NSString stringWithFormat:@"%d",direction]] forKeys:@[@"avatar",@"text",@"type"]];
                        [self.allArray addObject:dic];
                    }
                    
                    [self.tableView reloadData];
                    [self jumpLast];
                }
                    [testActivityIndicator stopAnimating]; // 结束旋转
                    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
            }
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }];
    
    
}
-(NSArray *)models{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *sub_dic in self.allArray) {
        chatmessageModel *model = [chatmessageModel messageWithDic:sub_dic];
        [model setMessageFrame:[array lastObject]];
        [array addObject:model];
    }
    
    _models = array;
    return _models;
    
}
//获取默认表情数组
- (NSArray *)defaultEmoticons {
    
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            emoT = [emoT stringByReplacingOccurrencesOfString:@"/" withString:@""];
            
            [array addObject:emoT];
            
        }
    }
    
    return array;
    
}
-(void)doReturn{
    sendok = 1;
    
    [_textField resignFirstResponder];
    [conversation markAllMessagesAsRead:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gengxinweidu" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMessageIM" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toolbarHidden" object:nil];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.view.frame = CGRectMake(0, kScreenHeight*3, kScreenWidth, kScreenHeight*0.4);
        
    }];
    
}
-(void)setview{
    sendok = 1;
    
    [self formessage];
    //表情
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UICollectionViewFlowLayout *Flowlayout = [[UICollectionViewFlowLayout alloc]init];
    
    Flowlayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth*3, kScreenHeight*0.3) collectionViewLayout:Flowlayout];
    
    Flowlayout.minimumLineSpacing = 0;
    
    Flowlayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    Flowlayout.itemSize = CGSizeMake(kScreenWidth/8, kScreenHeight*0.3/4);
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.pagingEnabled = NO;
    
    self.collectionView.scrollEnabled = NO;
    
    self.collectionView.bounces = NO;
    
    //注册cell
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"emojy"];
    
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;
    
    self.collectionView.multipleTouchEnabled = NO;
    
    scrollbuttom = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.3)];
    scrollbuttom.contentSize = CGSizeMake(kScreenWidth*((self.emojyArray.count/32)+1), 0);
    scrollbuttom.pagingEnabled = YES;
    scrollbuttom.showsHorizontalScrollIndicator = NO;
    scrollbuttom.delegate = self;
    scrollbuttom.bounces = NO;
    scrollbuttom.backgroundColor = [UIColor clearColor];
    [scrollbuttom addSubview:self.collectionView];
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, kScreenWidth, kScreenHeight*0.4-80) style:UITableViewStylePlain];
    //    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo)];
    //    [self.tableView addGestureRecognizer:tapGesture];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentOffset = CGPointMake(0, kScreenHeight);
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    //去掉分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //禁止选中
    _tableView.allowsSelection = NO;
    
    self.tableView.scrollEnabled = YES;
    
    mview = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight*0.4 - 40,kScreenWidth,44)];
    mview.backgroundColor = [UIColor clearColor];
    mview.userInteractionEnabled = YES;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10,5,mview.frame.size.width - 20, 30)];
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.userInteractionEnabled = YES;
    emjoyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [emjoyBtn setTintColor:[UIColor whiteColor]];
    [emjoyBtn setImage:[UIImage imageNamed:@"chat_inputbar_emoji.png"] forState:UIControlStateNormal];
    emjoyBtn.frame = CGRectMake(kScreenWidth *0.7+10,5,kScreenWidth*0.08,kScreenWidth*0.08);
    [emjoyBtn addTarget:self action:@selector(emjoy:) forControlEvents:UIControlEventTouchUpInside];
    
    send = [UIButton buttonWithType:UIButtonTypeSystem];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    send.backgroundColor = [UIColor colorWithRed:255/255.0 green:211/255.0 blue:80/255.0 alpha:1];
    send.layer.masksToBounds = YES;
    send.layer.cornerRadius = 5;
    send.frame = CGRectMake(kScreenWidth *0.8+10,5,kScreenWidth*0.2 - 20,30);
    [send addTarget:self action:@selector(pushMessage) forControlEvents:UIControlEventTouchUpInside];
    //[mview addSubview:send];
    
    mview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    [mview addSubview:_textField];
    self.view.backgroundColor = self.tableView.backgroundColor;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.emojyView = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight+10, kScreenWidth, kScreenHeight*0.3)];
    
    
    //[self.emojyView addSubview:scrollbuttom];
    
    
    //[self.view addSubview:self.emojyView];
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.4 -44)];
    backview.userInteractionEnabled = YES;
    //  [self addSubview:backview];
    
    
    navtion = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth,40)];
    navtion.backgroundColor = [UIColor whiteColor];
    labell = [[UILabel alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 40)];
    labell.backgroundColor = [UIColor clearColor];
    labell.textColor = [UIColor blackColor];
    labell.text = self.chatname;
    labell.font = [UIFont fontWithName:@"Heiti SC" size:14];
    labell.textAlignment = NSTextAlignmentCenter;
    labell.center = navtion.center;
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor blackColor];
    returnBtn.frame = CGRectMake(10,10,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [returnBtn setImage:[UIImage imageNamed:@"me_jiantou"] forState:UIControlStateNormal];
    
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    
    [navtion addSubview:returnBtn];
    [navtion addSubview:labell];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:mview];
    [self.view addSubview:self.emojyView];
    [self.view addSubview:navtion];
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake(kScreenWidth/2, kScreenHeight*0.2);
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    
}
//切换表情
-(void)emjoy:(UIButton *)sender{
    
    if (a == 0) {
        [emjoyBtn setImage:[UIImage imageNamed:@"chatBar_key.png"] forState:UIControlStateNormal];
        [_textField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0,kScreenHeight*0.2, kScreenWidth,kScreenHeight*0.8);
            
            //  mview.frame = CGRectMake(0,kScreenHeight - kScreenHeight*0.8, kScreenWidth, 44);
            
            self.emojyView.frame = CGRectMake(0,self.view.frame.size.height - self.view.frame.size.height*0.4, kScreenWidth,self.view.frame.size.height*0.4);
        }];
        a=1;
    }
    else{
        [emjoyBtn setImage:[UIImage imageNamed:@"toolbar-emoji2.png"] forState:UIControlStateNormal];
        [_textField becomeFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0,kScreenHeight*0.2, kScreenWidth, kScreenHeight*0.8);
            self.emojyView.frame = CGRectMake(0,kScreenHeight*2, kScreenWidth, self.view.frame.size.height*0.2);
            
        }];
        a=0;
    }
    
    [self jumpLast];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    //    if (sendok == 0) {
    //
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发送频率太高,请稍等一会" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //
    //        [alert show];
    //
    //        return NO;
    //    }
    
    [self pushMessage];
    
    return YES;
}
-(void)jumpLast
{
    
    NSUInteger sectionCount = [self.tableView numberOfSections];
    if (sectionCount) {
        
        NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];
        if (rowCount) {
            
            NSUInteger ii[2] = {0,rowCount - 1};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
    }
    
}

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

-(void)pushMessage{
    NSLog(@"-----环信发送消息-----");
    NSString *text = _textField.text;
    NSDictionary *userExt = @{
                              @"userName":[CBLiveUserConfig myProfile].user_nicename,
                              @"userLevel":[CBLiveUserConfig myProfile].user_level,
                              @"avatar": [CBLiveUserConfig myProfile].avatar,
                              @"context" : text,
                              @"type": @"0"
                              };
    EMMessage *message = [self _sendTextMessage:text to:self.chatID messageType:EMChatTypeChat messageExt:userExt];
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        NSDate* date = [NSDate date];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd HH:mm"];
        NSString* dateStr = [dateFormat stringFromDate:date];
        CBLiveUser *user = [CBLiveUserConfig myProfile];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[user.avatar,text,@"0",dateStr] forKeys:@[@"avatar",@"text",@"type",@"time"]];
        [self.allArray addObject:dic];
        [self.tableView reloadData];
        [self jumpLast];
        
        _textField.text = nil;
    }];
    
//    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
//        NSLog(@"%@", @(progress));
//    } completion:^(EMMessage *message, EMError *error) {
//        NSLog(@"%@",error.errorDescription);
//        NSDate* date = [NSDate date];
//        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"MM-dd HH:mm"];
//        NSString* dateStr = [dateFormat stringFromDate:date];
//        //                        LiveUser *user = [Config myProfile];
//        CBLiveUser *user = [CBLiveUserConfig myProfile];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[user.avatar,content,@"0",dateStr] forKeys:@[@"avatar",@"text",@"type",@"time"]];
//        [self.allArray addObject:dic];
//        [self.tableView reloadData];
//        [self jumpLast];
//    }];
//
    
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    NSString *userBaseUrl = [purl stringByAppendingFormat:@"?service=User.checkBlack&uid=%@&touid=%@",[CBLiveUserConfig getHXuid],self.chatID];
//    [session GET:userBaseUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSNumber *number = [responseObject valueForKey:@"ret"] ;
//        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
//        {
//            NSArray *data = [responseObject valueForKey:@"data"];
//            NSNumber *code = [data valueForKey:@"code"];
//            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
//            {
//                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
//                NSString *t2u = [NSString stringWithFormat:@"%@",[info valueForKey:@"t2u"]];//对方是否拉黑我
//                if ([t2u isEqual:@"0"]) {
//                    sendok = 0;
//
//                    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//                    NSString *trimedString = [_textField.text stringByTrimmingCharactersInSet:set];
//                    if ([trimedString length] == 0) {
//                        return ;
//                    }
//                    _textField.text = [_textField.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
//                    content = _textField.text;
//                    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:content];
//                    //生成Message
//                    NSDictionary *iconDic = [NSDictionary dictionaryWithObject:self.chatothsersattention forKey:@"isfollow"];
//                    NSString *chatIDstr = [NSString stringWithFormat:@"%@",self.chatID];
//                    EMMessage *message = [[EMMessage alloc] initWithConversationID:chatIDstr from:[CBLiveUserConfig getOwnID] to:chatIDstr body:body ext:iconDic];
//                    message.chatType = EMChatTypeChat;// 设置为单聊消息
//                    message.direction = EMMessageDirectionSend;//方向
//                    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
//                        NSLog(@"%@",error.errorDescription);
//                        NSDate* date = [NSDate date];
//                        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//                        [dateFormat setDateFormat:@"MM-dd HH:mm"];
//                        NSString* dateStr = [dateFormat stringFromDate:date];
////                        LiveUser *user = [Config myProfile];
//                        CBLiveUser *user = [CBLiveUserConfig myProfile];
//                        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[user.avatar,content,@"0",dateStr] forKeys:@[@"avatar",@"text",@"type",@"time"]];
//                        [self.allArray addObject:dic];
//                        [self.tableView reloadData];
//                        [self jumpLast];
//                    }];
//                    _textField.text = nil;
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        send.userInteractionEnabled = YES;
//                        sendok = 1;
//                    });
//                }
//                else{
////                    [HUDHelper myalert:@"对方暂时拒绝接收您的消息"];
//                    [MBProgressHUD showAutoMessage:@"对方暂时拒绝接收您的消息"];
//                }
//            }
//        }
//    }
//         failure:^(NSURLSessionDataTask *task, NSError *error)
//     {
//
//     }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    chatmessageCell *cell = [chatmessageCell cellWithTableView:tableView];
    
    cell.model = self.models[indexPath.row];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    chatmessageModel *model = self.models[indexPath.row];
    return model.rowH;
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    //    [self.view endEditing:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [conversation markAllMessagesAsRead:nil];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [conversation markAllMessagesAsRead:nil];
    
}
//接受消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    
    for (EMMessage *message in aMessages) {
        
        message.direction = EMMessageDirectionReceive;
        EMMessageBody *msgBody = message.body;
        if ([message.conversationId isEqual:self.chatID]) {
            
            switch (msgBody.type) {
                case EMMessageBodyTypeText:
                {
                    // 收到的文字消息
                    EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                    NSString *txt = textBody.text;
                    NSDate* date = [NSDate date];
                    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"dd HH:mm"];
                    NSString *dateStr = [dateFormat stringFromDate:date];
                    
                    if (self.icon == nil) {
                        self.icon = @" ";
                    }
                    
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.icon,txt,@"1",dateStr] forKeys:@[@"avatar",@"text",@"type",@"time"]];
                    
                    [self.allArray addObject:dic];
                    [self.tableView reloadData];
                    [self jumpLast];
                    [self jumpLast];
                    
                    
                }
                    break;
                default:
                    break;
            }
        }
    }
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    newHeight = kScreenHeight - height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0,kScreenHeight*0.2, kScreenWidth, kScreenHeight*0.8 - newHeight);
        mview.frame = CGRectMake(0,self.view.frame.size.height-44, kScreenWidth*0.2-20, 44);
        [self jumpLast];
    }];
}
-(void)Actiondo
{
    
    [_textField resignFirstResponder];
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.1 animations:^{
        self.view.frame = CGRectMake(0, kScreenHeight - kScreenHeight*0.4, kScreenWidth, kScreenHeight*0.4);
        mview.frame = CGRectMake(0,kScreenHeight*0.4 - 40,kScreenWidth,44);
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_textField becomeFirstResponder];
}
//展示cell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.emojyArray.count;
}
//定义section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojy" forIndexPath:indexPath];
    
    UILabel *emojyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
    
    
    emojyLabel.textAlignment = NSTextAlignmentCenter;
    
    
    emojyLabel.text = [self.emojyArray objectAtIndex:indexPath.row];
    
    
    [cell addSubview:emojyLabel];
    
    return cell;
    
    
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    _textField.text = [_textField.text stringByAppendingPathComponent:[self.emojyArray objectAtIndex:indexPath.row]];
    _textField.text = [_textField.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // [self Actiondo];
    
}
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(kScreenWidth/8,kScreenHeight*0.3/4);
    
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0,0,0,0);
    
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
@end
