//
//  CBInterface.m
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBInterface.h"

@implementation CBInterface

+ (void)getPublishAddrWithRoomname:(NSString *)roomName completed:(void (^)(NSError *error, NSString *urlString))handler {
    
    NSString *url = urlGetPushAddress;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Authorization": [self AuthorizationFromText] };
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:config] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error, nil);
            });
            return;
        }
        
        NSDictionary *userDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if ([userDic[@"code"] integerValue] != 200) {
            NSError * userDicError = [NSError errorWithDomain:@"pili/v1/login" code:userDic[@"code"] userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"no authorized"]}];
            NSLog(@"no authorized %@", userDicError);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(userDicError,nil);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil, userDic[@"url"]);
        });
        
    }];
    [task resume];
    
}

+ (void)getPlayAddrWithRoomname:(NSString *)roomName completed:(void (^)(NSString *playUrl))handler {
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pili/v1/stream/query/%@",QINIUBaseDomain, roomName]];
    NSString *url = urlGetPushAddress;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Authorization": [self AuthorizationFromText] };
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:config] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil || response == nil || data == nil) {
            NSLog(@"get play url faild, %@, %@, %@", error, response, data);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil);
            });
            return;
        }
        NSDictionary *userDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if (userDic == nil || [userDic[@"code"] integerValue] != 200) {
            NSLog(@"no authorized");
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil);
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(userDic[@"rtmp"]);
        });
    }];
    [task resume];
}

+ (void)getRTCTokenWithRoomToken:(NSString *)roomName userID:(NSString *)userID completed:(void (^)(NSError *error, NSString *token))handler {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Authorization": [self AuthorizationFromText] };
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pili/v1/room/token",QINIUBaseDomain]];
    
    NSString *url = urlGetPushAddress;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"Room":roomName,@"user":userID,@"version":@"2.0"} options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    request.HTTPBody = jsonData;
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:config] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error, nil);
            });
            return;
        }
        
        NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil, token);
        });
    }];
    [task resume];
    
}

+ (NSString *)AuthorizationFromText
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * Authorization =[NSString stringWithFormat:@"%@:%@",[userDefaults objectForKey:@"name"],[userDefaults objectForKey:@"password"]];
    
    NSData* originData = [Authorization dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return encodeResult;
}

@end
