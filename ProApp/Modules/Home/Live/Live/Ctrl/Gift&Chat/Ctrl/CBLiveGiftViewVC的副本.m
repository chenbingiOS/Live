//
//  CBLiveGiftViewVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/22.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveGiftViewVC.h"
// VC
#import "CBLiveChatViewVC.h"
#import "TSCCollectionViewFlowLayout.h"
// Category
#import "UIViewController+SuperViewCtrl.h"
// Model
#import "CBGiftVO.h"
#import "CBAppLiveVO.h"
#import "CBChatGiftMessageVO.h"
// View
#import "CBGiftCell.h"
#import "TSCGifts.h"

@interface CBLiveGiftViewVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UIButton *giftListBtn;
@property (weak, nonatomic) IBOutlet UIButton *warehouseListBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectionView;
@property (weak, nonatomic) IBOutlet TSCCollectionViewFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *countABtn;
@property (weak, nonatomic) IBOutlet UIButton *countBBtn;
@property (weak, nonatomic) IBOutlet UIButton *countCBtn;
@property (weak, nonatomic) IBOutlet UIButton *countDBtn;
@property (weak, nonatomic) IBOutlet UIButton *countEBtn;
@property (nonatomic, strong) NSArray <UIButton *> *countBtnAry;
@property (nonatomic, assign) NSNumber *countNum;
@property (weak, nonatomic) IBOutlet UIButton *sentGiftBtn;
@property (nonatomic, strong) NSArray <CBGiftVO *> *giftAry;
@property (nonatomic, strong) CBGiftVO *selectGiftVO;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIImageView *coinMarkImg;
@property (nonatomic, strong) UILabel *diamondCount;
@property (nonatomic, strong) UILabel *starCount;

@end

static NSString *const KReuseIdGiftCell = @"KReuseIdGiftCell";

@implementation CBLiveGiftViewVC

#pragma mark init
- (void)viewDidLoad {
    [super viewDidLoad];    
    [self _UI_setup];
    [self httpGetGiftList];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.bottomConstraint.constant = self.bottomConstraint.constant - SafeAreaBottomHeight;
}

- (void)httpGetGiftList{
    NSString *url = urlGetGiftList;
    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken]};
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param responseCache:^(id responseCache) {
        @strongify(self);
        self.giftAry = [NSArray modelArrayWithClass:[CBGiftVO class] json:responseCache[@"data"]];
        CBGiftVO *vo = self.giftAry.firstObject;
        vo.selected = YES;
        [self.giftCollectionView reloadData];
        // 设置选择器页面数量
        self.pageControl.numberOfPages = (int)ceilf(self.giftAry.count/8.0);
    } success:^(id responseObject) {
        @strongify(self);
        self.giftAry = [NSArray modelArrayWithClass:[CBGiftVO class] json:responseObject[@"data"]];
        CBGiftVO *vo = self.giftAry.firstObject;
        vo.selected = YES;
        self.selectGiftVO = vo;
        [self.giftCollectionView reloadData];
        // 设置选择器页面数量
        self.pageControl.numberOfPages = (int)ceilf(self.giftAry.count/8.0);
    } failure:^(NSError *error) {
        
    }];
}

- (void)_UI_setup{
    self.collectionViewLayout.rowCount = 2;
    self.collectionViewLayout.itemCountPerRow = 4;
    [self.collectionViewLayout setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置滚动方向
    self.collectionViewLayout.itemSize = CGSizeMake(kScreenWidth/4, 124);//设置cell的size
    self.collectionViewLayout.minimumLineSpacing = 0;//行间距
    self.collectionViewLayout.minimumInteritemSpacing = 0;//同行之间item间距
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"CBGiftCell" bundle:nil] forCellWithReuseIdentifier:KReuseIdGiftCell];
    
    self.countBtnAry = @[self.countABtn, self.countBBtn, self.countCBtn, self.countDBtn, self.countEBtn];

