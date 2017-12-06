//
//  XFCardSizeCache.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCardSizeCache.h"

@implementation XFCardSizeCache

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static XFCardSizeCache *cache;
    dispatch_once(&onceToken, ^{
        cache = [[XFCardSizeCache alloc] init];
    });
    return cache;
}

- (NSArray *)threeSize {
    
    if (_threeSize == nil) {
        
        
        CGRect frame11 = XFRectMake(10, 10, 352, 660);
        CGRect frame12 = XFRectMake(366, 206, 354, 230);
        CGRect frame13 = XFRectMake(366, 440, 354, 230);
        CGRect infoFrame1 = XFRectMake(366, 10, 354, 192);
        NSString *infoSizetype1 = @"3";
        
        NSArray *framearr1 = @[[NSValue valueWithCGRect:frame11],
                              [NSValue valueWithCGRect:frame12],
                              [NSValue valueWithCGRect:frame13],
                              [NSValue valueWithCGRect:infoFrame1],
                               infoSizetype1];
        
        CGRect frame21 = XFRectMake(230, 10, 490, 328);
        CGRect frame22 = XFRectMake(10, 342, 490, 328);
        CGRect frame23 = XFRectMake(504, 342, 216, 328);
        CGRect infoFrame2 = XFRectMake(10, 10, 218, 330);
        NSString *infoSizetype2 = @"0";

        NSArray *framearr2 = @[[NSValue valueWithCGRect:frame21],
                               [NSValue valueWithCGRect:frame22],
                               [NSValue valueWithCGRect:frame23],
                               [NSValue valueWithCGRect:infoFrame2],
                               infoSizetype2];
        
        CGRect frame31 = XFRectMake(10, 10, 446, 328);
        CGRect frame32 = XFRectMake(460, 10, 260, 328);
        CGRect frame33 = XFRectMake(10, 342, 354, 328);
        CGRect infoFrame3 = XFRectMake(368, 342, 354, 328);
        NSString *infoSizetype3 = @"3";

        NSArray *framearr3 = @[[NSValue valueWithCGRect:frame31],
                               [NSValue valueWithCGRect:frame32],
                               [NSValue valueWithCGRect:frame33],
                               [NSValue valueWithCGRect:infoFrame3],
                               infoSizetype3];
        
        _threeSize = @[framearr1,framearr2,framearr3];
        
        
    }
    return _threeSize;
}

- (NSArray *)fourSize {
    
    if (_fourSize == nil) {
        
        CGRect frame11 = XFRectMake(10, 10, 400, 420);
        CGRect frame12 = XFRectMake(414, 210, 306, 220);
        CGRect frame13 = XFRectMake(10, 434, 400, 236);
        CGRect frame14 = XFRectMake(414, 434, 306, 236);
        CGRect infoFrame1 = XFRectMake(414, 10, 306, 196);
        NSString *infoSizetype1 = @"3";

        NSArray *framearr1 = @[[NSValue valueWithCGRect:frame11],
                               [NSValue valueWithCGRect:frame12],
                               [NSValue valueWithCGRect:frame13],
                               [NSValue valueWithCGRect:frame14],
                               [NSValue valueWithCGRect:infoFrame1],
                               infoSizetype1];
        
        CGRect frame21 = XFRectMake(10, 10, 234, 356);
        CGRect frame22 = XFRectMake(486, 10, 234, 356);
        CGRect frame23 = XFRectMake(10, 369, 234, 300);
        CGRect frame24 = XFRectMake(248, 369, 472, 300);
        NSString *infoSizetype2 = @"0";

        CGRect infoFrame2 = XFRectMake(248, 10, 234, 356);
        
        NSArray *framearr2 = @[[NSValue valueWithCGRect:frame21],
                               [NSValue valueWithCGRect:frame22],
                               [NSValue valueWithCGRect:frame23],
                               [NSValue valueWithCGRect:frame24],

                               [NSValue valueWithCGRect:infoFrame2],
                               infoSizetype2];
        
        CGRect frame31 = XFRectMake(364, 10, 356, 356);
        CGRect frame32 = XFRectMake(10, 370, 234, 300);
        CGRect frame33 = XFRectMake(248, 370, 234, 300);
        CGRect frame34 = XFRectMake(486, 370, 234, 300);
        CGRect infoFrame3 = XFRectMake(10, 10, 350, 356);
        NSString *infoSizetype3 = @"3";

        NSArray *framearr3 = @[[NSValue valueWithCGRect:frame31],
                               [NSValue valueWithCGRect:frame32],
                               [NSValue valueWithCGRect:frame33],
                               [NSValue valueWithCGRect:frame34],
                               [NSValue valueWithCGRect:infoFrame3],
                               infoSizetype3];
        
        _fourSize = @[framearr1,framearr2,framearr3];
        
        
    }
    return _fourSize;
}

