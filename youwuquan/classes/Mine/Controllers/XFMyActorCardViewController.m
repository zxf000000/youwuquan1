//
//  XFMyActorCardViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyActorCardViewController.h"
#import "XFCardView.h"
#import "XFCardSizeCache.h"

#define itemWidth (kScreenWidth - 10)
#define itemHeight (itemWidth + 60)

#define itemX  5
#define itemY  32

#define frameOutside  CGRectMake(itemX, itemY, itemWidth, itemHeight)
#define frameMiddle  CGRectMake(itemX + 0.05 * itemWidth, itemY + 0.1 * itemHeight + 10, itemWidth * 0.9, itemHeight * 0.9)
#define frameInside  CGRectMake(itemX + 0.1 * itemWidth, itemY + 0.2 * itemHeight + 20, itemWidth * 0.8, itemHeight * 0.8)

@interface XFMyActorCardViewController () <XFCardViewDelegate>

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,copy) NSArray *bottomButtons;

@property (nonatomic,strong) NSArray *selectedButtons;

@property (nonatomic,strong) UIView *view1;
@property (nonatomic,strong) UIView *view2;
@property (nonatomic,strong) UIView *view3;

@property (nonatomic,strong) UIDynamicAnimator *animator;

@property (nonatomic,assign) BOOL isLeft;

@property (nonatomic,assign) CGFloat currentAngle;

@property (nonatomic,assign) CGPoint originalCenter;

@property (nonatomic,copy) NSArray *cards;

@property (nonatomic,assign) CGAffineTransform middleTransform;

@property (nonatomic,assign) CGAffineTransform insideTransform;

@property (nonatomic,assign) NSInteger selectedNumber;

@property (nonatomic,copy) NSArray *sizeArr;


@end

@implementation XFMyActorCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模板选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBottomView];
    
    [self setupCards];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
}
// 选择模板
- (void)cardView:(XFCardView *)cardView didSelectedCardWithindex:(NSInteger)index {
    
    NSArray *arr = self.sizeArr[self.selectedNumber];
    
    NSArray *frames = arr[index];
    
    
    
}



- (void)setupCardsWithSizearr:(NSArray *)array {
    
    for (NSInteger i = 0 ;i < self.cards.count ; i ++ ) {
        
        NSArray *frames = array[i];
        XFCardView *card = self.cards[i];
        
        [card setLayoutWithFrame:frames];
        
    }
    
}

- (void)setupCards {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < 3 ; i ++ ) {
        
        XFCardView *view;
        view = [[XFCardView alloc] initWithFrame:frameOutside];

        if (i == 0) {

            view.transform = self.insideTransform;
            view.numberLabel.text  =@"3";
        }
        
        if (i == 1) {

            view.transform = self.middleTransform;
            view.numberLabel.text  =@"2";

        }
        
        if (i == 2) {
            view.numberLabel.text  =@"1";

        }
        
        view.index = i;
        
        view.delegate = self;
        
        [self.view addSubview:view];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        
        [view addGestureRecognizer:pan];
        
        [arr addObject:view];
    }
    
    self.originalCenter = CGPointMake(frameOutside.size.width/2 + frameOutside.origin.x, frameOutside.size.height/2 + frameOutside.origin.y);
    
    self.cards = arr.copy;
    [self clickSelectedNumnberButton:self.selectedButtons[0]];

}

- (void)panView:(UIPanGestureRecognizer *)pan {

    
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:
        {
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint movePoint = [pan translationInView:self.view];
            _isLeft = (movePoint.x < 0);
            
            pan.view.center = CGPointMake(pan.view.center.x + movePoint.x, pan.view.center.y + movePoint.y);
            
            CGFloat angle = (pan.view.center.x - pan.view.frame.size.width / 2.0) / pan.view.frame.size.width / 4.0;
            
            _currentAngle = angle;
            
            pan.view.transform = CGAffineTransformMakeRotation(angle);
            
            [pan setTranslation:CGPointZero inView:self.view];
            
        }
            break;
        default:
        {
            CGPoint vel = [pan velocityInView:self.view];
            if (vel.x > 800 || vel.x < - 800) {
                [self removeView:pan.view];
                return ;
            }
            if (pan.view.frame.origin.x + pan.view.frame.size.width > 150 && pan.view.frame.origin.x < pan.view.frame.size.width - 150) {
                [UIView animateWithDuration:0.5 animations:^{
                    pan.view.center = self.originalCenter;
                    pan.view.transform = CGAffineTransformMakeRotation(0);
                }];
            } else {
                [self removeView:pan.view];
            }
            
        }
            break;
    }
    
}

- (void)removeView:(UIView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        
        // right
        if (!_isLeft) {
            view.center = CGPointMake(view.frame.size.width + 1000, view.center.y + _currentAngle * view.frame.size.height);
        } else { // left
            view.center = CGPointMake(- 1000, view.center.y - _currentAngle * view.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [view removeFromSuperview];
//            if ([self.delegate respondsToSelector:@selector(cardItemViewDidRemoveFromSuperView:)]) {
//                [self.delegate cardItemViewDidRemoveFromSuperView:self];
//            }

            
            NSInteger index = [self.cards indexOfObject:view];
            
            NSInteger middleIndex = index - 1 == -1? 2:index-1;
            NSInteger insideIndex = middleIndex - 1 == -1?2:middleIndex - 1;
            
            UIView *middleView = self.cards[middleIndex];
            UIView *insideView = self.cards[insideIndex];
            view.transform = CGAffineTransformIdentity;
            view.frame = frameOutside;

            view.transform = self.insideTransform;
            [self.view insertSubview:view belowSubview:insideView];
            
            
            [UIView animateWithDuration:0.2 animations:^{
               
                middleView.transform = CGAffineTransformIdentity;

                insideView.transform = self.middleTransform;
            }];
            
            
            
        }
    }];
    
}


