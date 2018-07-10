//
//  CBLiveAnchorGiftRecordView.m
//  ProApp
//
//  Created by hxbjt on 2018/7/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveAnchorGiftRecordView.h"
#import "CBLiveAudienceGiveGiftRecordCell.h"



@interface CBLiveAnchorGiftRecordView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSUInteger currentPage;   ///< 当前页
@property (nonatomic, strong) NSMutableArray *cellDataAry;
@property (nonatomic, copy) NSString *url;

@end

@implementation CBLiveAnchorGiftRecordView

- (IBAction)actionThisContributionbtn:(id)sender {
    [self reloadAllData];
}
- (IBAction)actionRecordBtn:(id)sender {
    [self reloadAllData];
}

#warning 这边逻辑还没有完全写完
- (void)_reloadData_Init {
    NSString *url = urlGetLiveRoomOnlineUserList;
    self.currentPage = 1;
    self.tableView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        [self reloadAllData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self httpGetLiveRoomOnlineUserList];
    }];
}

- (void)reloadAllData {
    self.currentPage = 1;
    self.cellDataAry = [NSMutableArray array];
    [self httpGetLiveRoomOnlineUserList];
}

- (void)httpGetLiveRoomOnlineUserList {
    NSString *url = urlGetLiveRoomOnlineUserList;
    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken],
                            @"page": @(self.currentPage)};
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
//            NSArray *resultList = [NSArray modelArrayWithClass:[CBAppLiveVO class] json:responseObject[@"data"]];
//            if (resultList.count < 20 && self.currentPage > 1) {
//                self.currentPage--;
//            } else {
//                [self.cellDataAry addObjectsFromArray:resultList];
//                [self.tableView reloadData];
//            }
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showAutoMessage:@"在线用户获取失败"];
    }];
}

- (void)setListAry:(NSArray *)listAry {
    _listAry = listAry;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CBLiveAudienceGiveGiftRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CBLiveAudienceGiveGiftRecordCellReuseIdentifier"];
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CBLiveAudienceGiveGiftRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBLiveAudienceGiveGiftRecordCellReuseIdentifier"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listAry.count;
}

@end



@implementation CBLiveAnchorGiftRecordPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置参数 (否则用默认值)
        self.popType = PopTypeMove;
        self.moveAppearCenterY = kScreenHeight - self.height/2;
        self.moveAppearDirection = MoveAppearDirectionFromBottom;
        self.moveDisappearDirection = MoveDisappearDirectionToBottom;
        self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.animateDuration = 0.35;
        self.radius = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.giftRecordView];
    }
    return self;
}

- (CBLiveAnchorGiftRecordView *)giftRecordView {
    if (!_giftRecordView) {
        _giftRecordView = [CBLiveAnchorGiftRecordView viewFromXib];
        _giftRecordView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.75);
        [_giftRecordView _reloadData_Init];
    }
    return _giftRecordView;
}

@end
