//
//  PLSToolBarCommon.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PLSToolBarCommon_h
#define PLSToolBarCommon_h

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

#define isiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define bundleEditImageNamed(name) [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", kEditPath, name]]
#define bundleStickerImageNamed(name) [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", kStickersPath, name]]

#define kCustomTopbarHeight 44

#define kSliderColors @[[UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1.f]/*白色*/\
, [UIColor colorWithRed:235.f/255.f green:51.f/255.f blue:16.f/255.f alpha:1.f]/*红色*/\
, [UIColor colorWithRed:245.f/255.f green:181.f/255.f blue:71.f/255.f alpha:1.f]/*浅黄色*/\
, [UIColor colorWithRed:248.f/255.f green:229.f/255.f blue:7.f/255.f alpha:1.f]/*黄色*/\
, [UIColor colorWithRed:185.f/255.f green:243.f/255.f blue:46.f/255.f alpha:1.f]/*浅绿色*/\
, [UIColor colorWithRed:4.f/255.f green:170.f/255.f blue:11.f/255.f alpha:1.f]/*墨绿色*/\
, [UIColor colorWithRed:36.f/255.f green:199.f/255.f blue:243.f/255.f alpha:1.f]/*天蓝色*/\
, [UIColor colorWithRed:24.f/255.f green:117.f/255.f blue:243.f/255.f alpha:1.f]/*海洋蓝色*/\
, [UIColor colorWithRed:1.f/255.f green:53.f/255.f blue:190.f/255.f alpha:1.f]/*深蓝色*/\
, [UIColor colorWithRed:141.f/255.f green:87.f/255.f blue:240.f/255.f alpha:1.f]/*紫色*/\
, [UIColor colorWithRed:244.f/255.f green:147.f/255.f blue:244.f/255.f alpha:1.f]/*浅粉色*/\
, [UIColor colorWithRed:242.f/255.f green:102.f/255.f blue:139.f/255.f alpha:1.f]/*橙色*/\
, [UIColor colorWithRed:236.f/255.f green:36.f/255.f blue:179.f/255.f alpha:1.f]/*粉红色*/\
]

/** 编辑资源路径 */
extern NSString *const kEditPath;
/** 贴图资源路径 */
extern NSString *const kStickersPath;

#endif