//    self.giftView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6f];
//    [self.giftView addSubview:self.giftCollectionView];
//    [self.giftView addSubview:self.pageControl];
//
//    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(248);
//        make.left.offset(kScreenWidth/2);
//        make.size.mas_equalTo(CGSizeMake(0,15));
//    }];
//    [self.giftView addSubview:self.btnView];
//    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(260);
//        make.left.offset(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth,self.giftView.frame.size.height - 260 - 34));
//    }];
//    [self.btnView addSubview:self.sendBtn];
//    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(0);
//        make.right.offset(-10);//????
//        make.size.mas_equalTo(CGSizeMake(70, 30));
//    }];
//
//    [self.btnView addSubview:self.coinMarkImg];
//    [self.coinMarkImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.sendBtn.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(14, 14));
//        make.left.offset(10);
//    }];
//    UILabel *coinLabel = [[UILabel alloc]init];
//    coinLabel.text = @"首充";
//    coinLabel.textColor = [UIColor colorWithRed:243.0/255.0 green:194.0/255.0 blue:45.0/255.0 alpha:1];
//    coinLabel.font = [UIFont systemFontOfSize:14];
//    [self.btnView addSubview:coinLabel];
//    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.coinMarkImg.mas_centerY);
//        make.left.equalTo(self.coinMarkImg.mas_right).with.offset(2);
//    }];
//    UIImageView *payArrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_arrow"]];
//    payArrowImg.contentMode = UIViewContentModeScaleAspectFit;
//    [self.btnView addSubview:payArrowImg];
//    [payArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@15);
//        make.width.equalTo(@19);
//        make.centerY.equalTo(self.sendBtn.mas_centerY);
//        make.left.equalTo(coinLabel.mas_right).offset(0);
//    }];
//    [self.btnView addSubview:self.diamondCount];
//    [self.diamondCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.coinMarkImg.mas_centerY);
//        make.left.equalTo(payArrowImg.mas_right).with.offset(2);
//    }];
//    UIImageView *diamondImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"first_charge_reward_diamond"]];
//
//    [self.btnView addSubview:diamondImg];
//    [diamondImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.sendBtn.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(13, 13));
//        make.left.equalTo(self.diamondCount.mas_right).with.offset(2);
//    }];
//    [self.btnView addSubview:self.starCount];
//    [self.starCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.coinMarkImg.mas_centerY);
//        make.left.equalTo(diamondImg.mas_right).with.offset(2);
//    }];
//    UIImageView *starImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"first_charge_reward_star"]];
//
//    [self.btnView addSubview:starImg];
//    [starImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.sendBtn.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(13, 13));
//        make.left.equalTo(self.starCount.mas_right).with.offset(2);
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查找父控制器
- (UIViewController *)superViewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)actionBtnSendGift {
    NSLog(@"发送了*************************************%@", self.selectGiftVO.giftname);
    self.giftCollectionView.userInteractionEnabled = NO;
    
//    NSString *lianfa = @"y";
//    _push.enabled = NO;
//    _push.backgroundColor = [UIColor lightGrayColor];
//    NSLog(@"发送了%@",_selectModel.giftname);
//    //判断连发
//    if ([_selectModel.type isEqualToString:@"0"]) {
//        lianfa = @"n";
//        _continuBTN.hidden = YES;
//        _push.enabled = YES;
//        _push.backgroundColor = normalColors;
//        self.collectionView.userInteractionEnabled = YES;
//    }
//    else{
//        _continuBTN.hidden = NO;
//        a = 30;
//        if(timer == nil)
//        {
//            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(jishiqi) userInfo:nil repeats:YES];
//        }
//        if(sender == _push)
//        {
//            [timer setFireDate:[NSDate date]];
//        }
//    }
    NSString *url = urlSendGiftToAnchor;
    NSDictionary *param = @{
                            @"token":[CBLiveUserConfig getOwnToken],
                            @"room_id": self.superController.liveVO.room_id,
                            @"giftid": self.selectGiftVO.giftid,
                            @"number":@"1"
                            };
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@200]) {
            [self.superController closeGiftView];
            
            CBLiveUser *user = [CBLiveUserConfig myProfile];
            NSDictionary *dictExt = @{
                                      @"senderUID": user.ID,
                                      @"senderName": user.user_nicename,
                                      @"senderAvater": user.avatar,
                                      @"giftID": self.selectGiftVO.giftid,
                                      @"giftName": self.selectGiftVO.giftname,
                                      @"giftImageURL": self.selectGiftVO.gifticon,
                                      @"giftNum": @"3"
                                      };
            [self _EMClient_SendGiftMessage:dictExt];
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
            self.giftCollectionView.userInteractionEnabled = YES;
        }
    } failure:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD showAutoMessage:@"礼物赠送失败"];
        self.giftCollectionView.userInteractionEnabled = YES;
    }];
}

