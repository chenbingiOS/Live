//
//  CBLiveAnchorGuardianListVC.m
//  ProApp
//
//  Created by hxbjt on 2018/7/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveAnchorGuardianListVC.h"
#import "CBLiveAnchorGrardianListCell.h"
#import "CBLiveUser.h"
#import "CBAppLiveVO.h"

@interface CBLiveAnchorGuardianListVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CBLiveUser *> *cellDataAry;
@property (nonatomic, assign) NSUInteger currentPage;   ///< 当前页

@end

@implementation CBLiveAnchorGuardianListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"守护榜";
    [self.tableView registerNib:[UINib nibWithNibName:@"CBLiveAnchorGrardianListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CBLiveAnchorGrardianListCellReuseIdentifier"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 80;
    
    self.currentPage = 1;
    self.tableView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        [self reloadAllData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self httpGetGuardRankList];
    }];
    
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tagButton.size = CGSizeMake(44, 44);
    [tagButton setBackgroundImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    [tagButton setBackgroundImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateHighlighted];
    tagButton.size = tagButton.currentBackgroundImage.size;
    [tagButton addTarget:self action:@selector(tagClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tagButton];
}

- (void)tagClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadAllData {
    self.currentPage = 1;
    self.cellDataAry = [NSMutableArray array];
    [self httpGetGuardRankList];
}

- (void)httpGetGuardRankList {
    NSString *url = urlGetGuardRankList;
    NSDictionary *param = @{@"host_id": [CBLiveUserConfig getOwnID],
                            @"token": [CBLiveUserConfig getOwnToken],
                            @"page": @(self.currentPage)};
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSArray *resultList = [NSArray modelArrayWithClass:[CBLiveUser class] json:responseObject[@"data"]];
            if (resultList.count < 20 && self.currentPage > 1) {
                self.currentPage--;
            } else {
                self.cellDataAry = resultList.copy;
                [self.tableView reloadData];
            }
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showAutoMessage:@"守护榜获取失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBLiveAnchorGrardianListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBLiveAnchorGrardianListCellReuseIdentifier"];
    cell.liveUser = self.cellDataAry[indexPath.row];
    return cell;
}




@end
