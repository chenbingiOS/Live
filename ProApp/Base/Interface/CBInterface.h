//
//  CBInterface.h
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

//域名
#define purl @"http://api.et4p.top/api/public/"
#define h5url @"http://api.et4p.top"

#define urlPolicy h5url@"/index.php?g=portal&m=page&a=index&id=4"

#define urlGetCode      purl@"?service=Login.getCode"
#define urlUserReg      purl@"?service=Login.userReg"
#define urlUserLogin    purl@"/?service=Login.userLogin"
#define urlUserLoginByThird purl@"/?service=Login.userLoginByThird"

@interface CBInterface : NSObject

@end
