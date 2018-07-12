//
//  CBPersonalHomePageVC.m
//  ProApp
//
//  Created by hxbjt on 2018/7/12.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPersonalHomePageVC.h"

#define SCREEN_WHITH [UIScreen mainScreen].bounds.size.width
#define RATIO 1.5


@interface CBPersonalHomePageVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) UIImageView *strechableImageView;
@property (nonatomic,assign) CGRect originFrame;

@end

@implementation CBPersonalHomePageVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WHITH, SCREEN_WHITH / RATIO );
    CGRect imageFrame = frame;
    imageFrame.size.height += 20;
    self.strechableImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_empty_375"]];
    self.strechableImageView.frame = imageFrame;
    self.originFrame = imageFrame;
    [self.view addSubview:self.strechableImageView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor clearColor];
//    self.collectionView.tableHeaderView = headerView;
//    self.collectionView.
    
    self.collectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    UIImageView *imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"placeholder_empty_375"]];
    imagev.frame = CGRectMake(0, -50, kScreenWidth, 50);
    [self.collectionView addSubview: imagev];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"TableView with strechable header";
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:18];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        self.strechableImageView.frame = ({
            CGRect frame = self.originFrame;
            frame.size.height = self.originFrame.size.height - offsetY;
            frame.size.width = frame.size.height * RATIO;
            frame.origin.x = self.originFrame.origin.x - (frame.size.width - self.originFrame.size.width) / 2;
            frame;
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
