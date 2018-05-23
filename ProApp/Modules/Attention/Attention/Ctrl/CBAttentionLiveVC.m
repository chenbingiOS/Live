//
//  CBAttentionLiveVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/14.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAttentionLiveVC.h"
#import "CBWatchVO.h"
#import "CBWatchCell.h"
#import "CBAttentionLiveCell.h"
//#import "ALinRefreshGifHeader.h"
#import "ALinUser.h"
#import "CBHorizontalFlowLayout.h"

@interface CBAttentionLiveVC () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CBHorizontalFlowLayoutDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <CBWatchVO * >*cellDataAry;
@property (nonatomic, strong) NSMutableArray *anchors;   /** 最新主播列表 */

@end

static NSString *const WatchCellIdentifier = @"WatchCellIdentifier";
static NSString * const AttentionLiveReuseIdentifier = @"CBAttentionLiveCell";

@implementation CBAttentionLiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CBWatchVO *vo = [CBWatchVO new];
    vo.userAvater = @"test_avater";
    vo.title = @"我是标题";
    vo.desc = @"我是描述";
    vo.gender = @"1";
    vo.attention = @"2";
    
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    [self.cellDataAry addObject:vo];
    
    [self setupUI];
    [self setupUI_collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.title = @"关注";
    [self.tableView registerNib:[UINib nibWithNibName:@"CBWatchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WatchCellIdentifier];
}

- (void)clearAllWatchList {
    self.cellDataAry = [NSMutableArray new];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBWatchCell *cell = [tableView dequeueReusableCellWithIdentifier:WatchCellIdentifier];
    [cell loadData:self.cellDataAry[indexPath.row]];
    return cell;
}

#pragma mark - collectionView

- (void)setupUI_collectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CBAttentionLiveCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:AttentionLiveReuseIdentifier];
    
    [self getAnchorsList];
}

// 获取数据
- (void)getAnchorsList {
//    [[ALinNetworkTool shareTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=1"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *statuMsg = responseObject[@"msg"];
//        if ([statuMsg isEqualToString:@"fail"]) { // 数据已经加载完毕, 没有更多数据了
//            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
//            [self showHint:@"暂时没有更多最新数据"];
//            // 恢复当前页
//        } else {
//            [responseObject[@"data"][@"list"] writeToFile:@"/Users/apple/Desktop/user.plist" atomically:YES];
//            NSArray *result = [ALinUser mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
//            if (result.count) {
//                [self.anchors addObjectsFromArray:result];
//                [self.collectionView reloadData];
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self showHint:@"网络异常"];
//    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.anchors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBAttentionLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AttentionLiveReuseIdentifier forIndexPath:indexPath];
    cell.user = self.anchors[indexPath.item];
    return cell;
}

#pragma mark - CBHorizontalFlowLayoutDelegate
- (CGFloat)cb_waterflowLayout:(CBHorizontalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight {
    return 70;
}

- (NSInteger)cb_waterflowLayout:(CBHorizontalFlowLayout *)waterflowLayout linesInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - layz
- (NSMutableArray *)cellDataAry {
    if (!_cellDataAry) {
        _cellDataAry = [NSMutableArray new];
    }
    return _cellDataAry;
}

- (NSMutableArray *)anchors {
    if (!_anchors) {
        _anchors = [NSMutableArray array];
    }
    return _anchors;
}

@end
