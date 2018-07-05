//
//  NSString+MD5.m
//  AWYDownloadHelper
//
//  Created by awyys on 2017/6/17.
//  Copyright © 2017年 awyys. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (MD5)
-(NSString *)MD5String{
    const char *data = self.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, (CC_LONG)(strlen(data)), digest);
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [string appendFormat:@"%02x",digest[i] ];
    }
    return string;
}
@end
