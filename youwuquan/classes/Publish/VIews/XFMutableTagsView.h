//
//  XFMutableTagsView.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/24.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFTagView : UIView

@property (nonatomic,strong) UILabel *tagLabel;

@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy) void(^clickDeleteButtonBlock)(NSInteger index);

+ (instancetype)creatTagViewWith:(NSString *)tagStr index:(NSInteger)index;

@end


@interface XFMutableTagsView : UIView

@property (nonatomic,assign) CGFloat tagsViewHeight;

@property (nonatomic,strong) NSMutableArray *tagViewArr;

@property (nonatomic,strong) NSMutableArray *tagArr;

- (void)addTagViewWith:(NSString *)tag;

- (void)deleteTagWithIndex:(NSInteger )index;

@property (nonatomic,copy) void(^reloadTagViewBlock)();

@end
