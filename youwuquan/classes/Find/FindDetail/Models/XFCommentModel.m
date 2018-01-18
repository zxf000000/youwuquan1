//
//  XFCommentModel.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCommentModel.h"

@implementation XFCommentModel

+ (NSArray *)modelsWithComments:(NSArray *)comments farthName:(NSString *)fartherName {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0 ; i < comments.count; i ++ ) {
        
        XFCommentModel *model = [XFCommentModel modelWithDictionary:comments[i]];
        model.fartherName = fartherName;
        [arr addObject:model];
        
        if (model.childComments.count > 0) {
            
            [arr addObjectsFromArray:[self getChildCommentWithModel:model]];
            
        }
    }
    return arr;
}

+ (NSArray *)getChildCommentWithModel:(XFCommentModel *)model {
    
    NSMutableArray *array = [NSMutableArray array];
    if (model.childComments.count > 0) {
        
        array = [NSMutableArray arrayWithArray:[self modelsWithComments:model.childComments farthName:model.username]];
        
    }
    return array.copy;
}

@end
