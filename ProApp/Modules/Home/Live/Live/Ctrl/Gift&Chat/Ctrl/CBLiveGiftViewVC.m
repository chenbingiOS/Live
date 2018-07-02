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
// Category
#import "UIViewController+SuperViewCtrl.h"
// Model
#import "CBGiftVO.h"
#import "CBAppLiveVO.h"
#import "CBChatGiftMessageVO.h"
#import "CBGiftTypeVO.h"
// View
#import "CBGiftCell.h"
#import "TSCGifts.h"

@interface CBLiveGiftViewVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *giftTypeABtn;
@property (weak, nonatomic) IBOutlet UIButton *giftTypeBBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftTypeCBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftTypeDBtn;
@property (nonatomic, strong) NSArray <UIButton *> *giftTypeBtnAry;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UIButton *giftListBtn;
@property (weak, nonatomic) IBOutlet UIButton *warehouseListBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *countABtn;
@property (weak, nonatomic) IBOutlet UIButton *countBBtn;
@property (weak, nonatomic) IBOutlet UIButton *countCBtn;
@property (weak, nonatomic) IBOutlet UIButton *countDBtn;
@property (weak, nonatomic) IBOutlet UIButton *countEBtn;
@property (nonatomic, strong) NSArray <UIButton *> *countBtnAry;
@property (nonatomic, assign) NSNumber *countNum;
@property (weak, nonatomic) IBOutlet UILabel *moneyCountLab;
@property (weak, nonatomic) IBOutlet UIButton *sentGiftBtn;

@property (nonatomic, strong) CBGiftTypeVO *saveGiftAry;
@property (nonatomic, strong) NSArray <CBGiftVO *> *giftAry;
@property (nonatomic, strong) CBGiftVO *selectGiftVO;

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
        self.saveGiftAry = [CBGiftTypeVO modelWithJSON:responseCache[@"data"]];
        self.giftAry = self.saveGiftAry.putong;
        CBGiftVO *vo = self.giftAry.firstObject;
        vo.selected = YES;
        [self.giftCollectionView reloadData];
        self.selectGiftVO = vo;
        self.pageControl.numberOfPages = (int)ceilf(self.giftAry.count/8.0);
    } success:^(id responseObject) {
        @strongify(self);
        self.saveGiftAry = [CBGiftTypeVO modelWithJSON:responseObject[@"data"]];
        self.giftAry = self.saveGiftAry.putong;
        CBGiftVO *vo = self.giftAry.firstObject;
        vo.selected = YES;
        [self.giftCollectionView reloadData];
        self.selectGiftVO = vo;
        self.pageControl.numberOfPages = (int)ceilf(self.giftAry.count/8.0);
    } failure:^(NSError *error) {
        
    }];
}

- (void)_UI_setup{
    
    self.moneyCountLab.text = [CBLiveUserConfig myProfile].balance;
    self.countNum = @1;
    self.collectionViewLayout.itemSize = CGSizeMake(kScreenWidth/4-0.25, 110);
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"CBGiftCell" bundle:nil] forCellWithReuseIdentifier:KReuseIdGiftCell];
    
    self.countBtnAry = @[self.countABtn, self.countBBtn, self.countCBtn, self.countDBtn, self.countEBtn];
    self.giftTypeBtnAry = @[self.giftTypeABtn, self.giftTypeBBtn, self.giftTypeCBtn, self.giftTypeDBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            
            user.balance = ((NSNumber *)(responseObject[@"data"][@"balance"])).stringValue;
            user.user_level = ((NSNumber *)(responseObject[@"data"][@"user_level"])).stringValue;
            [CBLiveUserConfig saveProfile:user];
            self.moneyCountLab.text = user.balance;
            [self _EMClient_SendGiftMessage:dictExt];
            
            NSString *award = responseObject[@"data"][@"award"];
            if (award.length > 0) {
                [MBProgressHUD showAutoMessage:award];
            }
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [MBProgressHUD hideHUDForView:self.giftView animated:YES];
    } failure:^(NSError *error) {
        @strongify(self);
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

- (IBAction)actionGiftTypeBtn:(UIButton *)sender {
    
    [self.giftTypeBtnAry enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    sender.selected = YES;
    
    if (sender.tag == 11) {
        self.giftAry = self.saveGiftAry.putong;
    } else if (sender.tag == 22) {
        self.giftAry = self.saveGiftAry.guizu;
    } else if (sender.tag == 33) {
        self.giftAry = self.saveGiftAry.xingyun;
    } else if (sender.tag == 44) {
//        [self httpLoad]
    }

    [self.countBtnAry enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sender.tag == 11) {
            obj.alpha = 1;
        } else {
            obj.alpha = 0;
        }
        obj.selected = NO;
        if (idx == 0) {
            obj.alpha = 1;
            obj.selected = YES;
        }
    }];
    
    @weakify(self);
    [self.giftAry enumerateObjectsUsingBlock:^(CBGiftVO * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            @strongify(self);
            obj.selected = YES;
            self.selectGiftVO = obj;
        } else {
            obj.selected = NO;
        }
    }];
    self.pageControl.numberOfPages = (int)ceilf(self.giftAry.count/8.0);
    [self.giftCollectionView reloadData];
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

- (CBLiveChatViewVC *)superController{
    if (!_superController) {
        UIViewController *vc = [UIViewController superViewController:self];
        if ([vc isKindOfClass:[CBLiveChatViewVC class]]) {
            _superController = (CBLiveChatViewVC *)vc;
        }
    }
    return _superController;
}

- (NSArray <CBGiftVO *> *)giftAry {
    if (!_giftAry) {
        _giftAry = [NSArray array];
    }
    return _giftAry;
}

@end
