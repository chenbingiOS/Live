//
//  CBGiftCell.m
//  Test-inke
//
//  Created by 唐嗣成 on 2017/12/7.
//  Copyright © 2017年 shawnTang. All rights reserved.
//

#import "CBGiftCell.h"
#import "UIImageView+SDWebImage.h"
#import "TSCGifts.h"

@interface CBGiftCell()
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet UILabel *countLable;
@property (weak, nonatomic) IBOutlet UIImageView *countType;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation CBGiftCell

- (void)setGift:(CBGiftVO *)gift{
    _gift = gift;
    [self.giftImage downloadImage:gift.gifticon placeholder:@"placeholder_head" success:^(UIImage *image) {
        self.giftName.text = gift.giftname;
        self.typeImage.hidden = YES;
        if ([gift.continuous isEqualToString:@"1"]){
            self.typeImage.hidden = NO;
        }
        self.countLable.text = gift.needcoin;
        self.countType.image = [UIImage imageNamed:@"first_charge_reward_diamond"];
    } failed:^(NSError *error) {

    } progress:^(CGFloat progress) {
        
    }];
   
    if (_gift.isSelected == YES){
        [self showAnimation];
    } else {
        [self stopAnimation];
    }
}

- (void)showAnimation {
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor mainColor].CGColor;
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    // 开始时间 DISPATCH_TIME_NOW ，提交时间 1 * NSEC_PER_SEC（一秒后）
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{//设置响应dispatch源事件的block，在dispatch源指定的队列上运行
        self.giftImage.layer.transform = CATransform3DMakeScale(1, 1, 1);
        [UIView animateWithDuration:1 animations:^{
            self.giftImage.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        }];
        [UIView animateWithDuration:1 animations:^{
            self.giftImage.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        }];
        [UIView animateWithDuration:1 animations:^{
            self.giftImage.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
    });
    
    //执行
    dispatch_resume(self.timer);
    
}

- (void)stopAnimation {
    
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = [UIColor colorWithRed:43.0/225.0 green:43.0/255.0 blue:59.0/225.0 alpha:1].CGColor;
    
    if (self.timer !=nil){
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

@end
