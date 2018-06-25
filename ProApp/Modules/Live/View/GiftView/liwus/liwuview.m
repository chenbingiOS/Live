#import "liwuview.h"

//#import "Config.h"
//#import "SBJson4.h"
#import "liwucell.h"
#define celll @"cell"
#import "MBProgressHUD.h"
#import <AFNetworking.h>

@interface liwuview ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSTimer *timer;
    int a;
}
@end
@implementation liwuview
-(NSArray *)models{
    NSMutableArray *muatb = [NSMutableArray array];
    for (int i=0;i<self.allArray.count;i++) {
        liwuModel *model = [liwuModel modelWithDic:self.allArray[i]];
        [muatb addObject:model];
    }
    _models = muatb;
    return _models;
}
-(void)reloadColl{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *string = [purl stringByAppendingPathComponent:@"/?service=Live.getGiftList"];
    NSDictionary *giftlist = @{
                               @"uid":[CBLiveUserConfig getOwnID],
                               @"token":[CBLiveUserConfig getOwnToken]
                               };
    [session POST:string parameters:giftlist progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *data = [responseObject valueForKey:@"data"];
                self.allArray = [[[data valueForKey:@"info"] firstObject]valueForKey:@"giftlist"];
                //表格
                UICollectionViewFlowLayout *Flowlayout = [[UICollectionViewFlowLayout alloc]init];
                Flowlayout.minimumLineSpacing = 0;
                Flowlayout.minimumInteritemSpacing = 0;
                Flowlayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
                self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth*(self.allArray.count), kScreenHeight/3- kScreenHeight/18) collectionViewLayout:Flowlayout];
                Flowlayout.minimumLineSpacing = 0;
                Flowlayout.itemSize = CGSizeMake(kScreenWidth/4, ( kScreenHeight/3- kScreenHeight/18)/2);
                self.collectionView.showsHorizontalScrollIndicator = NO;
                self.collectionView.pagingEnabled = NO;
                self.collectionView.scrollEnabled = NO;
                //注册cell
                self.collectionView.backgroundColor = [UIColor clearColor];
                [self.collectionView registerClass:[liwucell class] forCellWithReuseIdentifier:celll];
                self.collectionView.dataSource = self;
                self.collectionView.delegate = self;
                self.collectionView.multipleTouchEnabled = NO;
                
                
                _scrollbuttom = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3)];
                
                NSUInteger pages =  (self.allArray.count)%8==0?(self.allArray.count/8) :((self.allArray.count/8)+1);
                _scrollbuttom.contentSize = CGSizeMake(kScreenWidth*pages, 0);
                
                
               // _scrollbuttom.contentSize = CGSizeMake(kScreenWidth*((self.allArray.count/8)+1), 0);
                
                
                _scrollbuttom.pagingEnabled = YES;
                _scrollbuttom.showsHorizontalScrollIndicator = NO;
                _scrollbuttom.delegate = self;
                _scrollbuttom.bounces = NO;
                [_scrollbuttom addSubview:self.collectionView];
                [self addSubview:_scrollbuttom];
                self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
                //底部条
                
                _buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight/3- kScreenHeight/18, kScreenWidth,kScreenHeight/18)];
                _buttomView.backgroundColor = [UIColor clearColor];
                _push = [UIButton buttonWithType:UIButtonTypeSystem];
                _push.backgroundColor = [UIColor lightGrayColor];
                
                
                //充值lable
                _chongzhi = [[UILabel alloc] init];
                CBLiveUser *user = [CBLiveUserConfig myProfile];
                NSString *coin = [[[data valueForKey:@"info"] firstObject] valueForKey:@"coin"];
                user.balance = coin;
               
                [CBLiveUserConfig saveProfile:user];
