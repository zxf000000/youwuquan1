//
//  XFFindTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindTableViewCell.h"
#import "WBStatusHelper.h"
#import "YYControl.h"

@implementation WBStatusProfileView {
    BOOL _trackingTouch;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellProfileHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    @weakify(self);
    
    _avatarView = [UIImageView new];
    _avatarView.size = CGSizeMake(45, 45);
    _avatarView.origin = CGPointMake(kWBCellPadding, kWBCellPadding + 3);
    _avatarView.contentMode = UIViewContentModeScaleToFill;
    _avatarView.layer.masksToBounds = YES;
    _avatarView.layer.cornerRadius = 22.5;
    [self addSubview:_avatarView];
    
//    CALayer *avatarBorder = [CALayer layer];
//    avatarBorder.frame = _avatarView.bounds;
//    avatarBorder.borderWidth = CGFloatFromPixel(1);
//    avatarBorder.borderColor = [UIColor colorWithWhite:0.000 alpha:0.090].CGColor;
//    avatarBorder.cornerRadius = _avatarView.height / 2;
//    avatarBorder.shouldRasterize = YES;
//    avatarBorder.rasterizationScale = kScreenScale;
//    [_avatarView.layer addSublayer:avatarBorder];
    
//    _avatarBadgeView = [UIImageView new];
//    _avatarBadgeView.size = CGSizeMake(14, 14);
//    _avatarBadgeView.center = CGPointMake(_avatarView.right - 6, _avatarView.bottom - 6);
//    _avatarBadgeView.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:_avatarBadgeView];
    
    _nameLabel = [YYLabel new];
    _nameLabel.size = CGSizeMake(kWBCellNameWidth, 24);
    _nameLabel.left = _avatarView.right + kWBCellNamePaddingLeft;
    _nameLabel.centerY = 27;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self addSubview:_nameLabel];
    
    _sourceLabel = [YYLabel new];
    _sourceLabel.frame = _nameLabel.frame;
    _sourceLabel.centerY = 47;
    _sourceLabel.displaysAsynchronously = YES;
    _sourceLabel.ignoreCommonProperties = YES;
    _sourceLabel.fadeOnAsynchronouslyDisplay = NO;
    _sourceLabel.fadeOnHighlight = NO;
    _sourceLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [self addSubview:_sourceLabel];
    
    _shareButton = [[UIButton alloc] init];
    [_shareButton setImage:[UIImage imageNamed:@"find_share"] forState:(UIControlStateNormal)];
    [self addSubview:_shareButton];
    
    _shareButton.frame = CGRectMake(kScreenWidth - 25 - 20, 10, 40, 25);
    _shareButton.centerY = self.centerY;
    
    _followButton = [[UIButton alloc] init];
    [_followButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_followButton setTitle:@"+ 关注" forState:(UIControlStateNormal)];
    _followButton.backgroundColor = kMainRedColor;
    _followButton.layer.cornerRadius = 2;
    _followButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_followButton];
    
    _followButton.frame = CGRectMake(kScreenWidth - 70 - 10 - 20 - 25, 10, 70, 30);
    _followButton.centerY = self.centerY;
    
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _trackingTouch = NO;
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView:_avatarView];
    if (CGRectContainsPoint(_avatarView.bounds, p)) {
        _trackingTouch = YES;
    }
    p = [t locationInView:_nameLabel];
    if (CGRectContainsPoint(_nameLabel.bounds, p) && _nameLabel.textLayout.textBoundingRect.size.width > p.x) {
        _trackingTouch = YES;
    }
    if (!_trackingTouch) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesEnded:touches withEvent:event];
    } else {
        if ([_cell.delegate respondsToSelector:@selector(cell:didClickUser:)]) {
//            [_cell.delegate cell:_cell didClickUser:_cell.statusView.layout.status.user];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end





@implementation WBStatusToolbarView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellToolbarHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _dsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dsButton.exclusiveTouch = YES;
    _dsButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
    [_dsButton setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateNormal];
    _dsButton.frame = CGRectMake(kScreenWidth - 50 - 10, 10, 50, 25);
    [_dsButton setTitle:@"打赏" forState:(UIControlStateNormal)];
    [_dsButton setTitleColor:UIColorHex(ffffff) forState:(UIControlStateNormal)];
    _dsButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _dsButton.layer.cornerRadius = 2;
    _dsButton.layer.masksToBounds = YES;
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.exclusiveTouch = YES;
    _commentButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
    _commentButton.left = CGFloatPixelRound(self.width / 3.0);
    [_commentButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
    
    _commentButton.frame = CGRectMake(62 + 20 + 70, 5, 70, 35);
    [_commentButton setTitle:@"评论" forState:(UIControlStateNormal)];
    [_commentButton setTitleColor:UIColorHex(808080) forState:(UIControlStateNormal)];
    [_commentButton setImage:[UIImage imageNamed:@"find_comment"] forState:(UIControlStateNormal)];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.exclusiveTouch = YES;
    _likeButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
    _likeButton.left = CGFloatPixelRound(self.width / 3.0 * 2.0);
    [_likeButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
    _likeButton.frame = CGRectMake(62, 5, 70, 35);
    [_likeButton setTitle:@"点赞" forState:(UIControlStateNormal)];
    [_likeButton setTitleColor:UIColorHex(808080) forState:(UIControlStateNormal)];
    [_likeButton setImage:[UIImage imageNamed:@"find_like"] forState:(UIControlStateNormal)];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
    UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
    NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
    NSArray *locations = @[@0.2, @0.5, @0.8];

    
    _topLine = [CALayer layer];
    _topLine.size = CGSizeMake(self.width, CGFloatFromPixel(1));
    _topLine.backgroundColor = kWBCellLineColor.CGColor;
    
    _bottomLine = [CALayer layer];
    _bottomLine.size = _topLine.size;
    _bottomLine.bottom = self.height;
    _bottomLine.backgroundColor = UIColorHex(e8e8e8).CGColor;
    
    [self addSubview:_dsButton];
    [self addSubview:_commentButton];
    [self addSubview:_likeButton];
    [self.layer addSublayer:_line1];
    [self.layer addSublayer:_line2];
    [self.layer addSublayer:_topLine];
    [self.layer addSublayer:_bottomLine];
    
    @weakify(self);
    [_dsButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        // 打赏
        XFFindTableViewCell *cell = weak_self.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickRepost:)]) {
            [cell.delegate cellDidClickRepost:cell];
        }
    }];
    
    [_commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        // 评论
        XFFindTableViewCell *cell = weak_self.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickComment:)]) {
            [cell.delegate cellDidClickComment:cell];
        }
    }];
    
    [_likeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        // 点赞
        XFFindTableViewCell *cell = weak_self.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
            [cell.delegate cellDidClickLike:cell];
        }
    }];
    return self;
}
//
- (void)setWithLayout:(XFFindLayout *)layout {

}

