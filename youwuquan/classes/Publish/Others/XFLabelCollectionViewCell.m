//
//  XFHistoryCollectionViewCell.m
//  chaofen
//
//  Created by mr.zhou on 2017/7/15.
//  Copyright © 2017年 a.hep. All rights reserved.
//

#import "XFLabelCollectionViewCell.h"

@interface XFLabelCollectionViewCell ()

@property (nonatomic,strong) UILabel *selectedLabel;

@end

@implementation XFLabelCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _itemHeight = 20;
    
        // 用约束来初始化控件:
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textAlignment = NSTextAlignmentCenter;

        self.textLabel.font = [UIFont systemFontOfSize:13];
        
//        self.textLabel.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.textLabel];
#pragma mark — 如果使用CGRectMake来布局,是需要在preferredLayoutAttributesFittingAttributes方法中去修改textlabel的frame的
//         self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
#pragma mark — 如果使用约束来布局,则无需在preferredLayoutAttributesFittingAttributes方法中去修改cell上的子控件l的frame
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // make 代表约束:
            make.top.equalTo(self.contentView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
            make.left.equalTo(self.contentView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
            make.height.equalTo(@(_itemHeight));                // 高度
            make.right.equalTo(self.contentView).with.offset(-15); // 对当前view的right进行约束,距离参照view的右边界是 :
            
        }];
        
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"delete_red"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteButton];
        _deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_offset(0);
            make.right.mas_offset(0);
            make.width.height.mas_equalTo(20);
            
        }];
        
        [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:(UIControlEventTouchUpInside)];
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel)];
//
//        self.textLabel.userInteractionEnabled = YES;
//        
//        [self.textLabel addGestureRecognizer:tap];
        
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//
//        self.layer.borderWidth = 1;
//
//        self.layer.cornerRadius = 15;
//        self.layer.masksToBounds = YES;

    }
    return self;
}

- (void)clickDeleteButton {
    
    self.clickDeleteButtonForIndex(self.indexPath);
    
//    if ([self.delegate respondsToSelector:@selector(labelCell:didClickdeleteButtonWithIndex:)]) {
//
//        [self.delegate labelCell:self didClickdeleteButtonWithIndex:self.indexPath];
//
//    }
    
}

- (void)setTitleIsSelected:(BOOL)titleIsSelected {

    if (titleIsSelected) {
        
        self.textLabel.backgroundColor = [UIColor colorWithRed:221/255.f green:191/255.f blue:129/255.f alpha:1];
        
        self.changesSelectedBlock(self.indexPath, YES);

    } else {
        
        
        self.textLabel.backgroundColor = [UIColor whiteColor];
        
        self.changesSelectedBlock(self.indexPath, NO);

    }
    

}

- (void)setTagStr:(NSString *)tagStr {
    
    _tagStr = tagStr;
    
    _textLabel.text = [NSString stringWithFormat:@"#%@#",_tagStr];
    
    
}

- (void)tapLabel {

//    self.changesSelectedBlock(self.indexPath, YES);

}

#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
    CGSize size=[_textLabel.text sizeWithAttributes:attrs];
    CGRect frame = CGRectMake(0, 0, size.width + 20, 20);
    
    frame.size.height = _itemHeight;
    attributes.frame = frame;

    return attributes;
}


@end
