//
//  XFNetworkImageNode.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/11.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFNetworkImageNode.h"
#import <PinRemoteImage.h>

@interface XFNetworkImageNode ()

@property (nonatomic,strong) ASNetworkImageNode *networkImageNode;

@property (nonatomic,strong) ASImageNode *imageNode;



@end

@implementation XFNetworkImageNode

- (instancetype)init {
    
    if (self = [super init]) {
        
        _networkImageNode = [[ASNetworkImageNode alloc] init];
    
        _imageNode = [[ASImageNode alloc] init];
        
        [self addSubnode:_networkImageNode];
        [self addSubnode:_imageNode];
        
        
    }
    return self;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    _networkImageNode.placeholderColor = placeholderColor;

    
}

- (void)setImage:(UIImage *)image {
    
    _image = image;
    _networkImageNode.image = image;

    
}

- (void)setUrl:(NSURL *)url {
    
    _url = url;
    
    PINRemoteImageManager *cacheManager = [PINRemoteImageManager sharedImageManager];
    [cacheManager imageFromCacheWithURL:url processorKey:nil options:(PINRemoteImageManagerDownloadOptionsNone) completion:^(PINRemoteImageManagerResult * _Nonnull result) {
        
        if (result.image) {
            
            _imageNode.image = result.image;
            
        } else {
            
            _networkImageNode.image = nil;
            _networkImageNode.URL = _url ? _url : [NSURL URLWithString:@""];

        }
        
    }];
    
    
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0, 0)) child:_networkImageNode.URL ? _networkImageNode : _imageNode];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEventMask {
    
    [_networkImageNode addTarget:target action:action forControlEvents:controlEventMask];
    
    [_imageNode addTarget:target action:action forControlEvents:controlEventMask];

    
}

@end
