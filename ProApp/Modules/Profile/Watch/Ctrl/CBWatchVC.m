//
//  CBWatchVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBWatchVC.h"
#import "CBWatchCell.h"
#import "CBWatchHeaderView.h"
#import "CBWatchVO.h"

@interface CBWatchVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSArray * >*cellDataAry;

@end

static NSString *const WatchHeaderViewIdentifier = @"WatchHeaderViewIdentifier";
static NSString *const WatchCellIdentifier = @"WatchCellIdentifier";

@implementation CBWatchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBWatchVO *vo = [CBWatchVO new];
    vo.userAvater = @"test_avater";
    vo.title = @"我是标题";
    vo.desc = @"我是描述";
    vo.gender = @"1";
    vo.time = @"1 分钟前";
    
    [self.cellDataAry addObject:@[vo,vo,vo]];
    [self.cellDataAry addObject:@[vo]];
    
    self.title = @"观看记录";
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAllWatchList)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CBWatchHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:WatchHeaderViewIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CBWatchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WatchCellIdentifier];
}

- (void)clearAllWatchList {
    self.cellDataAry = [NSMutableArray new];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBWatchCell *cell = [tableView dequeueReusableCellWithIdentifier:WatchCellIdentifier];
    [cell loadData:self.cellDataAry[indexPath.section][indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CBWatchHeaderView *headerView = [CBWatchHeaderView viewFromXib];
    headerView.timeLabel.text = @(section).stringValue;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    CGFloat sectionFooterHeight = 0;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    } else if (offsetY >= sectionHeaderHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    } else if (offsetY >= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height) {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight), 0);
    }
}

#pragma mark - layz
- (NSMutableArray <NSArray *> *)cellDataAry {
    if (!_cellDataAry) {
        _cellDataAry = [NSMutableArray new];
    }
    return _cellDataAry;
}

@end
