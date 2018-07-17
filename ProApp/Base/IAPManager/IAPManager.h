//
//  IAPManager.h
//  ProApp
//
//  Created by hxbjt on 2018/7/17.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,IAPPaymentTransactionFailState) {
    IAPPaymentRequestFail = 0,          ///< 请求productID失败
    IAPPaymentNotCanMakePayment ,       ///< 设置了权限， 不能发起支付
    IAPPaymentTransactionStateFailed    ///< 支付失败
};

typedef void (^Failure)(IAPPaymentTransactionFailState state, NSString *failDesc);
typedef void (^Success)(NSString *productID, NSData *receiptData);
typedef void (^Receipt)(NSDictionary *checkoutReceipt);
typedef void (^Finish)();

@interface IAPManager : NSObject

+ (instancetype)shareIAPManager;

- (void)requestProductID:(NSString *)productID
                 success:(Success)successBlock
                 failure:(Failure)failureBlock
                  finish:(Finish)finishBlock;

- (void)requestProductID:(NSString *)productID
                 success:(Success)successBlock
                 failure:(Failure)failureBlock
                 receipt:(Receipt)receiptBlock
                  finish:(Finish)finishBlock;
@end