- (void)_EMClient_SendGiftMessage:(NSDictionary *)dictExt {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionLiveSentGiftDict:)]) {
        [self.delegate actionLiveSentGiftDict:dictExt];
        self.giftCollectionView.userInteractionEnabled = YES;
    }
}

- (IBAction)actionCountBtn:(id)sender {
    
}

#pragma mark 手势事件

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if(CGRectContainsPoint(self.giftView.frame, point)){
        NSLog(@"范围内");
    } else {
        [self.superController closeGiftView];
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.giftAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CBGiftCell *cell = [self.giftCollectionView dequeueReusableCellWithReuseIdentifier:KReuseIdGiftCell forIndexPath:indexPath];
    cell.gift = self.giftAry[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    for (CBGiftVO *vo in self.giftAry) {
        vo.selected = NO;
    }
    CBGiftVO *giftVO = self.giftAry[indexPath.row];
    giftVO.selected = YES;
    self.selectGiftVO = giftVO;
    [self.giftCollectionView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    self.pageControl.currentPage = offset/kScreenWidth;
}

#pragma mark - lazy

- (UILabel *)starCount{
    if(!_starCount){
        _starCount = [[UILabel alloc]init];
        _starCount.text = @"9999999";
        _starCount.textColor = [UIColor colorWithRed:253.0/255.0 green:227.0/255.0 blue:180.0/255.0 alpha:1];
        _starCount.font = [UIFont systemFontOfSize:13];
    }
    return _starCount;
}

- (UILabel *)diamondCount{
    if(!_diamondCount){
        _diamondCount = [[UILabel alloc]init];
        _diamondCount.text = @"9999999";
        _diamondCount.textColor = [UIColor colorWithRed:243.0/255.0 green:194.0/255.0 blue:45.0/255.0 alpha:1];
        _diamondCount.font = [UIFont systemFontOfSize:13];
    }
    return _diamondCount;
}

- (UIImageView *)coinMarkImg{
    if(!_coinMarkImg){
        _coinMarkImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"first_charge_icon"]];
    }
    return _coinMarkImg;
}

- (UIButton *)sendBtn{
    if(!_sendBtn){
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:214.0/255.0 blue:215.0/255.0 alpha:1];
        [_sendBtn setTitle:@"发 送" forState: UIControlStateNormal];
        _sendBtn.layer.cornerRadius = 15;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        //设置字体
        [_sendBtn setTintColor:[UIColor whiteColor]];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setTarget:self action:@selector(actionBtnSendGift) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIView *)btnView{
    if(!_btnView){
        _btnView = [[UIView alloc]init];
    }
    return _btnView;
}

- (CBLiveChatViewVC *)superController{
    if (!_superController) {
        UIViewController *vc = [UIViewController superViewController:self];
        if ([vc isKindOfClass:[CBLiveChatViewVC class]]) {
            _superController = (CBLiveChatViewVC *)vc;
        }
    }
    return _superController;
}

- (NSArray<CBGiftVO *> *)giftAry {
    if (!_giftAry) {
        _giftAry = [NSArray array];
    }
    return _giftAry;
}

@end
