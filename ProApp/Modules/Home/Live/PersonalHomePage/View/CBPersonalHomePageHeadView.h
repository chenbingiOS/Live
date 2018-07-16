//
//  CBPersonalHomePageHeadView.h
//  ProApp
//
//  Created by hxbjt on 2018/7/12.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBLiveUser;
@interface CBPersonalHomePageHeadView : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipLevelImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UILabel *attentionLab;
@property (weak, nonatomic) IBOutlet UILabel *guardLab;

@property (nonatomic, strong) CBLiveUser *liveUser;

@end