- (UIImage *)likeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"find_like"];
    });
    return img;
}

- (UIImage *)unlikeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"find_liked"];

    });
    return img;
}

- (void)adjustImage:(UIImageView *)image label:(YYLabel *)label inButton:(UIButton *)button {
    CGFloat imageWidth = image.bounds.size.width;
    CGFloat labelWidth = label.width;
    CGFloat paddingMid = 5;
    CGFloat paddingSide = (button.width - imageWidth - labelWidth - paddingMid) / 2.0;
    image.centerX = CGFloatPixelRound(paddingSide + imageWidth / 2);
    label.right = CGFloatPixelRound(button.width - paddingSide);
}

//- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation {
//    XFFindLayout *layout = _cell.statusView.layout;
//    if (layout.status.attitudesStatus == liked) return;
//
//    UIImage *image = liked ? [self likeImage] : [self unlikeImage];
//    int newCount = layout.status.attitudesCount;
//    newCount = liked ? newCount + 1 : newCount - 1;
//    if (newCount < 0) newCount = 0;
//    if (liked && newCount < 1) newCount = 1;
//    NSString *newCountDesc = newCount > 0 ? [WBStatusHelper shortedNumberDesc:newCount] : @"赞";
//
//    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
//    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kWBCellToolbarHeight)];
//    container.maximumNumberOfRows = 1;
//    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:newCountDesc];
//    likeText.font = font;
//    likeText.color = liked ? kWBCellToolbarTitleHighlightColor : kWBCellToolbarTitleColor;
//    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:likeText];
//
//    layout.status.attitudesStatus = liked;
//    layout.status.attitudesCount = newCount;
//    layout.toolbarLikeTextLayout = textLayout;
//
//    if (!animation) {
//        _likeImageView.image = image;
//        _likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width);
//        _likeLabel.textLayout = layout.toolbarLikeTextLayout;
//        [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
//        return;
//    }
//
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
//        _likeImageView.layer.transformScale = 1.7;
//    } completion:^(BOOL finished) {
//
//        _likeImageView.image = image;
//        _likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width);
//        _likeLabel.textLayout = layout.toolbarLikeTextLayout;
//        [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
//
//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
//            _likeImageView.layer.transformScale = 0.9;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
//                _likeImageView.layer.transformScale = 1;
//            } completion:^(BOOL finished) {
//            }];
//        }];
//    }];
//}
@end




