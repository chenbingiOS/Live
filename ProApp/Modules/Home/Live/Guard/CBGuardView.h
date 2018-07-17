//
//  CBGuardView.h
//  ProApp
//
//  Created by hxbjt on 2018/7/16.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@interface CBGuardView : CBPopView

@property (nonatomic, strong) UIView *contentView;
- (void)loadRequestWithAnchorId:(NSString *)anchorId;

@end
