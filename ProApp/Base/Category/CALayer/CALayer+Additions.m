//
//  CALayer+Additions.m
//  hxjj
//
//  Created by ttouch on 15/7/2.
//  Copyright (c) 2015年 ttouch. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

- (void)setShadowColorFromUIColor:(UIColor *)color {
    self.shadowColor = color.CGColor;
}
@end
