//
//  XFFindModel.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/31.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XFFindModel;

/// 图片标记
typedef NS_ENUM(NSUInteger, WBPictureBadgeType) {
    WBPictureBadgeTypeNone = 0, ///< 正常图片
    WBPictureBadgeTypeLong,     ///< 长图
    WBPictureBadgeTypeGIF,      ///< GIF
};

/**
 一次API请求的数据
 */
@interface WBTimelineItem : NSObject
@property (nonatomic, strong) NSArray *ad;
@property (nonatomic, strong) NSArray *advertises;
@property (nonatomic, strong) NSString *gsid;
@property (nonatomic, assign) int32_t interval;
@property (nonatomic, assign) int32_t uveBlank;
@property (nonatomic, assign) int32_t hasUnread;
@property (nonatomic, assign) int32_t totalNumber;
@property (nonatomic, strong) NSString *sinceID;
@property (nonatomic, strong) NSString *maxID;
@property (nonatomic, strong) NSString *previousCursor;
@property (nonatomic, strong) NSString *nextCursor;
@property (nonatomic, strong) NSArray<XFFindModel *> *statuses;
/*
 groupInfo
 trends
 */
@end



/**
 一个图片的元数据
 */
@interface WBPictureMetadata : NSObject
@property (nonatomic, strong) NSURL *url; ///< Full image url
@property (nonatomic, assign) int width; ///< pixel width
@property (nonatomic, assign) int height; ///< pixel height
@property (nonatomic, strong) NSString *type; ///< "WEBP" "JPEG" "GIF"
@property (nonatomic, assign) int cutType; ///< Default:1
@property (nonatomic, assign) WBPictureBadgeType badgeType;
@end


/**
 图片
 */
@interface WBPicture : NSObject
@property (nonatomic, strong) NSString *picID;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, assign) int photoTag;
@property (nonatomic, assign) BOOL keepSize; ///< YES:固定为方形 NO:原始宽高比
@property (nonatomic, strong) WBPictureMetadata *thumbnail;  ///< w:180
@property (nonatomic, strong) WBPictureMetadata *bmiddle;    ///< w:360 (列表中的缩略图)
@property (nonatomic, strong) WBPictureMetadata *middlePlus; ///< w:480
@property (nonatomic, strong) WBPictureMetadata *large;      ///< w:720 (放大查看)
@property (nonatomic, strong) WBPictureMetadata *largest;    ///<       (查看原图)
@property (nonatomic, strong) WBPictureMetadata *original;   ///<
@property (nonatomic, assign) WBPictureBadgeType badgeType;
@end


@interface XFFindModel : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) UIImage *icon;

@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSArray *images;

@property (nonatomic,copy) NSString *comment;

@property (nonatomic,copy) NSString *contentNum;

@property (nonatomic,copy) NSString *likeNum;

@property (nonatomic,assign) BOOL attitudesStatus;


@end
