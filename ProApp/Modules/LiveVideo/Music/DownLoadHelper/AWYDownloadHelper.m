//
//  AWYDownloadHelper.m
//  AWYDownloadHelper
//
//  Created by awyys on 2017/6/17.
//  Copyright © 2017年 awyys. All rights reserved.
//

#import "AWYDownloadHelper.h"
#import "NSString+MD5.h"
#import "AWYDownloadFileManager.h"

@interface AWYDownloadHelper()<NSURLSessionDelegate>
{
    long long  _tempFileSize;
    long long _totalFileSize;
}
@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,copy)NSString *fileTempPath;
@property(nonatomic,copy)NSString *fileCachePath;
@property(nonatomic,weak)NSURLSessionDataTask *task;
@property(nonatomic,strong)NSOutputStream *stream;
@property(nonatomic,weak)NSTimer *timer;
@end
@implementation AWYDownloadHelper
//-(NSTimer *)timer{
//    if (!_timer) {
//        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(show) userInfo:nil repeats:YES];
//        self.timer = timer;
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    }
//    return  _timer;
//}
//-(void)show{
//    NSLog(@"-------%zd",self.state);
//}
-(NSOutputStream *)stream{
    if (!_stream) {
        NSOutputStream *stream = [[NSOutputStream alloc] init];
        _stream = stream;
    }
    return  _stream;
}
-(NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
-(void)downloadWithURL:(NSURL *)url downInfo:(downLoadInfo)info downloadState:(downLoadStateChange)change progress:(downLoadProgressChange)progress success:(downLoadSuccess)success error:(downLoadFailed)failed{
    self.downLoadInfo = info;
    self.stateChange = change;
    self.progressChange = progress;
    self.downLoadSuccess = success;
    self.downloadFailed = failed;
    
    [self downloadWithURL:url];
    
    
}
-(void)downloadWithURL:(NSURL *)url{
//    [self timer];
    
    //建立两个文件夹，temp存到一个文件夹，full存到一个文件夹
    self.fileCachePath = [cachePath stringByAppendingPathComponent:url.lastPathComponent];
    self.fileTempPath = [tempPath stringByAppendingPathComponent:[url.absoluteString MD5String]];
    //1 首先判断本地是否已经下载好，有的话直接return
    if ([AWYDownloadFileManager isFileExist:self.fileCachePath]) {
        self.state = downLoadStateCompleteSuccess;
        return;
        
    }
    if (self.task && [self.task.originalRequest.URL isEqual:url]) {
        [self resumeTask];
    }
    //2 本地没有下载完成，查看临时下载大小,在代理方法中进行比较，这么做的原因是避免了多次发送请求，这里只要拿到header信息就可以。
    _tempFileSize = [AWYDownloadFileManager fileSize:self.fileTempPath];
    
    [self downloadWithURL:url offset:_tempFileSize];
    //3 设置session的代理，分别实现两个方法，第一次收到请求返回（可以得到header去查看里边的range或者content） 下载随时返回的方法。
    
}
-(void)setState:(downLoadState)state{
    _state = state;
    if (self.stateChange) {
        self.stateChange(state);
    }
    if (self.downLoadSuccess && state==downLoadStateCompleteSuccess) {
        self.downLoadSuccess(_fileCachePath);
    }
}
-(void)downloadWithURL:(NSURL *)url offset:(long long)fileSize{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-",fileSize] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    self.task = task;
    [self resumeTask];
    
}
-(void)resumeTask{
    if (self.task && (self.state == downLoadStatePause || self.state==downLoadStateCompleteFailure)) {
        [self.task resume];
        self.state = downLoadStateDownLoading;
    }
    
}
-(void)pause{
    if (self.task && self.state == downLoadStateDownLoading) {
        [self.task suspend];
        self.state = downLoadStatePause;
    }
    
}
-(void)cancel{
    if (self.task) {
        
        [self.session invalidateAndCancel];
        self.session = nil;
        self.state = downLoadStateCompleteFailure;
    }
}
-(void)cancelAndDeleteTask{
    [self cancel];
    [AWYDownloadFileManager removeFile:self.fileTempPath];
}

- (void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSHTTPURLResponse *hResponse = (NSHTTPURLResponse *)response;
    _totalFileSize = [hResponse.allHeaderFields[@"Content-Length"] longLongValue];
    if (hResponse.allHeaderFields[@"Content-Range"]) {
        _totalFileSize = [[hResponse.allHeaderFields[@"Content-Range"] componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    if (self.downLoadInfo) {
        self.downLoadInfo(_totalFileSize);
    }
    if (_tempFileSize > _totalFileSize) {
        [AWYDownloadFileManager removeFile:self.fileTempPath];
        completionHandler(NSURLSessionResponseCancel);
        [self downloadWithURL:response.URL offset:0];
        self.state = downLoadStateCompleteFailure;
        return;
    }
    if (_tempFileSize == _totalFileSize) {
        [AWYDownloadFileManager moveFile:self.fileTempPath toNewPath:self.fileCachePath];
        completionHandler(NSURLSessionResponseCancel);
        self.state = downLoadStateCompleteSuccess;
        return;
    }
    self.stream = [NSOutputStream outputStreamToFileAtPath:self.fileTempPath append:YES];
    [self.stream open];
        completionHandler(NSURLSessionResponseAllow);
    
}
-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data{
    _tempFileSize += data.length;
    self.progress = _tempFileSize*1.0/_totalFileSize * 1.0;
    if (self.progressChange) {
        self.progressChange(_progress);
    }
    
    [self.stream write:data.bytes maxLength:data.length];
}
-(void)setProgress:(float)progress{
    _progress = progress;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
    didCompleteWithError:(nullable NSError *)error{
    if (error) {
        if (error.code == -999) {
            self.state = downLoadStatePause;
        }else{
            self.state = downLoadStateCompleteFailure;
            if (self.downloadFailed) {
                self.downloadFailed();
            }
        }
    }else{
        self.state = downLoadStateCompleteSuccess;
        [AWYDownloadFileManager moveFile:_fileTempPath toNewPath:_fileCachePath];
    }
}
@end
