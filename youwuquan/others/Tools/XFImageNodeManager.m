//
//  XFImageNodeManager.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/25.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFImageNodeManager.h"

@implementation XFImageNodeManager
#pragma mark -
#pragma mark - Lifecycle Methods
+ (XFImageNodeManager *)sharedImageManager
{
    static XFImageNodeManager *sharedImageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedImageManager = [[XFImageNodeManager alloc] init];
    });
    return sharedImageManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
// your override code......
- (void)cachedImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue completion:(ASImageCacherCompletion)completion {
    
    [[YYWebImageManager sharedManager].cache getImageForKey:[[YYWebImageManager sharedManager] cacheKeyForURL:URL] withType:(YYImageCacheTypeAll) withBlock:^(UIImage * _Nullable image, YYImageCacheType type) {
        
        completion(image);
        
    }];
    
}

/**
 @abstract Downloads an image with the given URL.
 @param URL The URL of the image to download.
 @param callbackQueue The queue to call `downloadProgressBlock` and `completion` on.
 @param downloadProgress The block to be invoked when the download of `URL` progresses.
 @param completion The block to be invoked when the download has completed, or has failed.
 @discussion This method is likely to be called on the main thread, so any custom implementations should make sure to background any expensive download operations.
 @result An opaque identifier to be used in canceling the download, via `cancelImageDownloadForIdentifier:`. You must
 retain the identifier if you wish to use it later.
 */
- (nullable id)downloadImageWithURL:(NSURL *)URL
                      callbackQueue:(dispatch_queue_t)callbackQueue
                   downloadProgress:(nullable ASImageDownloaderProgress)downloadProgress
                         completion:(ASImageDownloaderCompletion)completion {
    
    
    YYWebImageOperation *operation;
    __weak typeof(operation) weakOperation = operation;
    operation = [[YYWebImageManager sharedManager] requestImageWithURL:URL options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
//        CGFloat progress = receivedSize/(CGFloat)expectedSize;
        
//        downloadProgress(progress);
        
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        completion(image,error,weakOperation);
        
    }];
    
    return operation;
    
}

/**
 @abstract Cancels an image download.
 @param downloadIdentifier The opaque download identifier object returned from
 `downloadImageWithURL:callbackQueue:downloadProgressBlock:completion:`.
 @discussion This method has no effect if `downloadIdentifier` is nil.
 */
- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier {
    
    YYWebImageOperation *operation = (YYWebImageOperation *)downloadIdentifier;
    
    if (operation) {
        [operation cancel];
        
    } else {
        return;
        
    }
    
}


@end
