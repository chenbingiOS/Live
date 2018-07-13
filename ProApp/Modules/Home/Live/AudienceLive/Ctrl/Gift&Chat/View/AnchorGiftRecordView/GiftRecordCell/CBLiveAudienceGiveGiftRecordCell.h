//
//  CBLiveAudienceGiveGiftRecordCell.h
//  ProApp
//
//  Created by hxbjt on 2018/7/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLiveAudienceGiveGiftRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNickLab;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *coinLab;

@property (nonatomic, strong) CBLiveUser *liveUser;

@end
