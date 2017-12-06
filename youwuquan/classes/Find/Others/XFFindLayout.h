//
//  XFFindLayout.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/31.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFFindModel.h"

#define kCellTopMargin 10 //顶部灰色留白
#define kWBCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制
#define kWBCellProfileHeight 56 // cell 名片高度
#define kWBCellTextFontSize 13      // 文本字体大小
#define kWBCellPaddingText 12   // cell 文本与其他元素间留白
#define kWBCellPadding 10       // cell 内边距
#define kCellCommentLeftPadding 62 // 文字/图片内边距
#define kCellCommentRightPadding 23 // 文字/图片内边距

#define kWBCellContentWidth (kScreenWidth - kCellCommentLeftPadding - kCellCommentRightPadding) // cell 内容宽度
#define kWBCellPaddingPic 5 // 图片间距
#define kWBCellTitleHeight 36   // cell 标题高度 (例如"仅自己可见")
#define kWBCellNamePaddingLeft 14 // cell 名字和 avatar 之间留白

#define kWBCellHighlightColor UIColorHex(000000)     // Cell高亮时灰色


#define kWBCellToolbarHeight 45 // toolBar高度
#define kWBCellToolbarFontSize 11

#define kWBCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] //线条颜色


@interface XFFindLayout : NSObject

- (instancetype)initWithStatus:(XFFindModel *)model;
- (void)layout; ///< 计算布局
- (void)updateDate; ///< 更新时间字符串

// 数据
@property (nonatomic,strong) XFFindModel *model;

//以下是布局结果

// 顶部留白
@property (nonatomic, assign) CGFloat marginTop; //顶部灰色留白

// 标题栏
@property (nonatomic, assign) CGFloat titleHeight; //标题栏高度，0为没标题栏
@property (nonatomic, strong) YYTextLayout *titleTextLayout; // 标题栏

// 个人资料
@property (nonatomic, assign) CGFloat profileHeight; //个人资料高度(包括留白)
@property (nonatomic, strong) YYTextLayout *nameTextLayout; // 名字
@property (nonatomic, strong) YYTextLayout *sourceTextLayout; //时间/来源

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

// 图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;


// 工具栏
@property (nonatomic, assign) CGFloat toolbarHeight; // 工具栏
@property (nonatomic, strong) YYTextLayout *toolbarRepostTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarCommentTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarLikeTextLayout;
@property (nonatomic, assign) CGFloat toolbarRepostTextWidth;
@property (nonatomic, assign) CGFloat toolbarCommentTextWidth;
@property (nonatomic, assign) CGFloat toolbarLikeTextWidth;


// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白

// 总高度
@property (nonatomic, assign) CGFloat height;

@end

/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface WBTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end



