//
//  XFStatusDetailCellNode.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface XFStatusDetailCollectionCellnode : ASCellNode

@property (nonatomic,strong) ASNetworkImageNode *iconNode;

@end


@interface XFStatusDetailCellNode : ASCellNode <ASCollectionDelegate,ASCollectionDataSource>


- (instancetype)initWithImages:(NSArray *)images likeImgs:(NSArray *)likeImgs;

@property (nonatomic,strong) ASNetworkImageNode *iconNode;
@property (nonatomic,strong) ASTextNode *nameNode;
@property (nonatomic,strong) ASTextNode *timeNode;
@property (nonatomic,strong) ASButtonNode *followButton;

@property (nonatomic,strong) ASTextNode *commentNode;

@property (nonatomic,copy) NSArray *images;

@property (nonatomic,copy) NSArray *imageNodes;

@property (nonatomic,strong) ASTextNode *numberNode;

@property (nonatomic,strong) ASButtonNode *likeNode;
@property (nonatomic,strong) ASButtonNode *contentNode;

@property (nonatomic,strong) ASDisplayNode *lineNode;

@property (nonatomic,strong) ASImageNode *likeImg;
@property (nonatomic,strong) NSArray *likeimgs;
@property (nonatomic,strong) NSArray *likeimgNodes;

@property (nonatomic,strong) ASCollectionNode *collectionNode;

@property (nonatomic,strong) ASDisplayNode *bgNode;

@end
