//
//  IAPManager.m
//  ProApp
//
//  Created by hxbjt on 2018/7/17.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "IAPManager.h"
#import <StoreKit/StoreKit.h>

@interface IAPManager ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) Success successBlock;
@property (nonatomic, copy) Failure failureBlock;
@property (nonatomic, copy) Receipt receiptBlock;
@property (nonatomic, copy) Finish finishBlock;


@end

@implementation IAPManager
// 单例
+ (instancetype) shareIAPManager {
    static dispatch_once_t once_t;
    static IAPManager *iapManager = nil;
    dispatch_once(&once_t, ^{
        iapManager =[[IAPManager alloc] init];
    });
    return iapManager;
}

- (void)requestProductID:(NSString *)productID success:(Success)successBlock failure:(Failure)failureBlock                   finish:(Finish)finishBlock {
    if (_successBlock != successBlock) {
        _successBlock = successBlock;
    }
    if (_failureBlock != failureBlock) {
        _failureBlock = failureBlock;
    }
    if (_finishBlock != finishBlock) {
        _finishBlock = finishBlock;
    }
    
    if (productID.length > 0) {
        //判断是否可进行支付
        if ([SKPaymentQueue canMakePayments]) {
            self.productID = productID;
            [self requestProductData:productID];
        } else {
            _failureBlock(IAPPaymentNotCanMakePayment, @"用户设置禁止应用内付费购买商品");
        }
    } else {
        _failureBlock(IAPPaymentRequestFail, @"商品ID为空");
    }
}

- (void)requestProductID:(NSString *)productID success:(Success)successBlock failure:(Failure)failureBlock receipt:(Receipt)receiptBlock finish:(Finish)finishBlock {
    if (_receiptBlock != receiptBlock) {
        _receiptBlock = receiptBlock;
    }
    [self requestProductID:productID success:successBlock failure:failureBlock finish:failureBlock];
}

// 去苹果服务器请求商品
- (void)requestProductData:(NSString *)productID {
    NSLog(@"--------------请求对应的产品信息-productID:%@--------------",productID);
    //根据商品ID查找商品信息
    NSArray *product = [[NSArray alloc] initWithObjects:productID, nil];
    NSSet *nsset = [NSSet setWithArray:product];
    //创建SKProductsRequest对象，用想要出售的商品的标识来初始化， 然后附加上对应的委托对象。
    //该请求的响应包含了可用商品的本地化信息。
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

// 收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"--------------收到产品反馈消息--------------");
	    //接收商品信息
    NSArray *product = response.products;
    if ([product count] == 0) {
        NSLog(@"--------------没有商品--------------");
        _failureBlock(IAPPaymentRequestFail, @"没有所选商品");
        return;
    }
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    
    // SKProduct对象包含了在App Store上注册的商品的本地化信息。
    SKProduct *storeProduct = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        if ([pro.productIdentifier isEqualToString:self.productID]) {
            storeProduct = pro;
        }
    }
    //创建一个支付对象，并放到队列中
    SKMutablePayment *mpayment = [SKMutablePayment paymentWithProduct:storeProduct];
    //设置购买的数量
    mpayment.quantity = 1; // 默认1
    
    NSLog(@"--------------发送购买请求--------------");
    [[SKPaymentQueue defaultQueue] addPayment:mpayment];
}

// 请求商品失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"--------------请求商品失败 %@--------------", error);
    _failureBlock(IAPPaymentRequestFail, @"请求商品失败");
}

// 反馈信息结束调用
- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"--------------反馈信息结束调用--------------");
    _finishBlock();
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *tran in transactions) {
        // 如果小票状态是购买完成
        if (SKPaymentTransactionStatePurchased == tran.transactionState) {
            NSLog(@"--------------交易完成--------------");
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            // 更新界面或者数据，把用户购买得商品交给用户
            NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
            NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
            _successBlock(tran.payment.productIdentifier, receiptData);
            
            // 校验凭证
            if (_receiptBlock) {
                // 返回购买的商品信息
                [self verifyPruchase];
                //商品购买成功可调用本地接口
            }
        } else if (SKPaymentTransactionStatePurchasing == tran.transactionState) {
            NSLog(@"--------------商品添加进列表--------------");
            break;
        } else if (SKPaymentTransactionStateRestored == tran.transactionState) {
            NSLog(@"--------------已经购买过商品--------------");
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        } else if (SKPaymentTransactionStateFailed == tran.transactionState) {
            NSLog(@"--------------交易失败--------------");
            // 支付失败
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            _failureBlock(IAPPaymentTransactionStateFailed, @"支付失败");
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"--------------交易结束--------------");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// 释放
- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - 验证购买凭据
// 验证购买凭据
- (void)verifyPruchase {
    NSLog(@"--------------验证购买凭据--------------");
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    // 发送网络POST请求，对购买凭据进行验证
    //测试验证地址:https://sandbox.itunes.apple.com/verifyReceipt
    //正式验证地址:https://buy.itunes.apple.com/verifyReceipt
    NSURL *url;
#ifdef DEBUG
    url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
#else
    url = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
#endif
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    urlRequest.HTTPMethod = @"POST";
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果 iOS9后更改了另外的一个方法
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 官方验证结果为空
        if (data == nil || error) {
            NSLog(@"--------------验证失败--------------");
            NSLog(@"--------------验证购买过程中发生错误，错误信息：%@ --------------",error.localizedDescription);
            return;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dict[@"status"] intValue]==0) {
            // 比对字典中以下信息基本上可以保证数据安全
            // bundle_id , application_version , product_id , transaction_id
            NSLog(@"--------------验证成功！购买的商品是：%@ --------------", @"_productName");
            
//            NSDictionary *dicReceipt= dict[@"receipt"];
//            NSDictionary *dicInApp = [dicReceipt[@"in_app"] firstObject];
//            NSString *productIdentifier = dicInApp[@"product_id"];//读取产品标识
//            // 如果是消耗品则记录购买数量，非消耗品则记录是否购买过
//            // 业务功能
//            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//            if ([productIdentifier isEqualToString:self.productID]) {
//                int purchasedCount = [defaults integerForKey:productIdentifier];//已购买数量
//                [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
//            } else {
//                [defaults setBool:YES forKey:productIdentifier];
//            }
            NSLog(@"--------------业务功能，当前项目，后台表示不需要凭证校验 --------------");
            self->_receiptBlock(dict);
            //在此处对购买记录进行存储，可以存储到开发商的服务器端
        } else{
            NSLog(@"--------------购买失败，未通过验证！--------------");
        }
    }];
    [task resume];
}

@end
