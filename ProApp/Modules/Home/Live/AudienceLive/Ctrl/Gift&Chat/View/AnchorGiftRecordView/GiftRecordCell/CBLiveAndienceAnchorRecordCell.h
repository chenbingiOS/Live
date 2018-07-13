//
//  CBLiveAndienceAnchorRecordCell.h
//  ProApp
//
//  Created by hxbjt on 2018/7/13.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLiveAndienceAnchorRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNickNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftCountLab;

@property (nonatomic, strong) CBLiveUser *liveUser;

@end