- (NSArray *)fiveSize {
    
    if (_fiveSize == nil) {
        
        
        CGRect frame11 = XFRectMake(10, 226, 400, 440);
        CGRect frame12 = XFRectMake(414, 10, 306, 150);
        CGRect frame13 = XFRectMake(414, 164, 306, 150);
        CGRect frame14 = XFRectMake(414, 318, 306, 150);
        CGRect frame15 = XFRectMake(414, 472, 306, 198);

        CGRect infoFrame1 = XFRectMake(10, 10, 400, 212);
        NSString *infoSizetype1 = @"3";

        
        NSArray *framearr1 = @[[NSValue valueWithCGRect:frame11],
                               [NSValue valueWithCGRect:frame12],
                               [NSValue valueWithCGRect:frame13],
                               [NSValue valueWithCGRect:frame14],
                               [NSValue valueWithCGRect:frame15],

                               [NSValue valueWithCGRect:infoFrame1],
                               infoSizetype1];
        
        CGRect frame21 = XFRectMake(10, 10, 230, 304);
        CGRect frame22 = XFRectMake(244, 10, 252, 304);
        CGRect frame23 = XFRectMake(500, 10, 220, 304);
        CGRect frame24 = XFRectMake(10, 318, 230, 352);
        CGRect frame25 = XFRectMake(500, 318, 220, 352);

        CGRect infoFrame2 = XFRectMake(244, 318, 252, 352);
        NSString *infoSizetype2 = @"0";

        
        NSArray *framearr2 = @[[NSValue valueWithCGRect:frame21],
                               [NSValue valueWithCGRect:frame22],
                               [NSValue valueWithCGRect:frame23],
                               [NSValue valueWithCGRect:frame24],
                               [NSValue valueWithCGRect:frame25],

                               [NSValue valueWithCGRect:infoFrame2],
                               infoSizetype2];
        
        CGRect frame31 = XFRectMake(318, 10, 402, 350);
        CGRect frame32 = XFRectMake(10, 364, 150, 306);
        CGRect frame33 = XFRectMake(164, 364, 150, 306);
        CGRect frame34 = XFRectMake(318, 364, 150, 306);
        CGRect frame35 = XFRectMake(472, 364, 248, 306);

        CGRect infoFrame3 = XFRectMake(10, 10, 306, 350);
        NSString *infoSizetype3 = @"3";

        NSArray *framearr3 = @[[NSValue valueWithCGRect:frame31],
                               [NSValue valueWithCGRect:frame32],
                               [NSValue valueWithCGRect:frame33],
                               [NSValue valueWithCGRect:frame34],
                               [NSValue valueWithCGRect:frame35],

                               [NSValue valueWithCGRect:infoFrame3],
                               infoSizetype3];
        
        _fiveSize = @[framearr1,framearr2,framearr3];
        
        
    }
    return _fiveSize;
}

- (NSArray *)sixSize {
    
    if (_sixSize == nil) {
        
        
        CGRect frame11 = XFRectMake(10, 10, 710, 266);
        CGRect frame12 = XFRectMake(10, 280, 210, 204);
        CGRect frame13 = XFRectMake(510, 280, 210, 204);
        CGRect frame14 = XFRectMake(10, 488, 242, 182);
        CGRect frame15 = XFRectMake(256, 488, 218, 182);
        CGRect frame16 = XFRectMake(478, 488, 242, 182);

        CGRect infoFrame1 = XFRectMake(222, 280, 284, 204);
        NSString *infoSizetype1 = @"3";

        
        NSArray *framearr1 = @[[NSValue valueWithCGRect:frame11],
                               [NSValue valueWithCGRect:frame12],
                               [NSValue valueWithCGRect:frame13],
                               [NSValue valueWithCGRect:frame14],
                               [NSValue valueWithCGRect:frame15],
                               [NSValue valueWithCGRect:frame16],

                               [NSValue valueWithCGRect:infoFrame1],
                               infoSizetype1];
        
        CGRect frame21 = XFRectMake(10, 10, 242, 204);
        CGRect frame22 = XFRectMake(256, 10, 242, 204);
        CGRect frame23 = XFRectMake(10, 218, 242, 244);
        CGRect frame24 = XFRectMake(256, 218, 242, 244);
        CGRect frame25 = XFRectMake(10, 466, 242, 204);
        CGRect frame26 = XFRectMake(256, 466, 242, 204);

        CGRect infoFrame2 = XFRectMake(500, 10, 220, 660);
        NSString *infoSizetype2 = @"0";

        
        NSArray *framearr2 = @[[NSValue valueWithCGRect:frame21],
                               [NSValue valueWithCGRect:frame22],
                               [NSValue valueWithCGRect:frame23],
                               [NSValue valueWithCGRect:frame24],
                               [NSValue valueWithCGRect:frame25],
                               [NSValue valueWithCGRect:frame26],

                               [NSValue valueWithCGRect:infoFrame2],
                               infoSizetype2];
        
        CGRect frame31 = XFRectMake(10, 10, 226, 204);
        CGRect frame32 = XFRectMake(240, 10, 250, 660);
        CGRect frame33 = XFRectMake(494, 10, 226, 204);
        CGRect frame34 = XFRectMake(10, 218, 226, 204);
        CGRect frame35 = XFRectMake(494, 218, 226, 204);
        CGRect frame36 = XFRectMake(10, 426, 226, 244);

        CGRect infoFrame3 = XFRectMake(494, 426, 226, 244);
        NSString *infoSizetype3 = @"2";

        
        NSArray *framearr3 = @[[NSValue valueWithCGRect:frame31],
                               [NSValue valueWithCGRect:frame32],
                               [NSValue valueWithCGRect:frame33],
                               [NSValue valueWithCGRect:frame34],
                               [NSValue valueWithCGRect:frame35],
                               [NSValue valueWithCGRect:frame36],

                               [NSValue valueWithCGRect:infoFrame3],
                               infoSizetype3];
        
        _sixSize = @[framearr1,framearr2,framearr3];
        
        
    }
    return _sixSize;
}


