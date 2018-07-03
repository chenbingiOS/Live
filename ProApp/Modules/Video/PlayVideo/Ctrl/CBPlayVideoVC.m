//
//  CBPlayVideoVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPlayVideoVC.h"
#import "CBShortVideoVO.h"
#import <PLPlayerKit/PLPlayerKit.h>

@interface CBPlayVideoVC () 

@end

@implementation CBPlayVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - Set
- (void)setVideo:(CBShortVideoVO *)video {
    _video = video;
    self.url = [NSURL URLWithString:video.href];
}


@end
