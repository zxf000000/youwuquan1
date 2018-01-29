//
//  XFStatusDetailViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFStatusCommentViewController.h"
#import "XFStatusModel.h"

typedef NS_ENUM(NSInteger,XFStatusDetailVCType) {
    
    Other,
    Mine,
    
};

@interface XFStatusCenterNode : ASCellNode

@property (nonatomic,strong) ASTextNode *titleNode;

@end

@interface XFStatusBottomNode : ASCellNode

@property (nonatomic,strong) ASButtonNode *moreButton;

@property (nonatomic,strong) ASDisplayNode *bgNode;

@property (nonatomic,copy) void(^clickMoreButtonBlock)(void);

@end

@interface XFStatusDetailViewController : XFStatusCommentViewController

@property (nonatomic,assign) XFStatusDetailVCType type;

@property (nonatomic,copy) NSString *statusId;


@property (nonatomic,strong) XFStatusModel *status;

@property (nonatomic,copy) NSArray *commentList;
@property (nonatomic,copy) NSArray *likeList;

@property (nonatomic,copy) void(^followedBlock)(XFStatusModel *model ,BOOL followed);

@property (nonatomic,copy) void(^likeBlock)(XFStatusModel *model, BOOL liked);

@property (nonatomic,copy) void(^deleteSUccessBlock)(void);


@end
