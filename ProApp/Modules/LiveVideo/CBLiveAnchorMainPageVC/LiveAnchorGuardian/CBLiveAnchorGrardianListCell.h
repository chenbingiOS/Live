//
//  CBLiveAnchorGrardianListCell.h
//  ProApp
//
//  Created by hxbjt on 2018/7/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBLiveUser;
@interface CBLiveAnchorGrardianListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *guardianImageView;

@property (nonatomic, strong) CBLiveUser *liveUser;

@end