@implementation WBStatusView {
    BOOL _touchRetweetView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth - 20;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    @weakify(self);
    
    _contentView = [UIView new];
    _contentView.width = kScreenWidth;
    _contentView.height = 1;
    _contentView.backgroundColor = [UIColor whiteColor];

    [_contentView setMyShadowWithColor:UIColorHex(b0b0b0)];
    
    static UIImage *topLineBG, *bottomLineBG;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        topLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, 3, 4, 4));
            CGContextFillPath(context);
        }];
        bottomLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, -2, 4, 2));
            CGContextFillPath(context);
        }];
    });
    UIImageView *topLine = [[UIImageView alloc] initWithImage:topLineBG];
    topLine.width = _contentView.width;
    topLine.bottom = 0;
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [_contentView addSubview:topLine];
    
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:bottomLineBG];
    bottomLine.width = _contentView.width;
    bottomLine.top = _contentView.height;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_contentView addSubview:bottomLine];
    [self addSubview:_contentView];
    

    _profileView = [WBStatusProfileView new];
    [_contentView addSubview:_profileView];

    _textLabel = [YYLabel new];
    _textLabel.left = kCellCommentLeftPadding;
    _textLabel.width = kWBCellContentWidth;
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_textLabel];

    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        YYControl *imageView = [YYControl new];
        imageView.size = CGSizeMake(100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
//        imageView.backgroundColor = kWBCellHighlightColor;
        imageView.exclusiveTouch = YES;
        imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (![weak_self.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:)]) return;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [weak_self.cell.delegate cell:weak_self.cell didClickImageAtIndex:i];
                }
            }
        };
        
        UIView *badge = [UIImageView new];
        badge.userInteractionEnabled = NO;
        badge.contentMode = UIViewContentModeScaleAspectFit;
        badge.size = CGSizeMake(56 / 2, 36 / 2);
        badge.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        badge.right = imageView.width;
        badge.bottom = imageView.height;
        badge.hidden = YES;
        [imageView addSubview:badge];
        
        [picViews addObject:imageView];
        [_contentView addSubview:imageView];
    }
    _picViews = picViews;
//
//    _cardView = [WBStatusCardView new];
//    _cardView.hidden = YES;
//    [_contentView addSubview:_cardView];
//
//    _tagView = [WBStatusTagView new];
//    _tagView.left = kWBCellPadding;
//    _tagView.hidden = YES;
//    [_contentView addSubview:_tagView];
    
    _toolbarView = [WBStatusToolbarView new];
    [_contentView addSubview:_toolbarView];
    
    return self;
}


- (void)setLayout:(XFFindLayout *)layout {
    _layout = layout;
    
    self.height = layout.height;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    
    /// 圆角头像
    [_profileView.avatarView setImageWithURL:[NSURL URLWithString:@"http://ww2.sinaimg.cn/or180/6fc6f04egw1evuciu6zqlj20hs0vkab3.jpg"] //profileImageURL
                                 placeholder:layout.model.icon
                                     options:kNilOptions
                                     manager:[WBStatusHelper avatarImageManager] //< 圆角头像manager，内置圆角处理
                                    progress:nil
                                   transform:nil
                                  completion:nil];
    
    _profileView.nameLabel.textLayout = layout.nameTextLayout;
    _profileView.sourceLabel.textLayout = layout.sourceTextLayout;
//    _profileView.verifyType = layout.status.user.userVerifyType;
    _profileView.height = layout.profileHeight;
    _profileView.top = top;
    top += layout.profileHeight;
    
//    NSURL *picBg = [WBStatusHelper defaultURLForImageURL:layout.model.picBg];
//    __weak typeof(_vipBackgroundView) vipBackgroundView = _vipBackgroundView;
//    [_vipBackgroundView setImageWithURL:picBg placeholder:nil options:YYWebImageOptionAvoidSetImage completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
//        if (image) {
//            image = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
//            vipBackgroundView.image = image;
//        }
//    }];
    
    _textLabel.top = top;
    _textLabel.height = layout.textHeight;
    _textLabel.textLayout = layout.textLayout;
    top += layout.textHeight;
    
    
    
    _retweetBackgroundView.hidden = YES;
    _retweetTextLabel.hidden = YES;
    if (layout.picHeight == 0) {
        [self _hideImageViews];
    }
    
    if (layout.picHeight > 0) {
        [self _setImageViewWithTop:top isRetweet:NO];
    }

    
    _toolbarView.bottom = _contentView.height;
    [_toolbarView setWithLayout:layout];
}