- (NSArray *)sevenSize {
    
    if (_sevenSize == nil) {
        
        
        CGRect frame11 = XFRectMake(10, 10, 354, 289);
        CGRect frame12 = XFRectMake(368, 10, 354, 289);
        CGRect frame13 = XFRectMake(10, 302, 150, 182);
        CGRect frame14 = XFRectMake(478, 302, 242, 182);
        CGRect frame15 = XFRectMake(10, 488, 242, 182);
        CGRect frame16 = XFRectMake(256, 488, 218, 182);
        CGRect frame17 = XFRectMake(478, 488, 242, 182);

        CGRect infoFrame1 = XFRectMake(162, 302, 314, 182);
        NSString *infoSizetype1 = @"3";

        
        NSArray *framearr1 = @[[NSValue valueWithCGRect:frame11],
                               [NSValue valueWithCGRect:frame12],
                               [NSValue valueWithCGRect:frame13],
                               [NSValue valueWithCGRect:frame14],
                               [NSValue valueWithCGRect:frame15],
                               [NSValue valueWithCGRect:frame16],
                               [NSValue valueWithCGRect:frame17],

                               [NSValue valueWithCGRect:infoFrame1],
                               infoSizetype1];
        
        CGRect frame21 = XFRectMake(10, 10, 242, 300);
        CGRect frame22 = XFRectMake(477, 10, 242, 300);
        CGRect frame23 = XFRectMake(10, 314, 242, 182);
        CGRect frame24 = XFRectMake(255, 314, 218, 182);
        CGRect frame25 = XFRectMake(478, 314, 242, 182);
        CGRect frame26 = XFRectMake(10, 500, 242, 170);
        CGRect frame27 = XFRectMake(255, 500, 464, 170);

        CGRect infoFrame2 = XFRectMake(256, 10, 218, 300);
        NSString *infoSizetype2 = @"2";

        NSArray *framearr2 = @[[NSValue valueWithCGRect:frame21],
                               [NSValue valueWithCGRect:frame22],
                               [NSValue valueWithCGRect:frame23],
                               [NSValue valueWithCGRect:frame24],
                               [NSValue valueWithCGRect:frame25],
                               [NSValue valueWithCGRect:frame26],
                               [NSValue valueWithCGRect:frame27],

                               [NSValue valueWithCGRect:infoFrame2],
                               infoSizetype2];
        
        CGRect frame31 = XFRectMake(10, 10, 242, 204);
        CGRect frame32 = XFRectMake(257, 10, 242, 204);
        CGRect frame33 = XFRectMake(10, 218, 242, 200);
        CGRect frame34 = XFRectMake(257, 218, 242, 200);
        CGRect frame35 = XFRectMake(10, 422, 242, 248);
        CGRect frame36 = XFRectMake(257, 422, 242, 248);
        CGRect frame37 = XFRectMake(503, 422, 217, 248);

        CGRect infoFrame3 = XFRectMake(503, 10, 217, 408);
        NSString *infoSizetype3 = @"0";

        NSArray *framearr3 = @[[NSValue valueWithCGRect:frame31],
                               [NSValue valueWithCGRect:frame32],
                               [NSValue valueWithCGRect:frame33],
                               [NSValue valueWithCGRect:frame34],
                               [NSValue valueWithCGRect:frame35],
                               [NSValue valueWithCGRect:frame36],
                               [NSValue valueWithCGRect:frame37],

                               [NSValue valueWithCGRect:infoFrame3],
                               infoSizetype3];
        
        _sevenSize = @[framearr1,framearr2,framearr3];
        
        
    }
    return _sevenSize;
}

