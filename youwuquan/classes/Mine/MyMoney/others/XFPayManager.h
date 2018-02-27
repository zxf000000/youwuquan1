//
//  XFPayManager.h
//  youwuquan
//
//  Created by mr.zhou on 2018/2/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface XFPayManager : NSObject <SKPaymentTransactionObserver,SKProductsRequestDelegate>

+ (instancetype)sharedManager;

- (void)buyProductsWithId:(NSString *)productsId andQuantity:(NSInteger)quantity;

@end

