//
//  XFCarouselView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCarouselView.h"
#import <UIImageView+YYWebImage.h>

@interface XFCarouselView () <UIScrollViewDelegate>

@property (assign, nonatomic) NSUInteger interval;

@property (strong, nonatomic) UIImage *placeHolder;
@property (strong, nonatomic) NSArray * imageArray;
@property (strong, nonatomic) UIScrollView *wheelScrollView;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSUInteger currentImageIndex;
@property (strong, nonatomic) UIImageView *image1;
@property (strong, nonatomic) UIImageView *image2;
@property (strong, nonatomic) UIImageView *image3;
@property (assign, nonatomic) NSUInteger imageNum;
@property (strong, nonatomic) UIImageView *mask;
@property (assign, nonatomic) BOOL isLocal;

@end

@implementation XFCarouselView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.mask = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.mask];
        self.wheelScrollView.scrollEnabled = NO;
    }
    return self;
}


-(void) setupWithArray:(NSArray *)array{
    self.wheelScrollView.scrollEnabled = YES;
    self.mask.hidden = YES;
    self.imageArray = array;
    self.imageNum = self.imageArray.count;
    self.currentImageIndex = 0;
    
    if (self.imageNum == 1) {
        self.wheelPageControl.hidden = YES;
        self.wheelScrollView.scrollEnabled = NO;
    }
    
    [self setup];
}

-(void) setup{

    

    [self setupTimer];
    [self updateImage];
}

- (void) updateImage{
    self.imageNum = (int)self.imageArray.count;
    self.wheelPageControl.numberOfPages = self.imageNum;
    [self updateScrollImage];
}

-(void) setupTimer{
    if (self.interval == 0) {
        self.interval = 3;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(updateWheel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void) updateScrollImage{
    int left;
    int right;
    int page = self.wheelScrollView.contentOffset.x / self.wheelScrollView.frame.size.width;
    if (page == 0) {
        self.currentImageIndex = (self.currentImageIndex + self.imageNum - 1) % self.imageNum;
    }else if(page == 2){
        self.currentImageIndex = (self.currentImageIndex + 1) % self.imageNum;
    }
    
    left = (int)(self.currentImageIndex + self.imageNum -1) % self.imageNum;
    right = (int)(self.currentImageIndex + 1) % self.imageNum;
    if (self.isLocal) {
        self.image1.image = [UIImage imageNamed:self.imageArray[left]];
        self.image2.image = [UIImage imageNamed:self.imageArray[self.self.currentImageIndex]];
        self.image3.image = [UIImage imageNamed:self.imageArray[right]];
    }else{
        
        [self.image1 setImageWithURL:[NSURL URLWithString:self.imageArray[left]]  placeholder:self.placeHolder];
        [self.image2 setImageWithURL:[NSURL URLWithString:self.imageArray[self.currentImageIndex]] placeholder:self.placeHolder];
        [self.image3 setImageWithURL:[NSURL URLWithString:self.imageArray[right]] placeholder:self.placeHolder];

    }
    
    self.wheelPageControl.currentPage = self.currentImageIndex;
    [self.wheelScrollView setContentOffset:CGPointMake(self.wheelScrollView.frame.size.width, 0) animated:NO];
}

- (void) updateWheel{
    CGPoint offset = self.wheelScrollView.contentOffset;
    offset.x += self.wheelScrollView.frame.size.width;
    [self.wheelScrollView setContentOffset:offset animated:YES];
}

-(void) setupWithLocalArray:(NSArray *)array{
    self.isLocal = YES;
    self.wheelScrollView.scrollEnabled = YES;
    self.mask.hidden = YES;
    self.imageArray = array;
    self.imageNum = self.imageArray.count;
    self.currentImageIndex = 0;
    
    if (self.imageNum == 1) {
        self.wheelPageControl.hidden = YES;
        self.wheelScrollView.scrollEnabled = NO;
    }
    
    [self setup];
}

#pragma mark - scrollViewdelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self updateScrollImage];

    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    [self updateScrollImage];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.timer invalidate];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self setupTimer];

    
}

- (UIScrollView *)wheelScrollView {
    
    if (_wheelScrollView == nil) {
        
        _wheelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _wheelScrollView.backgroundColor = [UIColor clearColor];
        _wheelScrollView.pagingEnabled = YES;
        _wheelScrollView.delegate = self;
        _wheelScrollView.showsHorizontalScrollIndicator = NO;
        _wheelScrollView.showsVerticalScrollIndicator = NO;
        
        _image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _image2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        _image3 = [[UIImageView alloc] initWithFrame:CGRectMake(2*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        
        _image2.image = self.placeHolder;
        for (UIImageView * img in @[_image1,_image2,_image3]) {
            [_wheelScrollView addSubview:img];
        }
        
        [_wheelScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        _wheelScrollView.scrollEnabled = YES;
        _wheelScrollView.contentSize = CGSizeMake(3*self.frame.size.width, self.frame.size.height);
        
        [self addSubview:_wheelScrollView];

        [_wheelScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.offset(0);
            
        }];
    }
    
    return _wheelScrollView;
}

-(UIPageControl *)wheelPageControl{
    if (!_wheelPageControl) {
        _wheelPageControl = [[UIPageControl alloc] init];
        _wheelPageControl.currentPage = 0;
        _wheelPageControl.numberOfPages = self.imageNum;
        [self addSubview:_wheelPageControl];

    }
    return _wheelPageControl;
}
@end
