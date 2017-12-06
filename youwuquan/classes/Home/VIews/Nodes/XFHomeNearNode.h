//
//  XFHomeNearNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
@class XFHomeNearNode;

typedef NS_ENUM(NSInteger,NearbyCellType) {
    
    Find,
    Search,
    
};

@protocol XFNearbyCellNodeDelegate <NSObject>

- (void)homeNearNode:(XFHomeNearNode *)nearnode didClickNodeWithindexPath:(NSIndexPath *)indexPath;

@end

@interface XFHomeNearNode : ASCellNode <ASCollectionDelegate,ASCollectionDataSource>

@property (nonatomic,strong) ASCollectionNode *collectionNode;

@property (nonatomic,assign) NearbyCellType type;

@property (nonatomic,copy) NSArray *names;

@property (nonatomic,strong) id <XFNearbyCellNodeDelegate> delegate;

@end