- (NSArray *)eightSize {
    
    if (_eightSize == nil) {
        
        CGRect frame11 = XFRectMake(10, 10, 234, 388);
        CGRect frame12 = XFRectMake(248, 10, 234, 192);
        CGRect frame13 = XFRectMake(486, 10, 234, 192);
        CGRect frame14 = XFRectMake(248, 206, 234, 192);
        CGRect frame15 = XFRectMake(486, 206, 234, 192);
        CGRect frame16 = XFRectMake(10, 402, 234, 192);
        CGRect frame17 = XFRectMake(248, 402, 234, 192);
        CGRect frame18 = XFRectMake(486, 402, 234, 192);

        CGRect infoFrame1 = XFRectMake(10, 598, 710, 72);
        NSString *infoSizetype1 = @"1";

        NSArray *framearr1 = @[[NSValue valueWithCGRect:frame11],
                               [NSValue valueWithCGRect:frame12],
                               [NSValue valueWithCGRect:frame13],
                               [NSValue valueWithCGRect:frame14],
                               [NSValue valueWithCGRect:frame15],
                               [NSValue valueWithCGRect:frame16],
                               [NSValue valueWithCGRect:frame17],
                               [NSValue valueWithCGRect:frame18],

                               [NSValue valueWithCGRect:infoFrame1],
                                infoSizetype1];
        
        CGRect frame21 = XFRectMake(10, 10, 242, 300);
        CGRect frame22 = XFRectMake(477, 10, 242, 300);
        CGRect frame23 = XFRectMake(10, 314, 242, 182);
        CGRect frame24 = XFRectMake(255, 314, 218, 182);
        CGRect frame25 = XFRectMake(478, 314, 242, 182);
        CGRect frame26 = XFRectMake(10, 500, 242, 170);
        CGRect frame27 = XFRectMake(255, 500, 218, 170);
        CGRect frame28 = XFRectMake(478, 500, 242, 170);

        CGRect infoFrame2 = XFRectMake(256, 10, 218, 300);
        NSString *infoSizetype2 = @"2";

        NSArray *framearr2 = @[[NSValue valueWithCGRect:frame21],
                               [NSValue valueWithCGRect:frame22],
                               [NSValue valueWithCGRect:frame23],
                               [NSValue valueWithCGRect:frame24],
                               [NSValue valueWithCGRect:frame25],
                               [NSValue valueWithCGRect:frame26],
                               [NSValue valueWithCGRect:frame27],
                               [NSValue valueWithCGRect:frame28],

                               [NSValue valueWithCGRect:infoFrame2],
                               infoSizetype2];
        
        CGRect frame31 = XFRectMake(10, 10, 472, 192);
        CGRect frame32 = XFRectMake(486, 10, 234, 192);
        CGRect frame33 = XFRectMake(10, 206, 234, 192);
        CGRect frame34 = XFRectMake(248, 206, 234, 192);
        CGRect frame35 = XFRectMake(486, 206, 234, 192);
        CGRect frame36 = XFRectMake(10, 478, 234, 192);
        CGRect frame37 = XFRectMake(248, 478, 234, 192);
        CGRect frame38 = XFRectMake(486, 478, 234, 192);

        CGRect infoFrame3 = XFRectMake(10, 404, 710, 72);
        NSString *infoSizetype3 = @"1";

        NSArray *framearr3 = @[[NSValue valueWithCGRect:frame31],
                               [NSValue valueWithCGRect:frame32],
                               [NSValue valueWithCGRect:frame33],
                               [NSValue valueWithCGRect:frame34],
                               [NSValue valueWithCGRect:frame35],
                               [NSValue valueWithCGRect:frame36],
                               [NSValue valueWithCGRect:frame37],
                               [NSValue valueWithCGRect:frame38],

                               [NSValue valueWithCGRect:infoFrame3],
                               infoSizetype3];
        
        _eightSize = @[framearr1,framearr2,framearr3];
        
        
    }
    return _eightSize;
}



- (NSArray *)cardSizeCache {
    
    if (_cardSizeCache == nil) {
        
        _cardSizeCache = [NSArray array];
    }
    return _cardSizeCache;
}

@end
