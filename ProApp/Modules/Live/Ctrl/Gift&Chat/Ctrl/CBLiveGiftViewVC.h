//
//  CBLiveGiftViewVC.h
//  ProApp
//
//  Created by hxbjt on 2018/6/22.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBLiveChatViewVC.h"

@protocol CBLiveGiftViewDelegate <NSObject>

- (void)actionLiveSentGiftDict:(NSDictionary *)giftDict;

@end

@interface CBLiveGiftViewVC : UIViewController

@property (nonatomic, weak) id<CBLiveGiftViewDelegate> delegate;
@property (nonatomic, strong) CBLiveChatViewVC *superController;

@end
