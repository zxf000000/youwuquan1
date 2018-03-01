//
//  XFPayManager.m
//  youwuquan
//
//  Created by mr.zhou on 2018/2/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFPayManager.h"
@interface XFPayManager()

@property (nonatomic,copy) NSString *productsId;
@property (nonatomic,assign) NSInteger quantity;
@property (nonatomic,copy) NSString *currencyCode;

@property (nonatomic,strong) MBProgressHUD *HUD;

@end


@implementation XFPayManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static XFPayManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[XFPayManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self launch];
    }
    return self;
}

- (void)launch {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self requestProductList];
}

- (void)requestProductList{
    NSLog(@"requestProductList");
}


- (void)buyProductsWithId:(NSString *)productsId andQuantity:(NSInteger)quantity {
    self.productsId = productsId;
    self.quantity = quantity;
    
    // 开始回调
    self.payBeginBlock();
    
    if ([SKPaymentQueue canMakePayments]) {
        //允许程序内付费购买
        [self RequestProductData:@[self.productsId]];
    } else {
        
        //您的手机没有打开程序内付费购买
        [self showAlertWithTitle:@"您的手机没有打开程序内付费购买"];
//
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
//        [alerView show];
    }
}

- (void)RequestProductData:(NSArray *)productsIdArr {
    
    //请求对应的产品信息
    NSSet *nsset = [NSSet setWithArray:productsIdArr];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;

    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    //收到产品反馈信息
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int) [myProduct count]);
    // populate UI
    for (SKProduct *product in myProduct) {
        //        NSLog(@"product info");
        //        NSLog(@"  基本描述: %@", [product description]);
        //        NSLog(@"  IAP的id: %@", product.productIdentifier);
        //        NSLog(@"  地区编码: %@", product.priceLocale.localeIdentifier);
        //        NSLog(@"  本地价格: %@", product.price);
        //        NSLog(@"  语言代码: %@", [product.priceLocale objectForKey:NSLocaleLanguageCode]);
        //        NSLog(@"  国家代码: %@", [product.priceLocale objectForKey:NSLocaleCountryCode]);
        //        NSLog(@"  货币代码: %@", [product.priceLocale objectForKey:NSLocaleCurrencyCode]);
        //        NSLog(@"  货币符号: %@", [product.priceLocale objectForKey:NSLocaleCurgegrencySymbol]);
        //        NSLog(@"  本地标题: %@", product.localizedTitle);
        //        NSLog(@"  本地描述: %@", product.localizedDescription);
        [self updateProductPriceWithId:product.productIdentifier andPrice:product.price];
        if ([[product.priceLocale objectForKey:NSLocaleCurrencyCode] isEqualToString:@"CNY"]) {
            self.currencyCode = @"￥";
        } else {
            self.currencyCode = [product.priceLocale objectForKey:NSLocaleCurrencySymbol];
        }
    }
    //发送购买请求
    for (SKProduct *prct in myProduct) {
        if ([self.productsId isEqualToString:prct.productIdentifier]) {
            SKMutablePayment *payment = nil;
            payment = [SKMutablePayment paymentWithProduct:prct];
            payment.quantity = self.quantity;
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            
        }
    }
}

- (void)updateProductPriceWithId:(NSString *)productIdentifier andPrice:(NSDecimalNumber *)price{
    NSLog(@"productIdentifier == %@",productIdentifier);
    NSLog(@"price == %@",price);
}

#pragma mark - SKPaymentTransactionObserver
//----监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    //交易结果
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                //交易完成
                [self completeTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed: {
                //交易失败
                [self failedTransaction:transaction];
                [self showAlertWithTitle:@"交易失败"];

            }
                break;
            case SKPaymentTransactionStateRestored: {
                //已经购买过该商品
                [self restoreTransaction:transaction];

                [self showAlertWithTitle:@"已经购买过该商品"];

//                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"已经购买过该商品" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
//                [alerView show];
            }
                break;
            case SKPaymentTransactionStatePurchasing: {
                //商品添加进列表
                NSLog(@"商品添加进列表");
            }
                break;
            case SKPaymentTransactionStateDeferred: {
                NSLog(@"SKPayment Transaction State Deferred");
            }
                break;
            default:
                
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"-----completeTransaction--------");
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
            
            
            [self verifyAppStorePurchaseWithPaymentTrasaction:transaction];
        }
    }
}

//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
// 验证购买
- (void)verifySandBoxPurchaseWithPaymentTrasaction:(SKPaymentTransaction *)transaction {
    
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    // 发送网络POST请求，对购买凭据进行验证
    //测试验证地址:https://sandbox.itunes.apple.com/verifyReceipt
    //正式验证地址:https://buy.itunes.apple.com/verifyReceipt
    NSURL *url = [NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    urlRequest.HTTPMethod = @"POST";
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果 iOS9后更改了另外的一个方法
    
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    // 官方验证结果为空
    if (result == nil) {
        NSLog(@"验证失败");

        
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    if (dict != nil) {
        // 比对字典中以下信息基本上可以保证数据安全
        // bundle_id , application_version , product_id , transaction_id

        NSLog(@"验证成功！购买的商品是：%@", @"_productName");
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    }

}

// 验证购买
- (void)verifyAppStorePurchaseWithPaymentTrasaction:(SKPaymentTransaction *)transaction {
    
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    // 发送网络POST请求，对购买凭据进行验证
    //测试验证地址:https://sandbox.itunes.apple.com/verifyReceipt
    //正式验证地址:https://buy.itunes.apple.com/verifyReceipt
    NSURL *url = [NSURL URLWithString:AppStore];
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    urlRequest.HTTPMethod = @"POST";
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果 iOS9后更改了另外的一个方法
    
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    // 官方验证结果为空
    if (result == nil) {
        NSLog(@"验证失败");
        [self verifySandBoxPurchaseWithPaymentTrasaction:transaction];

        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    if (dict != nil) {
        // 比对字典中以下信息基本上可以保证数据安全
        // bundle_id , application_version , product_id , transaction_id
        NSLog(@"验证成功！购买的商品是：%@", @"_productName");

        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
    }
    
}

// 验证store



- (void)recordTransaction:(NSString *)product{
    NSLog(@"记录交易--product == %@",product);
}

//处理下载内容
- (void)provideContent:(NSString *)product{
    NSLog(@"处理下载内容--product == %@",product);
}
- (void)failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled) { }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易恢复处理");
}

- (void)terminate {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)showAlertWithTitle:(NSString *)title {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:actionDone];
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
