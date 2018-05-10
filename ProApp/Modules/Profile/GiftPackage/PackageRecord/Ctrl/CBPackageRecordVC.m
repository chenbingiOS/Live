//
//  CBPackageRecordVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/27.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPackageRecordVC.h"
#import "CBPackageRecordVO.h"
#import "CBPackageRecordCell.h"

@interface CBPackageRecordVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CBPackageRecordVO *> *cellDataAry;

@end

static NSString *const CBPackageRecordCellID = @"CBPackageRecordCellID";

@implementation CBPackageRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼包交易记录";
    [self.tableView registerNib:[UINib nibWithNibName:@"CBPackageRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBPackageRecordCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPackageRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CBPackageRecordCellID];
    [cell loadData:self.cellDataAry[indexPath.row]];
    return cell;
}

- (NSMutableArray <CBPackageRecordVO *> *)cellDataAry {
    if (!_cellDataAry) {
        _cellDataAry = [NSMutableArray new];
        
        CBPackageRecordVO *vo = [CBPackageRecordVO new];
        vo.title = @"周卡";
        vo.time = @"2018.12.11";
        vo.money = @"-19";
        
        [_cellDataAry addObject:vo];
        [_cellDataAry addObject:vo];
    }
    return _cellDataAry;
}

@end
