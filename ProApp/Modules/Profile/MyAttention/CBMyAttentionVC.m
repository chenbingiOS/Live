
//
//  CBMyAttentionVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBMyAttentionVC.h"
#import "CBWatchCell.h"
#import "CBWatchVO.h"

@interface CBMyAttentionVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CBWatchVO *> *cellDataAry;

@end

static NSString *const WatchCellIdentifier = @"WatchCellIdentifier";

@implementation CBMyAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBWatchVO *vo = [CBWatchVO new];
    vo.userAvater = @"test_avater";
    vo.title = @"我是标题";
    vo.desc = @"我是描述";
    vo.gender = @"1";
    vo.liveing = @"2";
    vo.attention = @"2";
    
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
    
    self.title = @"我的关注";
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
