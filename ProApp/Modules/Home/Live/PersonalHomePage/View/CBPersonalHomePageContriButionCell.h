//
//  CBPersonalHomePageContriButionCell.h
//  ProApp
//
//  Created by hxbjt on 2018/7/16.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBAnchorInfoVO;
@interface CBPersonalHomePageContriButionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *maxGuardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *minGuardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *AImageView;
@property (weak, nonatomic) IBOutlet UIImageView *BImageView;
@property (weak, nonatomic) IBOutlet UIImageView *CImageView;

@property (weak, nonatomic) IBOutlet UIImageView *AAImageView;
@property (weak, nonatomic) IBOutlet UIImageView *BBImageView;
@property (weak, nonatomic) IBOutlet UIImageView *CCImageView;

@property (nonatomic, strong) CBAnchorInfoVO *infoVO;

@end
