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
    self.countNum = @1;
    self.giftCollectionView.collectionViewLayout = self.collectionViewLayout;
    self.collectionViewLayout.rowCount = 2;
    self.collectionViewLayout.itemCountPerRow = 4;
    [self.collectionViewLayout setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置滚动方向
    self.collectionViewLayout.itemSize = CGSizeMake(kScreenWidth/4, 110);//设置cell的size
    self.collectionViewLayout.minimumLineSpacing = 0;//行间距
    self.collectionViewLayout.minimumInteritemSpacing = 0;//同行之间item间距
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"CBGiftCell" bundle:nil] forCellWithReuseIdentifier:KReuseIdGiftCell];
    
    self.countBtnAry = @[self.countABtn, self.countBBtn, self.countCBtn, self.countDBtn, self.countEBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBtnSendGift:(UIButton *)sender {
    NSString *url = urlSendGiftToAnchor;
    NSDictionary *param = @{
                            @"token":[CBLiveUserConfig getOwnToken],
                            @"room_id": self.superController.liveVO.room_id,
                            @"giftid": self.selectGiftVO.giftid,
                            @"number": self.countNum
                            };
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.giftView animated:YES];
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
                                      @"giftNum": self.countNum,
                                      @"giftSwf": self.selectGiftVO.giftswf
                                      };
            [self _EMClient_SendGiftMessage:dictExt];
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [MBProgressHUD hideHUDForView:self.giftView animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD showAutoMessage:@"礼物赠送失败"];
        [MBProgressHUD hideHUDForView:self.giftView animated:YES];
    }];
}

- (void)_EMClient_SendGiftMessage:(NSDictionary *)dictExt {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionLiveSentGiftDict:)]) {
        [self.delegate actionLiveSentGiftDict:dictExt];
    }
}

- (IBAction)actionCountBtn:(UIButton *)sender {
    [self.countBtnAry enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    sender.selected = YES;
    self.countNum = sender.titleLabel.text.numberValue;
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
