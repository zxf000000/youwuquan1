//
//  XFFindNewTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/10.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindNewTableViewCell.h"

@interface XFFindNewTableViewCell ()

@property (nonatomic,strong) ASDisplayNode *bgView;

@property (nonatomic,strong) ASNetworkImageNode *iconView;

@property (nonatomic,strong) ASTextNode *nameLabel;

@property (nonatomic,strong) ASButtonNode *followButton;

@property (nonatomic,strong) ASButtonNode *shareButton;

@property (nonatomic,strong) ASNetworkImageNode *picView;

@property (nonatomic,strong) ASImageNode *picShadow;

@property (nonatomic,strong) ASButtonNode *rewardButton;

@property (nonatomic,strong) YYLabel *contentNode;

@property (nonatomic,strong) ASImageNode *textShadow;

@property (nonatomic,strong) ASButtonNode *moreButton;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) ASTextNode *timeLabel;

@property (nonatomic,strong) ASButtonNode *likeButton;

@property (nonatomic,strong) ASButtonNode *commentButton;

@end

@implementation XFFindNewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _height = height;
        
        _bgView = [[ASDisplayNode alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.cornerRadius = 4;
        _bgView.shadowColor = UIColorHex(808080).CGColor;
        _bgView.shadowOffset = CGSizeMake(0, 0);
        _bgView.shadowOpacity = 0.4;
        [self.contentView addSubnode:_bgView];
        
        _iconView = [[ASNetworkImageNode alloc] init];
        _iconView.defaultImage = [UIImage imageNamed:@"zhanweitu22"];
        
        _iconView.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
            
            UIGraphicsBeginImageContext(image.size);
            
            UIBezierPath *path = [UIBezierPath
                                  bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height)
                                  cornerRadius:MIN(image.size.width,image.size.height)/2];
            
            [path addClip];
            
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            
            UIImage *refinedImg = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return refinedImg;
            
        };
        
        [_bgView addSubnode:_iconView];
        
        // 名字
        _nameLabel = [[ASTextNode alloc] init];
        [_nameLabel setFont:[UIFont systemFontOfSize:12] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:@"名字名字" lineSpace:2 kern:0];
        [_bgView addSubnode:_nameLabel];
        
        // 徽章
        
        
        // 关注
        _followButton  = [[ASButtonNode alloc] init];
        [_followButton setTitle:@"+ 关注" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _followButton.backgroundColor = UIColorHex(F72F5E);
        [_bgView addSubnode:_followButton];
        _followButton.cornerRadius = 4;
        
        // 分享
        _shareButton  = [[ASButtonNode alloc] init];
        [_shareButton setImage:[UIImage imageNamed:@"find_share"] forState:(UIControlStateNormal)];
        [_bgView addSubnode:_shareButton];
        
        // 图片
        _picView = [[ASNetworkImageNode alloc] init];
        _picView.defaultImage = [UIImage imageNamed:@"zhanweitu22"];
        
        [_bgView addSubnode:_picView];
        _picView.cornerRadius = 4;
        
        // 遮罩
        // 图片遮罩
        _picShadow = [[ASImageNode alloc] init];
        _picShadow.image = [UIImage imageNamed:@"overlay-zise"];
        [_picView addSubnode:_picShadow];
        
        // 打赏button
        _rewardButton = [[ASButtonNode alloc] init];
        
        [_rewardButton setImage:[UIImage imageNamed:@"find_dashang"] forState:(UIControlStateNormal)];

        [_picView addSubnode:_rewardButton];
        
        // 文字
        _contentNode = [[YYLabel alloc] init];
        _contentNode.numberOfLines = 3;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容"];
        
        // 2. 为文本设置属性
        text.font = [UIFont systemFontOfSize:13];
        text.color = [UIColor blackColor];
        text.lineSpacing = 3;
        _contentNode.attributedText = text;
        
        // 创建文本容器
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX);
        
        if (_isOpen) {
            
            container.maximumNumberOfRows = 0;

        } else {
            
            container.maximumNumberOfRows = 3;
            
        }
        
        // 生成排版结果
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
        
        CGSize textSize = layout.textBoundingSize;
        
        _contentNode.frame = CGRectMake(10, KiconHeight + kIconBottomSpace + kIconTopSpace + kPicHeight + kRewardButtonHeight + kTextTopSpace, kScreenWidth - 40, textSize.height);
        _contentNode.textLayout = layout;
        [_bgView.view addSubview:_contentNode];
        
        // 遮罩
        _textShadow = [[ASImageNode alloc] init];
        // 图片遮罩
        _textShadow.image = [UIImage imageNamed:@"find_bai1"];

        [_bgView addSubnode:_textShadow];
        
        // 更多按钮
        _moreButton = [[ASButtonNode alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"find_unfold"] forState:(UIControlStateNormal)];
        [_moreButton setImage:[UIImage imageNamed:@"find_retract"] forState:(UIControlStateSelected)];
        [_moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
        [_bgView addSubnode:_moreButton];
        
        // 底部的三个
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorHex(f4f4f4);
        [_bgView.view.layer addSublayer:_lineView.layer];
        
        // 时间
        _timeLabel = [[ASTextNode alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:11] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:@"10 分钟前" lineSpace:2 kern:1];
        
        [_bgView addSubnode:_timeLabel];
        
        // 点赞
        _likeButton = [[ASButtonNode alloc] init];
        [ _likeButton setTitle:@"520" withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"find_liked"] forState:(UIControlStateSelected)];
        
        [_bgView addSubnode:_likeButton];
        
        // 评论
        _commentButton = [[ASButtonNode alloc] init];
        [ _commentButton setTitle:@"520" withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
        [_commentButton setImage:[UIImage imageNamed:@"find_comment"] forState:(UIControlStateNormal)];
        
        [_bgView addSubnode:_commentButton];
    }
    
    return self;
}

