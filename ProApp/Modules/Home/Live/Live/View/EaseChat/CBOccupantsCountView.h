//
//  CBOccupantsCountView.h
//  ProApp
//
//  Created by hxbjt on 2018/6/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseLiveHeaderListView.h"

@class CBAppLiveVO;
@interface CBOccupantsCountView : UIView

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO *)room;

@property (nonatomic, weak) id<EaseLiveHeaderListViewDelegate> delegate;

@end
