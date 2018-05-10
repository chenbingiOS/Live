//
//  CBGiftPackageVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/27.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBGiftPackageVC.h"
#import "CBPackageRecordVC.h"
#import "CBPackageRecordVO.h"
#import "CBGiftPackageCell.h"

@interface CBGiftPackageVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CBPackageRecordVO *> *cellDataAry;

@end

static NSString *const CBGiftPackageCellID = @"CBGiftPackageCell";

@implementation CBGiftPackageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的礼包";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"交易记录" style:UIBarButtonItemStylePlain target:self action:@selector(giftPackageList)];
    [self.tableView registerNib:[UINib nibWithNibName:@"CBGiftPackageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBGiftPackageCellID];
}

- (void)giftPackageList {
    CBPackageRecordVC *vc = [CBPackageRecordVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBGiftPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:CBGiftPackageCellID];
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
