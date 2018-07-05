//
//  ANMusicTableViewController.h
//  ProApp
//
//  Created by 林景安 on 2018/6/28.
//  Copyright © 2018年  All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ANMusicModel.h"

@protocol ANMusicDidSelectedDelegate<NSObject>
@required

-(void)didSelectedMusic:(ANMusicModel *)musicModel;

@end

@interface ANMusicTableViewController : UITableViewController

@property (nonatomic, weak) id <ANMusicDidSelectedDelegate> delegate;
@end
