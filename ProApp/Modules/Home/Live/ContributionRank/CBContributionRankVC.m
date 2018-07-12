//
//  CBContributionRankVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBContributionRankVC.h"
#import "CBGuardRankCCell.h"

@interface CBContributionRankVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *countABtn;
@property (weak, nonatomic) IBOutlet UIButton *countBBtn;
@property (weak, nonatomic) IBOutlet UIButton *countCBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CBLiveUser *> *cellDataAry;
@property (nonatomic, assign) NSUInteger currentPage;   ///< 当前页
@property (nonatomic, copy) NSString *countNum;   /// 0 总榜，1 日榜 ， 2 周榜

@end

static NSString *const CBGuardRankCCellID = @"CBGuardRankCCellID";

@implementation CBContributionRankVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贡献榜";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CBGuardRankCCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBGuardRankCCellID];
    self.tableView.tableFooterView = [UIView new];
    
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tagButton.size = CGSizeMake(44, 44);
    [tagButton setBackgroundImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    [tagButton setBackgroundImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateHighlighted];
    tagButton.size = tagButton.currentBackgroundImage.size;
    [tagButton addTarget:self action:@selector(tagClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tagButton];
    
    self.countNum = @"0";
    self.currentPage = 1;
    self.tableView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        [self reloadAllData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self httpReceiveCoin];
    }];
}

- (IBAction)actionCountBtn:(UIButton *)sender {
    self.countABtn.selected = NO;
    self.countBBtn.selected = NO;
    self.countCBtn.selected = NO;
    sender.selected = YES;
    
    if (sender.tag == 11) {
        self.countNum = @"0";
    } else if (sender.tag == 22) {
        self.countNum = @"1";
    } else if (sender.tag == 33) {
        self.countNum = @"2";
    }
    [self reloadAllData];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)reloadAllData {
    self.currentPage = 1;
    self.cellDataAry = [NSMutableArray array];
    [self httpReceiveCoin];
}

// 贡献榜
- (void)httpReceiveCoin {
    NSString *url = urlReceiveCoin;
    NSDictionary *param = @{@"id": [CBLiveUserConfig getOwnID],
                            @"token": [CBLiveUserConfig getOwnToken],
                            @"count": self.countNum,
                            @"page": @(self.currentPage)};
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSArray *resultList = [NSArray modelArrayWithClass:[CBLiveUser class] json:responseObject[@"data"]];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showAutoMessage:@"贡献榜获取失败"];
    }];
}

- (void)tagClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBGuardRankCCell *cell = [tableView dequeueReusableCellWithIdentifier:CBGuardRankCCellID];
    cell.liveUser = self.cellDataAry[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
