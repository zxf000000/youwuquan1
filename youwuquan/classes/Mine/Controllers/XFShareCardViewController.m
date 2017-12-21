//
//  XFMyActorCardViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFShareCardViewController.h"
#import "XFShareCardView.h"
#import "XFShareManager.h"

#define itemWidth (kScreenWidth - 20)
#define itemHeight (kScreenHeight - 64 - 20 - 20)

#define itemX  10
#define itemY  20

#define frameOutside  CGRectMake(itemX, itemY, itemWidth, itemHeight)
#define frameMiddle  CGRectMake(itemX + 0.05 * itemWidth, itemY + 0.1 * itemHeight + 5, itemWidth * 0.9, itemHeight * 0.9)
#define frameInside  CGRectMake(itemX + 0.1 * itemWidth, itemY + 0.2 * itemHeight + 10, itemWidth * 0.8, itemHeight * 0.8)

@interface XFShareCardViewController () <XFShareCardViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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

@property (nonatomic,copy) NSArray *picArr;

@property (nonatomic,copy) NSArray *sizeArr;

@property (nonatomic,assign) NSInteger bottomIndex;

@property (nonatomic,strong) XFShareCardView *addView;
@property (nonatomic,strong) XFShareCardView *outsideView;

@end

@implementation XFShareCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"模板选择";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setupBottomView];
    
    self.picArr = @[@"find1",@"find2",@"find3",@"find4"];
    
    [self setupSizes];
    
    [self setupCards];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 60, 30))];
    [shareButton setTitle:@"分享" forState:(UIControlStateNormal)];
    [shareButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    [shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)clickShareButton {
    
    UIGraphicsBeginImageContextWithOptions(self.outsideView.bounds.size, NO, 0);
    
    [self.outsideView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // 分享
    [XFShareManager shareImageWith:image];
    
}

- (void)setupCards {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < 3 ; i ++ ) {
        
        XFShareCardView *view;
        view = [[XFShareCardView alloc] initWithFrame:frameOutside];
        
        view.picView.image = [UIImage imageNamed:self.picArr[i]];
        view.delegate = self;

        self.bottomIndex = i;
        
        view.type = XFCardShareViewtypePic;
        
        if (i == 0) {
            
            view.transform = self.insideTransform;
//            view.numberLabel.text  =@"3";
        }
        
        if (i == 1) {
            
            view.transform = self.middleTransform;
//            view.numberLabel.text  =@"2";
            
        }
        
        if (i == 2) {
//            view.numberLabel.text  =@"1";
            self.outsideView = view;

        }
        
//        view.index = i;
//
//        view.delegate = self;
        
        [self.view addSubview:view];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        
        [view addGestureRecognizer:pan];
        
        [arr addObject:view];
    }
    
    self.originalCenter = CGPointMake(frameOutside.size.width/2 + frameOutside.origin.x, frameOutside.size.height/2 + frameOutside.origin.y);
    
    self.cards = arr.copy;

}

- (void)setupSizes {
    
    NSInteger picCount = self.picArr.count;
    
    CGFloat maxRatio = 0.7;
    CGFloat padding = 5;
    CGFloat ratioSpace = maxRatio/(CGFloat)picCount;
    
    NSMutableArray *sizeArr = [NSMutableArray array];
    for (NSInteger i = 0 ; i < picCount ; i ++ ) {
        
        CGRect frame = CGRectMake(itemX + ratioSpace/2.f * i * itemWidth, itemY + ratioSpace*2 * itemHeight + padding * 2, itemWidth * (1- ratioSpace * i), itemHeight * (1- ratioSpace));
        
        [sizeArr addObject:[NSValue valueWithCGRect:frame]];

    }
    
    self.sizeArr = sizeArr.copy;
    
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

- (void)removeView:(XFShareCardView *)view {
    
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
            
            XFShareCardView *middleView = self.cards[middleIndex];
            XFShareCardView *insideView = self.cards[insideIndex];
            view.transform = CGAffineTransformIdentity;
            view.frame = frameOutside;
            view.transform = self.insideTransform;
            [self.view insertSubview:view belowSubview:insideView];
            
            self.outsideView = middleView;
            
            self.bottomIndex += 1;
            
            if (self.bottomIndex == self.picArr.count) {
                
                view.type = XFCardShareViewtypeAdd;
                
                self.addView = view;
                self.bottomIndex = -1;
                
                
            } else {
                
                view.picView.image = [UIImage imageNamed:self.picArr[self.bottomIndex]];
                view.type = XFCardShareViewtypePic;
                
            }
            
            [UIView animateWithDuration:0.2 animations:^{
               
                middleView.transform = CGAffineTransformIdentity;

                insideView.transform = self.middleTransform;
            }];

            
        }
    }];
    
}

#pragma mark - addbuttonDelegate
- (void)xfShareCardView:(XFShareCardView *)shareCard didClickAddbutton:(UIButton *)addButton {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;

    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];

    }];
    
    
    UIAlertAction *actionCacnel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:actionPhoto];
    [alert addAction:actionCamera];
    [alert addAction:actionCacnel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:^{
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.addView.picView.image = image;
            self.addView.type = XFCardShareViewtypePic;
            self.addView.shadowView.hidden = NO;
        });
        
        
    }];
    
}

//
//- (void)clickSelectedNumnberButton:(UIButton *)sender {
//
//    sender.selected = YES;
//
//    for (UIButton *button in self.selectedButtons) {
//
//        if (sender != button) {
//
//            button.selected = NO;
//
//        }
//
//    }
//
//    XFCardSizeCache *cache = [XFCardSizeCache sharedInstance];
//
//    NSArray *sizearr;
//
//    switch (sender.tag) {
//
//        case 4001:
//        {
//            sizearr = cache.threeSize;
//            self.selectedNumber = 0;
//
//        }
//            break;
//        case 4002:
//        {
//            sizearr = cache.fourSize;
//            self.selectedNumber = 1;
//
//        }
//            break;
//        case 4003:
//        {
//            sizearr = cache.fiveSize;
//            self.selectedNumber = 2;
//
//        }
//            break;
//        case 4004:
//        {
//            sizearr = cache.sixSize;
//            self.selectedNumber = 3;
//
//        }
//            break;
//        case 4005:
//        {
//            sizearr = cache.sevenSize;
//            self.selectedNumber = 4;
//
//        }
//            break;
//        case 4006:
//        {
//            sizearr = cache.eightSize;
//            self.selectedNumber = 5;
//
//        }
//            break;
//    }
//    [self setupCardsWithSizearr:sizearr];
//
//}



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


@end
