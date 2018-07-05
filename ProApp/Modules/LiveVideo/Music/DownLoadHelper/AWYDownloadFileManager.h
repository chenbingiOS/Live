//
//  AWYDownloadFileManager.h
//  AWYDownloadHelper
//
//  Created by awyys on 2017/6/17.
//  Copyright © 2017年 awyys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWYDownloadFileManager : NSObject
+(BOOL)isFileExist:(NSString *)path;
+(long long)fileSize:(NSString *)path;
+(void)removeFile:(NSString *)path;
+(void)moveFile:(NSString *)path toNewPath:(NSString *)newPath;
@end
