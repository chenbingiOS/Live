
//
//  CBArchiverTool.m
//  ProApp
//
//  Created by hxbjt on 2018/5/31.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBArchiverTool.h"

@implementation CBArchiverTool

/**
 * 归档对象
 *
 * @param object 归档对象
 * @param keyString 归档的键
 * @param pathString 已经是Document路径,只需加后缀
 */
+ (void)archiverObject:(id)object key:(NSString *)keyString filePath:(NSString *)pathString {
    if (!object) {
        NSLog(@"归档的对象为空");
        return;
    }
    // NSMutableData对象相当于一个数据中转站 将遵循NSCoding协议的对象转换为data数据
    NSMutableData *mData = [NSMutableData data];
    // 1.创建归档器
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
    // 2.将对象进行归档编码并指定对应的键
    [archiver encodeObject:object forKey:keyString];
    // 3.结束归档编码
    [archiver finishEncoding];
    // 4.创建归档路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    /**因为文件路径在沙河,而斜杠(/)会被认为是在下一个文件目录下
     但是我们并没有建立这样一个文件目录 是所以要去除 避免归档失败
     其实吧 是因为有习惯把接口当做路径来存储 有/会失败 所以去出去*/
    pathString = [pathString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *filePath = [path stringByAppendingPathComponent:pathString];
    // 测试时间的时候请勿开启打印
//    NSLog(@"归档的对象filePath == %@",filePath );
    // 5. 写入文件
    [mData writeToFile:filePath atomically:YES];
}
/**
 * 解归档的对象
 *
 * @param pathString 已经是Document路径,只需加后缀
 * @param keyStirng 归档的键
 *
 * @return 返回对象
 */
+ (id )unarchiverPath:(NSString *)pathString key:(NSString *)keyStirng {
    // 1. 建立解归档的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    pathString = [pathString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *filePath = [path stringByAppendingPathComponent:pathString];
    // 2.根据路径查找data数据
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    // 3.创建解归档器
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 4. 取出解归档的对象
    id object = [unarchiver decodeObjectForKey:keyStirng];
//    NSLog(@"解归档的对象filePath == %@",filePath );
    if (!object) {
        NSLog(@"解归档的对象为空或者路径不对");
        return nil;
    }
    // 通过指定的键将对象解归档出来
    return object;
}
/**
 删除归档的数据
 @param pathString 已经是Document路径,只需加后缀
 */
+ (void)removeArchiverObjectFilePath:(NSString *)pathString {
    // 1.创建文件管理器
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    // 2.查找删除路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    pathString = [pathString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *filePath = [path stringByAppendingPathComponent:pathString];
    // 3. 如果此路径下存在文件 删除此路径下的文件
    if ([defaultManager isDeletableFileAtPath:filePath]) {
        [defaultManager removeItemAtPath:filePath error:nil];
    }
} 

@end
