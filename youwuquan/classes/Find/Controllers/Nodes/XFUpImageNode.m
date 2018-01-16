//
//  XFUpImageNode.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/16.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFUpImageNode.h"

@implementation XFUpImageNode

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    
    if (self = [super init]) {
        
        _imageNode = [[ASImageNode alloc] init];
        _imageNode.image = image;
        [self addSubnode:_imageNode];
        
        _titleNode = [[ASTextNode alloc] init];
        [_titleNode setFont:[UIFont systemFontOfSize:10] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:title lineSpace:0 kern:2];
        [self addSubnode:_titleNode];
        
        
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEventMask {
    
    [_imageNode addTarget:target action:action forControlEvents:controlEventMask];
    [_titleNode addTarget:target action:action forControlEvents:controlEventMask];

}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *layout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:2 justifyContent:(ASStackLayoutJustifyContentCenter) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_imageNode,_titleNode]];
    
    return layout;
    
}

@end
