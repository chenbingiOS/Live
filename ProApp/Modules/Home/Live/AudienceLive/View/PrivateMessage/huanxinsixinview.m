#import "huanxinsixinview.h"
#import "messageModel.h"
#import "messageCellcell.h"
#import "chatsmallview.h"

#define fontMT(sizeThin)   [UIFont fontWithName:@"Arial-ItalicMT" size:(sizeThin)]

@implementation huanxinsixinview
-(instancetype)init{
    self = [super init];
    if (self) {
        [self setview];
        [self haha];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)reloadMessageIM{
    [self forMessage];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"formessage" object:nil];
    
}
-(void)setview{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMessageIM) name:@"reloadMessageIM" object:nil];
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,40)];
    navtion.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    [self.view addSubview:navtion];
    UIButton *hulueBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    hulueBTN.frame = CGRectMake(kScreenWidth - 60, 0, 50, 40);
    hulueBTN.backgroundColor = [UIColor clearColor];
    [hulueBTN setTitle:@"忽略" forState:UIControlStateNormal];
    [hulueBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    hulueBTN.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:13];
    [hulueBTN addTarget:self action:@selector(weidu:) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:hulueBTN];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor blackColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 40)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(10,10,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [returnBtn setImage:[UIImage imageNamed:@"me_jiantou"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    self.allArray = [NSMutableArray array];
    NSString *space = @" ";
    NSArray *array = @[@"已关注",space,@"未关注"];
    segmentC = [[UISegmentedControl alloc]initWithItems:array];
    [segmentC addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segmentC.tintColor = [UIColor clearColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(13),NSFontAttributeName,[UIColor grayColor], NSForegroundColorAttributeName, nil];
    [segmentC setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(14),NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName, nil];
    [segmentC setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    segmentC.selectedSegmentIndex = 0;
    [navtion addSubview:segmentC];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, kScreenWidth,kScreenHeight*0.4 - 40) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    segmentC.frame = CGRectMake(kScreenWidth/6.5/2,27,125,30);
    segmentC.center = CGPointMake(navtion.center.x, navtion.center.y );
    [segmentC setWidth:55 forSegmentAtIndex:0];
    [segmentC setWidth:20 forSegmentAtIndex:1];
    [segmentC setWidth:55 forSegmentAtIndex:2];
    //标记未读消息
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(48,0, 15, 15)];
    label1.backgroundColor = [UIColor redColor];
    label1.layer.masksToBounds = YES;
    label1.layer.cornerRadius = 7.5;
    label1.textColor = [UIColor whiteColor];
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 15, 15)];
    label2.backgroundColor = [UIColor redColor];
    label2.layer.masksToBounds = YES;
    label2.layer.cornerRadius = 7.5;
    label2.textColor = [UIColor whiteColor];
    label2.hidden = YES;
    label1.hidden = YES;
    [segmentC addSubview:label2];
    [segmentC addSubview:label1];
    
    
    line1 = [[UILabel alloc]initWithFrame:CGRectMake(11,30,36, 3)];
    line1.backgroundColor = [UIColor blackColor];
    line2 = [[UILabel alloc]initWithFrame:CGRectMake(87,30,37, 3)];
    line2.backgroundColor = [UIColor blackColor];
    line2.hidden = YES;
    line1.hidden = NO;
    [segmentC addSubview:line2];
    [segmentC addSubview:line1];

}
-(void)doReturn{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gengxinweidu" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toolbarHidden" object:nil];
    [UIView animateWithDuration:1.0 animations:^{
        self.view.frame = CGRectMake(0, kScreenHeight*3, kScreenWidth, kScreenHeight*0.4);
    }];
}
-(void)didReceiveMessages:(NSArray *)aMessages{
    [self forMessage];
}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

-(void)forMessage{
    // 处理耗时操作的代码块...
    self.allArray = nil;
    self.allArray = [NSMutableArray array];
    self.conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    NSMutableArray *arraychat = [NSMutableArray arrayWithArray:self.conversations];
    NSArray* sorted = [arraychat sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    [arraychat removeAllObjects];
    [arraychat addObjectsFromArray:sorted];
    
    for (EMConversation *conversation  in arraychat) {
        if (![self->em.conversationId isEqual:[CBLiveUserConfig getHXuid]]){
                        
            NSString *from = conversation.latestMessage.from;
            NSString *to = conversation.latestMessage.to;
            NSDictionary *ext = conversation.latestMessage.ext;
            NSLog(@"%@ %@ %@", from, to, ext);
            NSMutableDictionary *subDic = [NSMutableDictionary dictionaryWithDictionary:ext];
            NSDate *lastTime =[NSDate dateWithTimeIntervalSince1970:conversation.latestMessage.timestamp/1000];
            NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
            [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: lastTime]];
            NSString *dateString=[NSString stringWithString:[timeStr description]];
            NSString *substring3  =  [dateString substringWithRange:NSMakeRange(5, 11)];//选择某一区域截取
            [subDic setObject:substring3 forKey:@"time"];
            NSString *uRead = [NSString stringWithFormat:@"%d",conversation.unreadMessagesCount];
            if (!uRead) {
                uRead = @"0";
            }
            [subDic setObject:uRead forKey:@"unRead"];
            
            
            EMMessage *messages = conversation.latestMessage;
            EMMessageBody *msgBody = messages.body;
            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
            self->lastMessage = textBody.text;
            
            if (self->lastMessage == nil ||lastMessage.length == 0) {
                self->lastMessage = @" ";
            }
            [subDic setObject:self->lastMessage forKey:@"lastMessage"];
            
            [self.allArray addObject:subDic];
            
            
        }
    }

    NSMutableArray *ray = [NSMutableArray array];
    for (int i=0;i<self.allArray.count;i++) {
        NSDictionary *dic = self.allArray[i];
        messageModel *model = [messageModel modelWithDic:dic];
        [ray addObject:model];
    }
    self.models = ray;

    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
       
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

//忽略未读
-(void)weidu:(UIButton *)sender{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    for (em in self.conversations) {
        
        NSDictionary *messageDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:em.unreadMessagesCount] forKey:@"unreadCount"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"messageCount" object:nil userInfo:messageDic];
        [em markAllMessagesAsRead:nil];
    }
    UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:@"已经忽略未读消息" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerts show];
    self.allArray = nil;
    self.allArray = [NSMutableArray array];
    [self forMessage];
    
    
}
-(void)haha{
    
    [self forMessage];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    messageCellcell *cell = [messageCellcell cellWithTableView:tableView];
    @try {
        messageModel *model = self.models[indexPath.row];
        cell.model = model;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    messageModel *model = self.models[indexPath.row];
    for (em in self.conversations) {
        if ([em.conversationId isEqual:model.uid]) {
            NSDictionary *messageDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:em.unreadMessagesCount] forKey:@"unreadCount"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"messageCount" object:nil userInfo:messageDic];
            [em markAllMessagesAsRead:nil];
        }
    }
    chatsmallview *chat = [[chatsmallview alloc]init];
    chat.bakcOK = 1;
    chat.chatID = nil;
    chat.chatID = [NSString stringWithFormat:@"%@",model.uid];
    chat.chatname = [NSString stringWithFormat:@"%@",model.userName];
    chat.icon = [NSString stringWithFormat:@"%@",model.imageIcon];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%@",model.userName],[NSString stringWithFormat:@"%@",model.uid],[NSString stringWithFormat:@"%@",model.imageIcon]] forKeys:@[@"name",@"id",@"icon"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sixinok" object:nil userInfo:dic];
}
//segment事件
-(void)change:(UISegmentedControl *)segment{
    
   
}
@end
