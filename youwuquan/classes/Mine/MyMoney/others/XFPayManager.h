//
//  XFPayManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/2/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void(^XFPayManagerBeginPayBlock)(void);
typedef void(^XFPayManagerPaySuccessPayBlock)(void);
typedef void(^XFPayManagerCheckSuccessPayBlock)(void);
typedef void(^XFPayManagerPayFailedPayBlock)(void);
typedef void(^XFPayManagerCheckFailedPayBlock)(void);
typedef void(^XFPayManagerRepayBlock)(void);

@interface XFPayManager : NSObject <SKPaymentTransactionObserver,SKProductsRequestDelegate>

+ (instancetype)sharedManager;

- (void)buyProductsWithId:(NSString *)productsId andQuantity:(NSInteger)quantity;

@property (nonatomic,copy) XFPayManagerBeginPayBlock payBeginBlock;
@property (nonatomic,copy) XFPayManagerPaySuccessPayBlock paySuccessBlock;
@property (nonatomic,copy) XFPayManagerCheckSuccessPayBlock checkSuccessPayBlock;
@property (nonatomic,copy) XFPayManagerPayFailedPayBlock payFailedPayBlock;
@property (nonatomic,copy) XFPayManagerCheckFailedPayBlock checkFailedPayBlock;
@property (nonatomic,copy) XFPayManagerRepayBlock repayBlock;


@end

