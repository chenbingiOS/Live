//
//  CBLiveAnchorView.m
//  MiaowShow
//
//  Created by ALin on 16/6/16.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "CBLiveAnchorView.h"
#import "ALinLive.h"
#import "ALinUser.h"
#import <UIImageView+WebCache.h>
#import "CBOnlineUserView.h"

@interface CBLiveAnchorView()

@property (weak, nonatomic) IBOutlet UIView *anchorView;        ///< 顶部信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;///< 头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        ///< 名字
@property (weak, nonatomic) IBOutlet UIButton *careBtn;         ///< 是否关注
@property (weak, nonatomic) IBOutlet UILabel *roomCodeLabel;    ///< 房间号
@property (weak, nonatomic) IBOutlet UIScrollView *peoplesScrollView;   ///< 观看人员

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *chaoYangUsers;

@end

@implementation CBLiveAnchorView

- (NSArray *)chaoYangUsers
{
    if (!_chaoYangUsers) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]];
//        _chaoYangUsers = [ALinUser mj_objectArrayWithKeyValuesArray:array];
    }
    return _chaoYangUsers;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self maskViewToBounds:self.anchorView];
    [self maskViewToBounds:self.headImageView];
    [self maskViewToBounds:self.careBtn];
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
//    [self.careBtn setBackgroundImage:[UIImage imageWithColor:KeyColor size:self.careBtn.size] forState:UIControlStateNormal];
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:self.careBtn.size] forState:UIControlStateSelected];
    [self setupChangeyang];
    
    // 默认是关闭的
    [self Device:self.careBtn];
}

- (void)maskViewToBounds:(UIView *)view
{
    view.layer.cornerRadius = view.height * 0.5;
    view.layer.masksToBounds = YES;
}

static int randomNum = 0;
- (void)setLive:(ALinLive *)live
{
    _live = live;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:live.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.nameLabel.text = live.myname;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNum) userInfo:nil repeats:YES];
}

- (void)updateNum
{
    randomNum += arc4random_uniform(5);
//    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人", self.live.allnum + randomNum];
    self.roomCodeLabel.text = [NSString stringWithFormat:@"房间号: 4345"];
}

- (void)setupChangeyang
{
//    self.peoplesScrollView.contentSize = CGSizeMake((self.peoplesScrollView.height + DefaultMargin) * self.chaoYangUsers.count + DefaultMargin, 0);
    CGFloat width = self.peoplesScrollView.height - 10;
    CGFloat x = 0;
    for (int i = 0; i<self.chaoYangUsers.count; i++) {
//        x = 0 + (DefaultMargin + width) * i;
        UIImageView *userView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, width, width)];
        userView.layer.cornerRadius = width * 0.5;
        userView.layer.masksToBounds = YES;
        ALinUser *user = self.chaoYangUsers[i];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:user.photo] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                userView.image = [UIImage circleImage:image borderColor:[UIColor whiteColor] borderWidth:1];
            });
        }];
        // 设置监听
        userView.userInteractionEnabled = YES;
        userView.tag = i;
        [self.peoplesScrollView addSubview:userView];
    }
}

- (IBAction)Device:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.clickDeviceShow) {
        self.clickDeviceShow(sender.selected);
    }
}


@end
