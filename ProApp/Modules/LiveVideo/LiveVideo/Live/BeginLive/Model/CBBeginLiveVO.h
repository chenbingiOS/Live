//
//  CBBeginLiveVO.h
//  ProApp
//
//  Created by hxbjt on 2018/6/12.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBMsgVO : NSObject

@end

@interface CBBeginLiveVO : NSObject

@property (nonatomic, copy) NSString *leancloud_room;
@property (nonatomic, copy) NSString *push_rtmp;
@property (nonatomic, strong) CBMsgVO *msg;
//@property (nonatomic, copy) NSString *leancloud_room;

@end
