//
//  CBMyFansVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBMyFansVC.h"
#import "CBWatchCell.h"
#import "CBWatchVO.h"

@interface CBMyFansVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CBWatchVO *> *cellDataAry;

@end

static NSString *const WatchCellIdentifier = @"WatchCellIdentifier";

@implementation CBMyFansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBWatchVO *vo = [CBWatchVO new];
    vo.userAvater = @"test_avater";
    vo.title = @"我是标题";
    vo.desc = @"我是描述";
    vo.gender = @"1";
    vo.liveing = @"1";
    vo.attention = @"1";
    
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    
    self.title = @"我的粉丝";
    [self setupUI];
}

- (void)setupUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"CBWatchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WatchCellIdentifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBWatchCell *cell = [tableView dequeueReusableCellWithIdentifier:WatchCellIdentifier];
    [cell loadData:self.cellDataAry[indexPath.row]];
    return cell;
}

#pragma mark - layz
- (NSMutableArray *)cellDataAry {
    if (!_cellDataAry) {
        _cellDataAry = [NSMutableArray new];
    }
    return _cellDataAry;
}

@end
