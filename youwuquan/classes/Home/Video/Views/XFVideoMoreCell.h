//
//  XFVideoMoreCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFVideoMoreSubCell : ASCellNode

@property (nonatomic,strong) ASNetworkImageNode *picNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,strong) ASTextNode *numberNode;

@end

@interface XFVideoMoreCell : ASCellNode <ASCollectionDelegate,ASCollectionDataSource>

@property (nonatomic,strong) ASNetworkImageNode *iconNode;

@property (nonatomic,strong) ASTextNode *nameNode;

@property (nonatomic,strong) ASButtonNode *followButton;

@property (nonatomic,strong) ASTextNode *moreNode;

@property (nonatomic,strong) ASCollectionNode *collectionNode;

- (void)setColl;

@end
