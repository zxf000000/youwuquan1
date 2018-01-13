//
//  XFFIndHeaderCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/10.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFNetworkImageNode.h"
@protocol XFFindHeaderdelegate <NSObject>

- (void)didClickMoreButton;

- (void)didClickNoMoreButton;

@end

@interface XFFIndHeaderCell : ASCellNode

@property (nonatomic,strong) ASDisplayNode *backNode;

@property (nonatomic,strong) XFNetworkImageNode *picNode;

@property (nonatomic,strong) ASTextNode *titleNode;

@property (nonatomic,strong) ASTextNode *desNode;

@property (nonatomic,strong) ASButtonNode *joinButton;

@property (nonatomic,strong) ASButtonNode *moreButton;

@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,strong) id <XFFindHeaderdelegate> delegate;


@end