- (void)clickSelectedNumnberButton:(UIButton *)sender {
    
    sender.selected = YES;
    
    for (UIButton *button in self.selectedButtons) {
        
        if (sender != button) {
            
            button.selected = NO;
            
        }
        
    }
    
    XFCardSizeCache *cache = [XFCardSizeCache sharedInstance];
    
    NSArray *sizearr;
    
    switch (sender.tag) {
            
        case 4001:
        {
            sizearr = cache.threeSize;
            self.selectedNumber = 0;

        }
            break;
        case 4002:
        {
            sizearr = cache.fourSize;
            self.selectedNumber = 1;

        }
            break;
        case 4003:
        {
            sizearr = cache.fiveSize;
            self.selectedNumber = 2;

        }
            break;
        case 4004:
        {
            sizearr = cache.sixSize;
            self.selectedNumber = 3;

        }
            break;
        case 4005:
        {
            sizearr = cache.sevenSize;
            self.selectedNumber = 4;

        }
            break;
        case 4006:
        {
            sizearr = cache.eightSize;
            self.selectedNumber = 5;

        }
            break;
    }
    [self setupCardsWithSizearr:sizearr];

}

- (void)setupBottomView {
    
    self.bottomView = [[UIView alloc] init];
    
    self.bottomView.frame = CGRectMake(0, kScreenHeight - 99 - 64, kScreenWidth, 99);
    
    [self.view addSubview:self.bottomView];
    
    // 添加底部Button
    for (NSInteger i = 0 ; i < self.bottomButtons.count ; i ++ ) {
        
        UIView *button = self.bottomButtons[i];
        
        [self.bottomView addSubview:button];
        
    }
    
    
}

- (NSArray *)bottomButtons {
    
    if (_bottomButtons == nil) {
        
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *selecetdArr = [NSMutableArray array];
        NSArray *imgs = @[@"off3",@"off4",@"off5",@"off6",@"off7",@"off8"];
        NSArray *selectedImgs = @[@"on3",@"on4",@"on5",@"on6",@"on7",@"on8"];
        NSArray *titles = @[@"三图",@"四图",@"五图",@"六图",@"七图",@"八图"];
        
        CGFloat bottomitemWidth = 47;
        CGFloat bottomitemheight = 76;
        CGFloat padding = (kScreenWidth - 47 * 6)/7.f;
        
        for (NSInteger i = 0 ; i < 6 ; i ++ ) {
            
            CGFloat x = padding + (padding + bottomitemWidth) * i;
            
            UIView *button = [[UIView alloc] init];
            button.frame = CGRectMake(x, 0, bottomitemWidth, bottomitemheight);
            
            [arr addObject:button];
            
            UIButton *buttonTop = [[UIButton alloc] init];
            [buttonTop setImage:[UIImage imageNamed:imgs[i]] forState:(UIControlStateNormal)];
            [buttonTop setImage:[UIImage imageNamed:selectedImgs[i]] forState:(UIControlStateSelected)];
            buttonTop.frame = CGRectMake(0, 0, bottomitemWidth, bottomitemWidth);
            [button addSubview:buttonTop];
            buttonTop.tag= 4001 + i;
            [buttonTop addTarget:self action:@selector(clickSelectedNumnberButton:) forControlEvents:(UIControlEventTouchDown)];
            
            UILabel *bottomLabel = [[UILabel alloc] init];
            bottomLabel.text = titles[i];
            bottomLabel.frame = CGRectMake(0, bottomitemWidth, bottomitemWidth, bottomitemheight - bottomitemWidth);
            bottomLabel.font = [UIFont systemFontOfSize:12];
            bottomLabel.textAlignment = NSTextAlignmentCenter;
            [button addSubview:bottomLabel];
            bottomLabel.textColor = UIColorHex(808080);
            [selecetdArr addObject:buttonTop];
            
        }
        
        _bottomButtons = arr.copy;
        _selectedButtons = selecetdArr.copy;
    }
    return _bottomButtons;
}

- (CGAffineTransform)middleTransform {

    CGAffineTransform translation = CGAffineTransformMakeTranslation(0,  itemHeight * 0.05 + 10);
    CGAffineTransform scale = CGAffineTransformMakeScale(0.9, 0.9);
    _middleTransform = CGAffineTransformConcat(translation, scale);

    return _middleTransform;

}

- (CGAffineTransform)insideTransform {
    
    
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0, itemHeight * 0.1 + 25);
    CGAffineTransform scale = CGAffineTransformMakeScale(0.8, 0.8);
    _insideTransform = CGAffineTransformConcat(translation, scale);
    
    return _insideTransform;
    
}

- (NSArray *)sizeArr {
    
    if (_sizeArr == nil) {
        XFCardSizeCache *cache = [XFCardSizeCache sharedInstance];
        _sizeArr = @[cache.threeSize,cache.fourSize,
                     cache.fiveSize,cache.sixSize,
                     cache.sevenSize,cache.eightSize];
    }
    return _sizeArr;
    
}

@end
