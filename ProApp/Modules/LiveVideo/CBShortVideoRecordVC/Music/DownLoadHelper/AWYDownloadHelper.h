//
//  AWYDownloadHelper.h
//  AWYDownloadHelper
//
//  Created by awyys on 2017/6/17.
//  Copyright © 2017年 awyys. All rights reserved.
//

#import <Foundation/Foundation.h>
#define cachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define tempPath NSTemporaryDirectory()

typedef NS_OPTIONS(NSInteger, downLoadState){
    downLoadStatePause,
    downLoadStateDownLoading,
    downLoadStateCompleteSuccess,
    downLoadStateCompleteFailure
};
typedef void(^downLoadInfo)(long long fileTotalSize);
typedef void(^downLoadSuccess)(NSString *filePath);
typedef void(^downLoadStateChange)(downLoadState state);
typedef void(^downLoadProgressChange)(float progress);
typedef void(^downLoadFailed)(void);

@interface AWYDownloadHelper : NSObject

-(void)downloadWithURL:(NSURL *)url downInfo:(downLoadInfo)info downloadState:(downLoadStateChange)change progress:(downLoadProgressChange)progress success:(downLoadSuccess)success error:(downLoadFailed)failed;
-(void)downloadWithURL:(NSURL *)url;
-(void)pause;
-(void)resumeTask;
-(void)cancel;
-(void)cancelAndDeleteTask;

@property (nonatomic,assign,readonly)downLoadState state;
@property (nonatomic,assign,readonly)float progress;
@property (nonatomic,copy)downLoadInfo downLoadInfo;
@property (nonatomic,copy)downLoadSuccess downLoadSuccess;
@property (nonatomic,copy)downLoadStateChange stateChange;
@property (nonatomic,copy)downLoadProgressChange progressChange;
@property (nonatomic,copy)downLoadFailed downloadFailed;
@end
