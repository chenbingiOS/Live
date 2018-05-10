//
//  CBAnchorInfoXibView.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAnchorInfoXibView.h"
#import "UIImageView+RoundedCorner.h"

@interface CBAnchorInfoXibView ()

@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;

@end

@implementation CBAnchorInfoXibView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avaterImageView roundedCornerByDefault];
}

@end
