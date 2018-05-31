//
//  CBArchiverTool.h
//  ProApp
//
//  Created by hxbjt on 2018/5/31.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBArchiverTool : NSObject

/**
 * 归档对象
 *
 * @param object 归档对象
 * @param keyString 归档的键
 * @param pathString 已经是Document路径,只需加后缀
 */
+ (void)archiverObject:(id)object key:(NSString *)keyString filePath:(NSString *)pathString;
/**
 * 解归档的对象
 *
 * @param pathString 已经是Document路径,只需加后缀
 * @param keyStirng 归档的键
 *
 * @return 返回对象
 */
+ (id)unarchiverPath:(NSString *)pathString key:(NSString *)keyStirng;
/**
 删除归档的数据
 @param pathString 已经是Document路径,只需加后缀
 */
+ (void)removeArchiverObjectFilePath:(NSString *)pathString;

@end
