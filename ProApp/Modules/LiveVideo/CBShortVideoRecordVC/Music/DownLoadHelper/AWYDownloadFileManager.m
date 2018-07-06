//
//  AWYDownloadFileManager.m
//  AWYDownloadHelper
//
//  Created by awyys on 2017/6/17.
//  Copyright © 2017年 awyys. All rights reserved.
//

#import "AWYDownloadFileManager.h"

@implementation AWYDownloadFileManager
+(BOOL)isFileExist:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
+(long long)fileSize:(NSString *)path{
    if (![self isFileExist:path]) {
        return 0;
    }
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    long long fileSize = [dic[NSFileSize] longLongValue];
    return fileSize;
}
+(void)removeFile:(NSString *)path{
    if (![self isFileExist:path]) {
        return;
    }
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
+(void)moveFile:(NSString *)path toNewPath:(NSString *)newPath{
    if (![self isFileExist:path]) {
        return;
    }
    [[NSFileManager defaultManager] moveItemAtPath:path toPath:newPath error:nil];
}
@end
