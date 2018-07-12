//
//  CBGuardRankCCell.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBLiveUser;
@interface CBGuardRankCCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNickLab;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *coinLab;

@property (nonatomic, strong) CBLiveUser *liveUser;

@end
