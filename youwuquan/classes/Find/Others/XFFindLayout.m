//
//  XFFindLayout.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/31.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindLayout.h"

/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation WBTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    if (kiOS9Later) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    WBTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end

/**
 微博的文本中，某些嵌入的图片需要从网上下载，这里简单做个封装
 */
@interface WBTextImageViewAttachment : YYTextAttachment
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGSize size;
@end

@implementation WBTextImageViewAttachment {
    UIImageView *_imageView;
}
- (void)setContent:(id)content {
    _imageView = content;
}
- (id)content {
    /// UIImageView 只能在主线程访问
    if (pthread_main_np() == 0) return nil;
    if (_imageView) return _imageView;
    
    /// 第一次获取时 (应该是在文本渲染完成，需要添加附件视图时)，初始化图片视图，并下载图片
    /// 这里改成 YYAnimatedImageView 就能支持 GIF/APNG/WebP 动画了
    _imageView = [UIImageView new];
    _imageView.size = _size;
    [_imageView setImageWithURL:_imageURL placeholder:nil];
    return _imageView;
}
@end


@implementation XFFindLayout

- (instancetype)initWithStatus:(XFFindModel *)model {
    
    if (self = [super init]) {
        
        _model = model;
        
        [self layout];
    }
    return self;
}

- (void)layout {
    
    [self _layout];
    
}

- (void)updateDate {
    
    [self _updateDate];
}

- (void)_layout {
    
    _marginTop = kCellTopMargin;
    _titleHeight = 0;
    _profileHeight = 0;
    _textHeight = 0;
    _picHeight = 0;
    _toolbarHeight = 45;
    _marginBottom = 10;
    
    [self _layoutProfile];
    [self _layoutPics];

    [self _layoutText];
    
    // 计算高度
    _height = 0;
    _height += _marginTop;
    _height += _titleHeight;
    _height += _profileHeight;
    _height += _textHeight;
    if (_picHeight > 0) {
        _height += _picHeight;
    }

    _height += kWBCellPadding;

    _height += _toolbarHeight;
    _height += _marginBottom;

}

- (void)_layoutProfile {
    
    [self _layoutName];
    [self _layoutSource];
    _profileHeight = kWBCellProfileHeight;

    
}
// 名字
- (void)_layoutName {
    
    NSString *nameStr = _model.name;
    
    if (nameStr.length == 0) {
        
        _nameTextLayout = nil;
        return;
        
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    nameText.font = [UIFont systemFontOfSize:15];
    nameText.color = [UIColor blackColor];
    nameText.lineBreakMode = NSLineBreakByCharWrapping;

    YYTextContainer *container = [YYTextContainer containerWithSize:(CGSizeMake(kWBCellNameWidth, 9999))];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:nameText];
    
}
// 时间
- (void)_layoutSource {
    
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];

    NSString *createTime = _model.time;
    
    // 时间
    if (createTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:createTime];
        [timeText appendString:@"  "];
        timeText.font = [UIFont systemFontOfSize:11];
        timeText.color = UIColorHex(808080);
        [sourceText appendAttributedString:timeText];

    }
    
    if (sourceText.length == 0) {
        _sourceTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _sourceTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
    
}

- (void)_layoutText {
    
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_model.comment];
    
    if (text.length == 0) return;

    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
}

- (void)_layoutPics {
    
    _picSize = CGSizeZero;
    _picHeight = 0;
    
    if (_model.images.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    
    len1_3 = CGFloatPixelRound(len1_3);

    switch (_model.images.count) {
        case 1: {
            WBPicture *pic = _model.images.firstObject;
            WBPictureMetadata *bmiddle = pic.bmiddle;
            if (pic.keepSize || bmiddle.width < 1 || bmiddle.height < 1) {
                CGFloat maxLen = kWBCellContentWidth / 2.0;
                maxLen = CGFloatPixelRound(maxLen);
                picSize = CGSizeMake(maxLen, maxLen);
                picHeight = maxLen;
            } else {
                CGFloat maxLen = len1_3 * 2 + kWBCellPaddingPic;
                if (bmiddle.width < bmiddle.height) {
                    picSize.width = (float)bmiddle.width / (float)bmiddle.height * maxLen;
                    picSize.height = maxLen;
                } else {
                    picSize.width = maxLen;
                    picSize.height = (float)bmiddle.height / (float)bmiddle.width * maxLen;
                }
                picSize = CGSizePixelRound(picSize);
                picHeight = picSize.height;
            }
        } break;
        case 2: case 3: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 4: case 5: case 6: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 2 + kWBCellPaddingPic;
        } break;
        default: { // 7, 8, 9
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 3 + kWBCellPaddingPic * 2;
        } break;
    }
    _picSize = picSize;
    _picHeight = picHeight;

}

- (void)_layoutToolbar {
    // should be localized
    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kWBCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    
    NSMutableAttributedString *repostText = [[NSMutableAttributedString alloc] initWithString:[_model.likeNum integerValue] <= 0 ? @"点赞" : _model.likeNum];
    repostText.font = font;
    repostText.color = [UIColor blackColor];
    _toolbarRepostTextLayout = [YYTextLayout layoutWithContainer:container text:repostText];
    _toolbarRepostTextWidth = CGFloatPixelRound(_toolbarRepostTextLayout.textBoundingRect.size.width);
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[_model.contentNum integerValue] <= 0 ? @"评论" : _model.contentNum];
    commentText.font = font;
    commentText.color = [UIColor blackColor];
    _toolbarCommentTextLayout = [YYTextLayout layoutWithContainer:container text:commentText];
    _toolbarCommentTextWidth = CGFloatPixelRound(_toolbarCommentTextLayout.textBoundingRect.size.width);
    
//    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:_status.attitudesCount <= 0 ? @"赞" : [WBStatusHelper shortedNumberDesc:_status.attitudesCount]];
//    likeText.font = font;
//    likeText.color = _status.attitudesStatus ? kWBCellToolbarTitleHighlightColor : kWBCellToolbarTitleColor;
//    _toolbarLikeTextLayout = [YYTextLayout layoutWithContainer:container text:likeText];
//    _toolbarLikeTextWidth = CGFloatPixelRound(_toolbarLikeTextLayout.textBoundingRect.size.width);
}

- (void)_updateDate {
    
    
    
}

- (WBTextLinePositionModifier *)_textlineModifier {
    static WBTextLinePositionModifier *mod;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mod = [WBTextLinePositionModifier new];
        mod.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
        mod.paddingTop = 10;
        mod.paddingBottom = 10;
    });
    return mod;
}

@end
