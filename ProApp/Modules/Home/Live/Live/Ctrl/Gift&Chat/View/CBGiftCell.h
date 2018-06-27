//
//  CBGiftCell.h
//  Test-inke
//
//  Created by 唐嗣成 on 2017/12/7.
//  Copyright © 2017年 shawnTang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBGiftVO.h"

@interface CBGiftCell : UICollectionViewCell

@property (nonatomic,strong) CBGiftVO *gift;
- (void) showAnimation;
- (void) stopAnimation;

@end
