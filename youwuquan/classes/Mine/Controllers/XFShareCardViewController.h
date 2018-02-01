//
//  XFMyActorCardViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

@interface XFSharePicModel : NSObject

@property (nonatomic,copy) NSString *creatTime;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *imgUrl;

@end

@interface XFShareCardViewController : XFOtherMainViewController

@end