- (void)_hideImageViews {
    for (UIImageView *imageView in _picViews) {
        imageView.hidden = YES;
    }
}

- (void)_setImageViewWithTop:(CGFloat)imageTop isRetweet:(BOOL)isRetweet {
    CGSize picSize =  _layout.picSize;
    NSArray *pics =  _layout.model.images;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 9; i++) {
        UIView *imageView = _picViews[i];
        if (i >= picsCount) {
            [imageView.layer cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = kCellCommentLeftPadding;
                    origin.y = imageTop;
                } break;
                case 4: {
                    origin.x = kCellCommentLeftPadding + (i % 2) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 2) * (picSize.height + kWBCellPaddingPic);
                } break;
                default: {
                    origin.x = kCellCommentLeftPadding + (i % 3) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kWBCellPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            WBPicture *pic = pics[i];
            
            UIView *badge = imageView.subviews.firstObject;
            switch (pic.largest.badgeType) {
                case WBPictureBadgeTypeNone: {
                    if (badge.layer.contents) {
                        badge.layer.contents = nil;
                        badge.hidden = YES;
                    }
                } break;
                case WBPictureBadgeTypeLong: {
                    badge.layer.contents = (__bridge id)([WBStatusHelper imageNamed:@"timeline_image_longimage"].CGImage);
                    badge.hidden = NO;
                } break;
                case WBPictureBadgeTypeGIF: {
                    badge.layer.contents = (__bridge id)([WBStatusHelper imageNamed:@"timeline_image_gif"].CGImage);
                    badge.hidden = NO;
                } break;
            }
            
            @weakify(imageView);
            [imageView.layer setImageWithURL:pic.bmiddle.url
                                 placeholder:nil
                                     options:YYWebImageOptionAvoidSetImage
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                      @strongify(imageView);
                                      if (!imageView) return;
                                      if (image && stage == YYWebImageStageFinished) {
                                          int width = pic.bmiddle.width;
                                          int height = pic.bmiddle.height;
                                          CGFloat scale = (height / width) / (imageView.height / imageView.width);
                                          if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                              imageView.contentMode = UIViewContentModeScaleAspectFill;
                                              imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                          } else { // 高图只保留顶部
                                              imageView.contentMode = UIViewContentModeScaleToFill;
                                              imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                                          }
                                          ((YYControl *)imageView).image = image;
                                          if (from != YYWebImageFromMemoryCacheFast) {
                                              CATransition *transition = [CATransition animation];
                                              transition.duration = 0.15;
                                              transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                              transition.type = kCATransitionFade;
                                              [imageView.layer addAnimation:transition forKey:@"contents"];
                                          }
                                      }
                                  }];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [(_contentView) performSelector:@selector(setBackgroundColor:) withObject:[UIColor whiteColor] afterDelay:0.15];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_touchRetweetView) {
        if ([_cell.delegate respondsToSelector:@selector(cellDidClickRetweet:)]) {
            [_cell.delegate cellDidClickRetweet:_cell];
        }
    } else {
        if ([_cell.delegate respondsToSelector:@selector(cellDidClick:)]) {
            [_cell.delegate cellDidClick:_cell];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}


@end


@implementation XFFindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _statusView = [WBStatusView new];
    _statusView.cell = self;
    _statusView.profileView.cell = self;
    _statusView.toolbarView.cell = self;
    [self.contentView addSubview:_statusView];
    
    self.contentView.backgroundColor = UIColorHex(f5f5f5);
    
    return self;
}

- (void)prepareForReuse {
    // ignore
}

- (void)setLayout:(XFFindLayout *)layout {
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}

@end
