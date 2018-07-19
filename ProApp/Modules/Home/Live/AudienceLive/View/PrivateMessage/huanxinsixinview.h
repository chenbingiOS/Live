//
//  huanxinsixinview.h
//  iphoneLive
//
//  Created by zqm on 16/8/3.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageListen.h"
#import "messagelisviews.h"
#import "chatsmallview.h"
@interface huanxinsixinview : messageListen<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate,EMClientDelegate>
{
    UISegmentedControl *segmentC;
    UILabel *xianLabel;//下划线
    UILabel *xianLabel2;
    CGFloat w;//segment一个item的宽
    //EMConversation *em;//会话id;
    EMMessage *message;
    NSString *lastMessage;//获取最后一条消息
    
    UILabel *label1;//获取会话所有的未读消息数 关注
    UILabel *label2;//未关注
    UILabel *line1;
    UILabel *line2;
    
}

@property(nonatomic,copy)NSString *chatUid;

@property(nonatomic,copy)NSString *chatName;

@property(nonatomic,strong)NSArray *models;

@property(nonatomic,strong)NSMutableArray *allArray;//未关注好友

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSNumber *guanzhu;//是否关注

-(void)forMessage;



@end