- (void)setIsOpen:(BOOL)isOpen {
    
    _isOpen = isOpen;
    _bgView.frame = CGRectMake(10, 10, kScreenWidth - 20, _height - 20);
    _iconView.frame = CGRectMake(15, 15, 45, 45);
    _nameLabel.frame = CGRectMake(15 + 45 + 10, 25, 60, 21);
    _followButton.frame = CGRectMake(kScreenWidth - 19 - 25 - 9 - 70 - 20, 22.5, 70, 30);
    _shareButton.frame = CGRectMake(kScreenWidth - 19 - 25 - 20, 25, 25, 25);
    _picView.frame = CGRectMake(0, kIconTopSpace + kIconBottomSpace + KiconHeight, kPicWidth, kPicHeight);
    _picShadow.frame = CGRectMake(0, kPicHeight - 130, kPicWidth, 130);
    _rewardButton.frame = CGRectMake((kPicWidth - 66)/2, kPicHeight - 46, 66, 66);

    // 创建文本容器
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX);
    
    if (_isOpen) {
        
        container.maximumNumberOfRows = 0;
        
    } else {
        
        container.maximumNumberOfRows = 3;
        
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容"];

    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    
    CGSize textSize = layout.textBoundingSize;
    
    _contentNode.frame = CGRectMake(10, KiconHeight + kIconBottomSpace + kIconTopSpace + kPicHeight + kRewardButtonHeight + kTextTopSpace, kScreenWidth - 40,textSize.height);

    _contentNode.textLayout = layout;
    
    
    CGFloat shadowY = _contentNode.frame.origin.y + textSize.height - 19;
        
    _textShadow.frame = CGRectMake(10,shadowY, kScreenWidth - 40, 19);
        
    CGFloat moreButtony = _textShadow.frame.origin.y + 19;
        
    _moreButton.frame = CGRectMake((kPicWidth - 50)/2, moreButtony, 50, 20);

    if (_isOpen) {
        
        _moreButton.selected = YES;
        _textShadow.hidden = YES;
        
    } else {
        _textShadow.hidden = NO;

        _moreButton.selected = NO;
    }
    
    CGFloat lineY = moreButtony + 20 + 20;
    
    _lineView.frame = CGRectMake(0, lineY, kPicWidth, 1);
    
    _timeLabel.frame = CGRectMake(17, lineY + 1 + 19, 70, 15);

    _likeButton.frame = CGRectMake(kPicWidth - 29 - 65 - 20 - 70, _timeLabel.frame.origin.y - 3, 70, 23);
    
    _commentButton.frame = CGRectMake(kPicWidth - 29 - 65, _timeLabel.frame.origin.y - 3, 70, 23);

}

- (void)clickMoreButton:(ASButtonNode *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(clickedCellForIndexPath:open:)]) {
    
        if (sender.selected) {
            
            [self.delegate clickedCellForIndexPath:self.indexPath open:NO];

        } else {
            
            [self.delegate clickedCellForIndexPath:self.indexPath open:YES];

        }
        
        
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
