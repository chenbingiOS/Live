//
//  CBLiveAnchorGiftRecordView.m
//  ProApp
//
//  Created by hxbjt on 2018/7/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveAnchorGiftRecordView.h"
#import "CBLiveAudienceGiveGiftRecordCell.h"
#import "CBLiveAndienceAnchorRecordCell.h"

@interface CBLiveAnchorGiftRecordView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSUInteger currentPage;   ///< 当前页
@property (nonatomic, strong) NSMutableArray *cellDataAry;
@property (nonatomic, copy) NSString *url;

@end

@implementation CBLiveAnchorGiftRecordView

- (IBAction)actionThisContributionbtn:(UIButton *)sender {
    self.contributionBtn.selected = NO;
    self.giftListBtn.selected = NO;
    sender.selected = YES;
    self.url = urlThisContribute;
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)actionRecordBtn:(UIButton *)sender {
    self.contributionBtn.selected = NO;
    self.giftListBtn.selected = NO;
    sender.selected = YES;
    self.url = urlThisGift;
    [self.tableView.mj_header beginRefreshing];
}

- (void)_reloadData_Init {
    self.url = urlThisContribute;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CBLiveAudienceGiveGiftRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CBLiveAudienceGiveGiftRecordCellReuseIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CBLiveAndienceAnchorRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CBLiveAndienceAnchorRecordCellReuseIdentifier"];

    self.currentPage = 1;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        [self reloadAllData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self httpGetListData];
    }];
}

- (void)reloadAllData {
    self.currentPage = 1;
    self.cellDataAry = [NSMutableArray array];
    [self httpGetListData];
}

- (void)httpGetListData {
    NSString *url = self.url;
    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken],
                            @"id": [CBLiveUserConfig getOwnID],
                            @"page": @(self.currentPage)};
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSString *allMoney = responseObject[@"data"][@"all"][@"allMoney"];
            self.countCoinLab.text = allMoney;
            NSString *count = responseObject[@"data"][@"all"][@"count"];
            self.countPeopleLab.text = count;
            NSArray *resultList = [NSArray modelArrayWithClass:[CBLiveUser class] json:responseObject[@"data"][@"user"]];
            if (resultList.count < 20 && self.currentPage > 1) {
                self.currentPage--;
            } else {
                [self.cellDataAry addObjectsFromArray:resultList];
                [self.tableView reloadData];
            }
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showAutoMessage:@"数据获取失败"];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.contributionBtn.selected) {
        CBLiveAudienceGiveGiftRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBLiveAudienceGiveGiftRecordCellReuseIdentifier"];
        cell.liveUser = self.cellDataAry[indexPath.row];
        return cell;
    } else {
        CBLiveAndienceAnchorRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBLiveAndienceAnchorRecordCellReuseIdentifier"];
        cell.liveUser = self.cellDataAry[indexPath.row];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contributionBtn.selected) {
        return 80;
    } else {
        return 50;
    }
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
