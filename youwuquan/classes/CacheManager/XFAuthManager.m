//
//  XFAuthManager.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/12.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFAuthManager.h"
#import "XFMyAuthViewController.h"
#import "XFMineNetworkManager.h"

@implementation XFAuthManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static XFAuthManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[XFAuthManager alloc] init];
    });
    
    return manager;
    
}



- (NSArray *)icons {
    
    if (!_icons || _icons.count == 0) {
        
        if ((_authList.count == 0) && [[YYCache cacheWithName:kAuthCache] objectForKey:kAuthList]) {
            
            NSArray *datas = (NSArray *)[[YYCache cacheWithName:kAuthCache] objectForKey:kAuthList];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i < datas.count; i++ ) {
                
                [arr addObject:[XFMyAuthModel modelWithDictionary:datas[i]]];
                
            }
            
            _authList = arr.copy;
        }
        
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < _authList.count ; i ++ ) {
            
            XFMyAuthModel *model = _authList[i];
            [arr addObject:model.iconActiveUrl];
            
        }
        _icons = arr.copy;
        
        
    }
    return _icons;
}

- (NSArray *)ids {
    
    if (!_ids || _ids.count == 0) {
        
        if ((_authList.count == 0) && [[YYCache cacheWithName:kAuthCache] objectForKey:kAuthList]) {
            
            NSArray *datas = (NSArray *)[[YYCache cacheWithName:kAuthCache] objectForKey:kAuthList];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i < datas.count; i++ ) {
                
                [arr addObject:[XFMyAuthModel modelWithDictionary:datas[i]]];
                
            }
            
            _authList = arr.copy;
        }
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < _authList.count ; i ++ ) {
            
            XFMyAuthModel *model = _authList[i];
            [arr addObject:model.id];
            
        }
        _ids = arr.copy;
    }
    return _ids;
    
}

- (NSArray *)authList {
    
    if (!_authList) {
        
        if ([[YYCache cacheWithName:kAuthCache] objectForKey:kAuthList]) {
            
            NSArray *datas = (NSArray *)[[YYCache cacheWithName:kAuthCache] objectForKey:kAuthList];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i < datas.count; i++ ) {
                
                [arr addObject:[XFMyAuthModel modelWithDictionary:datas[i]]];
                
            }
            
            _authList = arr.copy;
            
        } else {
            
            // 加载认证信息
            [XFMineNetworkManager getDefineListWithsuccessBlock:^(id responseObj) {
                
                NSArray *datas = (NSArray *)responseObj;
                NSMutableArray *arr = [NSMutableArray array];
                for (NSInteger i = 0 ; i < datas.count; i++ ) {
                    
                    [arr addObject:[XFMyAuthModel modelWithDictionary:datas[i]]];
                    
                }
                YYCache *authCache = [YYCache cacheWithName:kAuthCache];
                [authCache setObject:arr.copy forKey:kAuthList];
                _authList = arr.copy;
                
            } failedBlock:^(NSError *error) {
                
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];
            

        }
        
    }
    
    return _authList;

    
}
@end
