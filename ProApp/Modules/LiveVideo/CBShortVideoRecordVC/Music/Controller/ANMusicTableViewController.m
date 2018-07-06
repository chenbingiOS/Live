//
//  ANMusicTableViewController.m
//  ProApp
//
//  Created by 林景安 on 2018/6/28.
//  Copyright © 2018年  All rights reserved.
//

#import "ANMusicTableViewController.h"
#import "CBLiveUserConfig.h"
#import "ANMusicCell.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import <WebKit/WebKit.h>
#import "MJRefresh.h"
#import "AWYDownloadHelper.h"
#import "ANCircleProgressView.h"
#import "AWYDownloadFileManager.h"

@interface ANMusicTableViewController ()

@property(nonatomic,strong) NSMutableArray   *musicArr;
//用于播放在线音乐
@property(nonatomic,strong)WKWebView  *webView;
@property(nonatomic,weak)ANMusicModel *playModel;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,assign) BOOL moreMusic;
@property(nonatomic,weak)ANCircleProgressView *progressView;

@property(nonatomic,strong)AVPlayer *play;
@end

@implementation ANMusicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择列表";
    self.page = 1;
    self.moreMusic = YES;
    self.musicArr = [[NSMutableArray alloc] init];
    //WKWebView初始化，用于播放在线音乐
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(120,60,65,35)];
    self.webView = webView;
    [self.view addSubview:webView];
    webView.hidden=YES;
    //UITableView 设置
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    self.tableView.showsVerticalScrollIndicator = NO;
    //添加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellPlayMusicButtonDidClick:) name:ANMusicPlayButtonDidClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPause:) name:ANMusicPauseButtonDidClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadMusic:) name:ANNotificationDownLoadMusic object:nil];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_footer beginRefreshing];
}



#pragma mark -----------网络请求----------------
-(void)loadData {
    if (!self.moreMusic) { //当没有更多的数据时，不进行网络请求
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showAutoMessage:@"没有更多数据"];
        self.tableView.mj_footer = nil;
        return;
    }
    
    NSDictionary *param = @{ @"token":[CBLiveUserConfig getOwnToken],@"page":@(self.page++)};
    @weakify(self);
    [PPNetworkHelper POST:@"http://fengwo.gttead.cn/Api/ShortVideo/getMusics" parameters:param success:^(id responseObject) {        
        @strongify(self);
        NSArray *ary = [NSArray modelArrayWithClass:[ANMusicModel class] json:responseObject[@"data"]];
        self.moreMusic = ary.count==20 ? YES:NO;//判断是否有更多音乐
        [self.musicArr addObjectsFromArray:ary];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showAutoMessage:@"数据加载失败"];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ANMusicCell *cell = [ANMusicCell cellWithTableView:tableView];
    [cell setDataWithMusicModel:self.musicArr[indexPath.row]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [ANMusicCell cellHeightWith:self.musicArr[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击cell 控制确定按钮的显示或隐藏
    ANMusicModel *model = self.musicArr[indexPath.row];
    model.cellSelected = !model.cellSelected;
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];

}

#pragma mark ----------音乐播放-----------
-(void)cellPlayMusicButtonDidClick:(NSNotification *)not {
    //暂停歌曲播放
    ANMusicCell *cell = not.object;
    ANMusicModel *model = cell.model;
    if([self.playModel isEqual:model]){//判断歌曲是否是暂停
        [self.webView evaluateJavaScript:@"var video = document.getElementsByTagName('video')[0];video.play();" completionHandler:nil];
        return;
    }
    //新的歌曲播放
    self.playModel.selected = NO;
    self.playModel = model;
    self.playModel.selected = YES;
    //1URL
    NSString *url;
    if(self.playModel.bgm_qiniu_key.length == 0){//当七牛没有此歌曲，访问备用地址，访问自己的服务器
        url = self.playModel.bgm_url;
    }else {
        url = self.playModel.bgm_qiniu_key;
    }
    // 2.创建请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    // 3.加载网页
    [self.webView loadRequest:request];
    [self.tableView reloadData];
}

#pragma mark ----------音乐暂停-----------
-(void)musicPause:(NSNotification *)not {
    [self.webView evaluateJavaScript:@"var video = document.getElementsByTagName('video')[0];video.pause();" completionHandler:nil];
}


#pragma mark ----------下载音乐----------
-(void)downLoadMusic:(NSNotification *)not {
    ANMusicCell *cell = not.object;
    ANMusicModel *model = cell.model;
    NSString *urlStr;
    if(self.playModel.bgm_qiniu_key.length == 0){//当七牛没有此歌曲，访问备用地址，访问自己的服务器
        urlStr = model.bgm_url;
    }else {
        urlStr = model.bgm_qiniu_key;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    //判断本地是否已经下载了，
    NSString *savePath = [cachePath stringByAppendingPathComponent:url.lastPathComponent];
    if ([AWYDownloadFileManager isFileExist:savePath]) {
        model.savePath = savePath;
        [self runDelegateCodeWith:model];
        return;
    }
    
    [self progressViewInit];
    //开始下载
    AWYDownloadHelper *downloadHelper =  [[AWYDownloadHelper alloc] init];
    @weakify(self);
    [downloadHelper downloadWithURL:url downInfo:nil downloadState:nil progress:^(float progress) {
        @strongify(self);//主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress;
        });
    } success:^(NSString *filePath) {
        @strongify(self);
        model.savePath = filePath;
        [self runDelegateCodeWith:model];
    } error:^{
        @strongify(self);
        [self.progressView removeFromSuperview];
        [MBProgressHUD showAutoMessage:@"下载失败"];
    }];

}

//执行代理方法
-(void)runDelegateCodeWith:(ANMusicModel *)model {
    
    if ([self.delegate respondsToSelector:@selector(didSelectedMusic:)]) {
        [self.delegate didSelectedMusic:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----------进度条初始化----------
-(void)progressViewInit {
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    ANCircleProgressView *pregressView = [[ANCircleProgressView alloc] init];
    [window addSubview:pregressView];
    [pregressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_offset(0);
    }];
    self.progressView = pregressView;
}


/**
 * 移除通知
 */
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
