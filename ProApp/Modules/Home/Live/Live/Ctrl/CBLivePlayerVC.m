//
//  CBLivePlayerVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLivePlayerVC.h"
#import "ALinLive.h"

@implementation CBLivePlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setLive:(ALinLive *)live {
    _live = live;
    self.url = [NSURL URLWithString:live.flv];
    self.thumbImageURL = [NSURL URLWithString:live.bigpic];
}

@end
 
