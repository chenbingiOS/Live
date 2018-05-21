//
//  CBAppADCell.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/21.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBAppADVO;
@interface CBAppADCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CBAppADVO *appAdVO;

@end
