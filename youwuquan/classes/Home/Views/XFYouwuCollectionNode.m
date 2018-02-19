//
//  XFYouwuCollectionNode.m
//  youwuquan
//
//  Created by mr.zhou on 2018/2/8.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFYouwuCollectionNode.h"


@implementation XFYouwuCollectionNode

- (instancetype)initWithModel:(XFHomeDataModel *)model {
    
    if (self = [super init]) {
        _imgNode = [[XFNetworkImageNode alloc] init];
        _imgNode.image = [UIImage imageNamed:@"zhanweitu22"];
        _imgNode.url = [NSURL URLWithString:_model.headIconUrl];
        _imgNode.cornerRadius = 5;
        _imgNode.clipsToBounds = YES;
        [self addSubnode:_imgNode];
        
        _nameNode = [[ASTextNode alloc] init];
        [_nameNode setFont:[UIFont systemFontOfSize:11] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:_model.nickname lineSpace:0 kern:2];
        
        NSArray *identifications = _model.identifications;
        
        NSMutableArray *icons = [NSMutableArray array];
        for (NSInteger i= 0 ; i < identifications.count ; i ++ ) {
            
            if ([[XFAuthManager sharedManager].ids containsObject:[NSString stringWithFormat:@"%@",identifications[i]]]) {
                
                NSInteger index = [[XFAuthManager sharedManager].ids indexOfObject:[NSString stringWithFormat:@"%@",identifications[i]]];
                
                XFNetworkImageNode *imgView = [[XFNetworkImageNode alloc] init];
                
                imgView.url = [NSURL URLWithString:[XFAuthManager sharedManager].icons[index]];
                
                [self addSubnode:imgView];
                
                [icons addObject:imgView];
                
            }
        }
        self.iconsVIew = icons;
    }
    return  self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *bottom = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:3 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:self.iconsVIew];
    ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_imgNode,_nameNode,bottom]];

    return stack;
}

@end