//                _chongzhi.textColor = wl_lightGrayColor;
                _chongzhi.font = [UIFont systemFontOfSize:14];
                int chongzhi_y = _buttomView.frame.size.height/2-7;
                [_buttomView addSubview:_chongzhi];
                //充值上透明按钮
                _jumpRecharge = [[UIButton alloc] initWithFrame:CGRectMake(5,chongzhi_y,250,40)];
                _jumpRecharge.titleLabel.text = @"";
                [_jumpRecharge setBackgroundColor:[UIColor clearColor]];
                [_jumpRecharge addTarget:self action:@selector(jumpRechargess) forControlEvents:UIControlEventTouchUpInside];
                [_buttomView addSubview:_jumpRecharge];
                //充值图标
                _coinImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"个人中心(钻石)"]];
                [_buttomView addSubview:_coinImg];
                //箭头
                _jiantou = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_yingpiao_check"]];
                [_buttomView addSubview:_jiantou];
                
                [_push setTitle:@"赠送" forState:UIControlStateNormal];
                [_push setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_push addTarget:self action:@selector(doLiWu:) forControlEvents:UIControlEventTouchUpInside];
                _push.enabled = NO;
                _push.tag = 6789;
                _push.frame = CGRectMake(kScreenWidth - 75,5,70,_buttomView.frame.size.height - 10);
                [_buttomView addSubview:_push];
                [self addSubview:_buttomView];
                
                UILabel *xianssss = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
                xianssss.backgroundColor = [UIColor lightGrayColor];
                [_buttomView addSubview:xianssss];
                CGFloat w = 80;
                _continuBTN = [UIButton buttonWithType:UIButtonTypeCustom];
                _continuBTN.frame = CGRectMake(kScreenWidth - 80,self.frame.size.height - w - 5,w,w);
                _continuBTN.backgroundColor =  [UIColor colorWithRed:60/255.0 green:139/255.0 blue:126/255.0 alpha:1];
                [_continuBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_continuBTN addTarget:self action:@selector(doLiWu:) forControlEvents:UIControlEventTouchDown];
                _continuBTN.tag = 5678;
                _continuBTN.titleLabel.numberOfLines = 2;
                _continuBTN.layer.masksToBounds = YES;
                _continuBTN.layer.cornerRadius = w/2;
                _continuBTN.hidden = YES;
                [_continuBTN setBackgroundImage:[UIImage imageNamed:@"liwusendcontinue"] forState:UIControlStateNormal];
                [self addSubview:_continuBTN];
                [self chongzhiV:coin];
                [self.collectionView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)jumpRechargess{
    
    [self.giftDelegate pushCoinV];
}
-(instancetype)initWithDic:(NSDictionary *)playdic andMyDic:(NSMutableArray *)myDic{
    self = [super init];
    if (self) {
        self.models = [NSArray array];
        self.allArray = [NSArray array];
        self.pldic = playdic;
        
        [self reloadColl];
    }
    return self;
}
//发送礼物
-(void)doLiWu:(UIButton *)sender
{
    self.collectionView.userInteractionEnabled = NO;
    NSString *lianfa = @"y";
    _push.enabled = NO;
    _push.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"发送了%@",_selectModel.giftname);
    //判断连发
    if ([_selectModel.type isEqualToString:@"0"]) {
        lianfa = @"n";
        _continuBTN.hidden = YES;
        _push.enabled = YES;
//        _push.backgroundColor = normalColors;
        self.collectionView.userInteractionEnabled = YES;
    }
    else{
        _continuBTN.hidden = NO;
        a = 30;
        if(timer == nil)
        {
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(jishiqi) userInfo:nil repeats:YES];
        }
        if(sender == _push)
        {
            [timer setFireDate:[NSDate date]];
        }
    }
    /*******发送礼物开始 **********/
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.sendGift"];
    NSDictionary *giftDic = @{
                              @"uid":[CBLiveUserConfig getOwnID],
                              @"token":[CBLiveUserConfig getOwnToken],
                              @"liveuid":[self.pldic valueForKey:@"uid"],
                              @"stream":[self.pldic valueForKey:@"stream"],
                              @"giftid":_selectModel.ID,
                              @"giftcount":@"1"
                              };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:giftDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [self.giftDelegate sendGift:self.mydic andPlayDic:self.pldic andData:data andLianFa:lianfa];
                NSArray *info2 = [[data valueForKey:@"info"] firstObject];
                NSString *coin = [info2 valueForKey:@"coin"];
                CBLiveUser *liveUser = [CBLiveUserConfig myProfile];
                liveUser.total_earn = [NSString stringWithFormat:@"%@",coin];
//                liveUser.coin  =  [NSString stringWithFormat:@"%@",coin];
//                [Config updateProfile:liveUser];
                [CBLiveUserConfig saveProfile:liveUser];
                [self chongzhiV:coin];
            }
            else
            {
//                [HUDHelper myalert:[data valueForKey:@"msg"]];
                _continuBTN.hidden = YES;
            }
        }
        else
        {
//            [HUDHelper myalert:[responseObject valueForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
        /*********************发送礼物结束 ************************/
}
//连发倒计时
-(void)jishiqi{
    [_continuBTN setTitle:[NSString stringWithFormat:@"连发\n  %d",a] forState:UIControlStateNormal];
    a-=1;
    if (a == 0) {
        [timer setFireDate:[NSDate distantFuture]];
//        _push.backgroundColor = normalColors;
        _push.enabled = YES;
        _continuBTN.hidden = YES;
        self.collectionView.userInteractionEnabled = YES;
    }
}
-(void)chongzhiV:(NSString *)coins{
    if (_chongzhi) {
    _chongzhi.text = [NSString stringWithFormat:@"充值 : %@",coins];
    _chongzhi.font = [UIFont systemFontOfSize:14];
    int chongzhi_y = _buttomView.frame.size.height/2-7;
    CGSize size = [_chongzhi.text boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_chongzhi.font} context:nil].size;
    _chongzhi.frame = CGRectMake(10, chongzhi_y, size.width, size.height);
    _coinImg.frame = CGRectMake(size.width + 14, chongzhi_y, 14, 14);
    int jiantou_x = _coinImg.frame.origin.x + _coinImg.frame.size.width+4;
    _jiantou.frame = CGRectMake(jiantou_x, chongzhi_y, 14, 14);
    _jumpRecharge.frame = CGRectMake(10, chongzhi_y, _chongzhi.frame.size.width + _coinImg.frame.size.width + _jiantou.frame.size.width + 10, 20);
    }
}
//展示cell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}
//定义section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        liwucell *cell = (liwucell *)[collectionView dequeueReusableCellWithReuseIdentifier:celll forIndexPath:indexPath];
        liwuModel *model = self.models[indexPath.item];
        cell.model = model;
        return cell;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        liwucell *cell = (liwucell *)[collectionView cellForItemAtIndexPath:indexPath];
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        _selectModel = self.models[indexPath.item];
        if (cell.duihao.hidden == NO) {
            cell.duihao.hidden = YES;
            _push.enabled = NO;
            _push.backgroundColor = [UIColor lightGrayColor];
        }
        else{
            _push.enabled = YES;
//            _push.backgroundColor =normalColors;
            cell.duihao.hidden = NO;
        }
        cell.model = _selectModel;
        NSLog(@"选择%@",_selectModel.giftname);
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
        liwucell *cell = (liwucell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.duihao.hidden = YES;
        _push.enabled = NO;
        _push.backgroundColor = [UIColor lightGrayColor];
}
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        int cellWidth = kScreenWidth/4;
        int cellHeight = ( kScreenHeight/3- kScreenHeight/18)/2;
        return CGSizeMake(cellWidth ,cellHeight);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(0,0,0,0);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
@end
