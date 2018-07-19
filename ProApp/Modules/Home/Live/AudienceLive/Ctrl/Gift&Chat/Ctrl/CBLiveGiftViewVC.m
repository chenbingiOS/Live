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
@property (weak, nonatomic) IBOutlet UILabel *moneyCountLab;
@property (nonatomic, assign) NSNumber *countNum;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *doubleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *doubleImageView;
@property (nonatomic, strong) CBGiftTypeVO *saveGiftAry;
@property (nonatomic, strong) NSArray <CBGiftVO *> *giftAry;
@property (nonatomic, strong) CBGiftVO *selectGiftVO;
@property (weak, nonatomic) IBOutlet UIView *bgBtnView;
@property (nonatomic, strong) NSTimer *counddownTimer;
@property (nonatomic, assign) NSInteger authCodeTime;
@end

static NSString *const KReuseIdGiftCell = @"KReuseIdGiftCell";

@implementation CBLiveGiftViewVC

#pragma mark init
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _UI_setup];
    [self httpGetGiftList];
}

- (void)_UI_setup{
    self.doubleBtn.titleLabel.numberOfLines = 2;
    self.moneyCountLab.text = [CBLiveUserConfig myProfile].balance;
    self.countNum = @1;
    self.collectionViewLayout.itemSize = CGSizeMake(kScreenWidth/4-0.25, 95);
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"CBGiftCell" bundle:nil] forCellWithReuseIdentifier:KReuseIdGiftCell];
    
    self.giftTypeBtnAry = @[self.giftTypeABtn, self.giftTypeBBtn, self.giftTypeCBtn, self.giftTypeDBtn];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.bottomConstraint.constant = self.bottomConstraint.constant - SafeAreaBottomHeight;
}

#pragma mark - HTTP
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

- (void)httpSendGiftToAnchor {
    NSString *url = urlSendGiftToAnchor;
    NSNumber *countNum = [self.selectGiftVO.continuous isEqualToString:@"1"] ? self.countNum : @1;
    NSDictionary *param = @{
                            @"token":[CBLiveUserConfig getOwnToken],
                            @"room_id": self.superController.liveVO.room_id,
                            @"giftid": self.selectGiftVO.giftid,
                            @"number": countNum
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
            
            user.balance = responseObject[@"data"][@"balance"];
            user.user_level = responseObject[@"data"][@"user_level"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action
- (IBAction)actionBtnSendGift:(UIButton *)sender {
    if ([self.selectGiftVO.continuous isEqualToString:@"1"]) {
        [self countdownBtnByRelay];
//        [self httpSendGiftToAnchor];
    } else {
//        [self httpSendGiftToAnchor];
    }
}

- (IBAction)actionGiftTypeBtn:(UIButton *)sender {
    [self hideBgBtnView];
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

- (IBAction)actionLeftBtn:(UIButton *)sender {
    if (self.bgBtnView.hidden) {
        self.bgBtnView.hidden = NO;
        self.bgBtnView.alpha = 0;
        @weakify(self);
        [UIView animateWithDuration:0.35 animations:^{
            @strongify(self);
            self.bgBtnView.alpha = 1;
        }];
    } else {
        [self hideBgBtnView];
    }
}

- (IBAction)actionCountNumBtn:(UIButton *)sender {
    [self hideBgBtnView];
    [self.leftBtn setTitle:@(sender.tag).stringValue forState:UIControlStateNormal];
    self.countNum = @(sender.tag);
    if (sender.tag == 0) {
        
    } else if (sender.tag == 1) {
        
    } else if (sender.tag == 10) {
        
    } else if (sender.tag == 30) {
        
    } else if (sender.tag == 66) {
        
    } else if (sender.tag == 188) {
        
    } else if (sender.tag == 520) {
        
    } else if (sender.tag == 1314) {
        
    }
}

- (IBAction)actionDoubleBtn:(id)sender {
    [self countdownBtnByRelay];
}

- (void)hideBgBtnView {
    if (!self.bgBtnView.hidden) {
        self.bgBtnView.alpha = 1;
        @weakify(self);
        [UIView animateWithDuration:0.35 animations:^{
            @strongify(self);
            self.bgBtnView.alpha = 0;
        } completion:^(BOOL finished) {
            @strongify(self);
            self.bgBtnView.hidden = YES;
        }];
    }
}

- (void)resetLeftRightBtnWithCont:(NSString *)continuous {
    if ([continuous isEqualToString:@"1"]) {
        self.leftBtn.hidden = NO;
        [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"gift_left_btn"] forState:UIControlStateNormal];
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"gift_right_btn"] forState:UIControlStateNormal];
    } else {
        self.leftBtn.hidden = YES;
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"gift_single_btn"] forState:UIControlStateNormal];
    }
}

- (void)countdownBtnByRelay {
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.doubleBtn.hidden = NO;
    self.doubleImageView.hidden = NO;
    [self.counddownTimer invalidate];
    self.counddownTimer = nil;
    self.authCodeTime = 3;
    NSString *title = [NSString stringWithFormat:@"%d", (int)self.authCodeTime];
    [self.doubleBtn setTitle:title forState:UIControlStateNormal];
    if (self.counddownTimer == nil) {
        self.counddownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTimeCountDown) userInfo:nil repeats:YES];
        [self.counddownTimer fire];
        [self imageAnimation];
    }
}

//获取验证码倒计时
-(void)actionTimeCountDown {
    NSString *title = [NSString stringWithFormat:@"%d", (int)self.authCodeTime];
    [self.doubleBtn setTitle:title forState:UIControlStateNormal];
    if (self.authCodeTime <= 0) {
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        self.doubleBtn.hidden = YES;
        self.doubleImageView.hidden = YES;
        [self.counddownTimer invalidate];
        self.counddownTimer = nil;
        self.authCodeTime = 3;
    }
    self.authCodeTime -= 1;
}

- (void)imageAnimation {
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 3; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.doubleImageView.layer addAnimation:animation forKey:nil];
}

#pragma mark 手势事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
    [self hideBgBtnView];
    for (CBGiftVO *vo in self.giftAry) {
        vo.selected = NO;
    }
    CBGiftVO *giftVO = self.giftAry[indexPath.row];
    giftVO.selected = YES;
    self.selectGiftVO = giftVO;
    [self resetLeftRightBtnWithCont:giftVO.continuous];
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
