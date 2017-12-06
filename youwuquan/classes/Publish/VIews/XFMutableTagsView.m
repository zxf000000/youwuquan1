//
//  XFMutableTagsView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/24.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMutableTagsView.h"

@implementation XFTagView

+ (instancetype)creatTagViewWith:(NSString *)tagStr index:(NSInteger)index {
    
    return [[XFTagView alloc] initWithTagStr:tagStr index:index];
    
}

- (instancetype)initWithTagStr:(NSString *)tagStr index:(NSInteger)index {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _index = index;
        
        _tagLabel = [[UILabel alloc] init];
        NSString *tag = [NSString stringWithFormat:@"#%@#",tagStr];
        _tagLabel.font = [UIFont systemFontOfSize:12];
        _tagLabel.text = tag;
        _tagLabel.textColor = kMainRedColor;
        
        [self addSubview:_tagLabel];
        
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"delete_red"] forState:(UIControlStateNormal)];
        [self addSubview:_deleteButton];
        
        [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_offset(0);
            make.centerY.mas_offset(0);
            
        }];
        
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(_tagLabel.mas_right).offset(10);
            make.centerY.mas_offset(0);
            make.width.height.mas_equalTo(10);
            
        }];
        
    }
    return self;
}

- (void)clickDeleteButton {
    
    self.clickDeleteButtonBlock(self.index);
    
}

@end

@interface XFMutableTagsView ()



@end

@implementation XFMutableTagsView

- (void)setTagArr:(NSMutableArray *)tagArr {
    
    _tagArr = tagArr;
//    
//    if (_tagArr.count == 0) {
//        
//        self.tagsViewHeight = 40;
//        
//        self.reloadTagViewBlock();
//        
//    }
    
    for (NSInteger i = 0 ; i < _tagArr.count ; i ++ ) {
        
        [self addTagViewWithTag:_tagArr[i]];
        
    }
    
}

// 删除tagView
- (void)deleteTagWithIndex:(NSInteger)index {
    
//    XFTagView *tagView = [self.tagViewArr objectAtIndex:index];
//
//    [self.tagViewArr removeObject:tagView];
//    [tagView removeFromSuperview];
//    [self.tagArr removeObjectAtIndex:index];
//
//    for (NSInteger i = 0 ; i < self.tagArr.count ; i ++ ) {
//
//        [self changeFrameIndexForTag:self.tagArr[i] index:i];
//    }
    
    [self.tagArr removeObjectAtIndex:index];
    [self removeAllSubviews];
    [self.tagViewArr removeAllObjects];
    
    for (NSInteger i = 0 ; i < _tagArr.count ; i ++ ) {
        
        [self addTagViewWithTag:_tagArr[i]];
        
    }
    
    self.reloadTagViewBlock();
    
}

- (void)changeFrameIndexForTag:(NSString *)tag index:(NSInteger)index {
    
    XFTagView *tagView = [self.tagViewArr objectAtIndex:index];
    
    tagView.frame = [self caculatFrameForTag:tag];
    tagView.index = index;
    
}

- (void)addTagViewWith:(NSString *)tag {
    
    [self.tagArr addObject:tag];
    
    [self addTagViewWithTag:tag];
    
    self.reloadTagViewBlock();
}

// 添加tagView
- (void)addTagViewWithTag:(NSString *)tag {
    
    XFTagView *tagView = [XFTagView creatTagViewWith:tag index:self.tagViewArr.count];
    
    tagView.frame = [self caculatFrameForTag:tag];
    
    tagView.clickDeleteButtonBlock = ^(NSInteger index) {
        // 刷新frame
        [self deleteTagWithIndex:index];
        
    };
    
    [self addSubview:tagView];
    
    [self.tagViewArr addObject:tagView];
    
}

// 计算尺寸
- (CGRect)caculatFrameForTag:(NSString *)tag {
    
    CGFloat leftSpace = 10;
    CGFloat topSpace = 10;
    CGFloat bottomSpace = 10;
    CGFloat padding = 5;
    CGFloat height = 20;
    
    NSString *str = [NSString stringWithFormat:@"#%@#",tag];
    
    //    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
    //    CGSize size=[tag sizeWithAttributes:attrs];
    CGRect textFrame = [str boundingRectWithSize:(CGSizeMake(MAXFLOAT, 20)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    CGFloat width = textFrame.size.width + 25;
    
    if (self.tagViewArr.count == 0) {
        
        CGRect frame = CGRectMake(leftSpace, topSpace, width, height);
        
        self.tagsViewHeight = height + topSpace + bottomSpace;
        
        return frame;
    } else {
        
        UIView *tagView = [self.tagViewArr lastObject];
        
        CGRect lastFrame = tagView.frame;
        
        CGFloat totalWidth = lastFrame.size.width + lastFrame.origin.x + width + leftSpace + padding;
        
        // 总长度大于屏幕宽度之后换行,否则直接添加
        if (totalWidth > kScreenWidth) {
            
            CGFloat x = leftSpace;
            CGFloat y = lastFrame.origin.y + padding + height;
            
            self.tagsViewHeight = y + height + bottomSpace;
            
            return CGRectMake(x, y, width, height);
            
        } else {
            
            CGFloat x = lastFrame.origin.x + lastFrame.size.width + 5;
            CGFloat y = lastFrame.origin.y;
            self.tagsViewHeight = y + height + bottomSpace;
            
            return CGRectMake(x, y, width, height);
            
        }
    }
    
    
    
}

- (NSMutableArray *)tagViewArr {
    
    if (_tagViewArr == nil) {
        
        _tagViewArr = [NSMutableArray array];
        
    }
    return _tagViewArr;
    
}

@end
