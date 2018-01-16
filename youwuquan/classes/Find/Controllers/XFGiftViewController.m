//
//  XFGiftViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFGiftViewController.h"
#import "XFPublishVCTransation.h"
#import "XFGiftManager.h"
#import "XFFindNetworkManager.h"
#import "XFMineNetworkManager.h"

#define kGiftViewWidth (kScreenWidth - 20)
#define kRatio kScreenWidth/375.f

@implementation XFGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _flowerButton = [[UIButton alloc] init];
        [_flowerButton setImage:[UIImage imageNamed:@"hua1"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:_flowerButton];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.text = @"88";
        [self.contentView addSubview:_numberLabel];
        
        _diamondPic = [[UIImageView alloc] init];
        _diamondPic.image = [UIImage imageNamed:@"zuanshi"];
        [self.contentView addSubview:_diamondPic];
        
        [_flowerButton addTarget:self action:@selector(clickFlowerButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)clickFlowerButton {
    
    if (self.clickFlowButtonBlock) {
        
        self.clickFlowButtonBlock(self.indexpath);
    }
    
}

- (void)updateConstraints {
    
    [self.flowerButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_offset(0);
        make.height.width.mas_equalTo(50);
        make.centerX.mas_offset(0);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.flowerButton.mas_bottom).offset(5);
        make.centerX.mas_offset(0);
        
    }];
    
    [self.diamondPic mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_offset(0);
        make.width.height.mas_equalTo(22*kRatio);
        make.centerX.mas_offset(0);
        
    }];
    
    [super updateConstraints];
}

@end

@interface XFGiftViewController () <UIViewControllerTransitioningDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UIButton *giftButton;
@property (nonatomic,strong) UIView *slideView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UICollectionView *giftCollectionView;
@property (nonatomic,strong) UIView *realGiftView;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIButton *minusButton;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *doneButton;

@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) UIButton *rewardButton;

@property (nonatomic,strong) UITextField *numberTextField;

@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) NSIndexPath *giftSelectedIndex;

@property (nonatomic,strong) UILabel *descriptLabel;

@property (nonatomic,strong) UIButton *realButton;

@property (nonatomic,copy) NSDictionary *balance;

@end

@implementation XFGiftViewController

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        self.transitioningDelegate = self;
        
//        _gifts = @[@{@"icon":@"hua1",@"icons":@"hua1none",@"price":@"88"},@{@"icon":@"hua2",@"icons":@"hua2none",@"price":@"100"},@{@"icon":@"hua3",@"icons":@"hua3none",@"price":@"99"},@{@"icon":@"hua4",@"icons":@"hua4none",@"price":@"120"},@{@"icon":@"hua5",@"icons":@"hua5none",@"price":@"999"}];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.view.layer.cornerRadius = 15;
    
    [self setupGiftView];
    
    [self loadGifts];
    
    [self loadbalance];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSInteger number = [textField.text integerValue];
    
    // 更新金额
    
    if (!self.giftSelectedIndex) {
        
        return;
    }
    
    XFGiftModel *model = self.gifts[self.giftSelectedIndex.item];
    
    NSInteger singlePrice = [model.diamonds integerValue];
    
    [self setTotalNumberWith:[NSString stringWithFormat:@"%zd",singlePrice * number]];
    
    return;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];

    NSInteger number = [textField.text integerValue];
    
    // 更新金额
    
    if (!self.giftSelectedIndex) {
        
        return YES;
    }
    
    XFGiftModel *model = self.gifts[self.giftSelectedIndex.item];
    
    NSInteger singlePrice = [model.diamonds integerValue];
    
    [self setTotalNumberWith:[NSString stringWithFormat:@"%zd",singlePrice * number]];
    
    
    return YES;
}

- (void)loadbalance {
    
    [XFMineNetworkManager getMyWalletDataWithSuccessBlock:^(id responseObj) {
        
        self.balance = (NSDictionary *)responseObj;
        
        _detailLabel.text = [NSString stringWithFormat:@"您目前钻石余额: %@",self.balance[@"balance"]];

        
    } failedBlock:^(NSError *error) {
        
    } progressBlock:^(CGFloat progress) {
        
    }];
    
}

- (void)loadGifts {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.view];
    
    [XFFindNetworkManager getGiftListWithSuccessBlock:^(id responseObj) {
        
        [HUD hideAnimated:YES];
        
        NSDictionary *info = (NSDictionary *)responseObj;
        NSArray *datas = info[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < datas.count ;i ++) {
            
            [arr addObject:[XFGiftModel modelWithDictionary:datas[i]]];
            
        }
        
        self.gifts = arr.copy;
        
        [self.giftCollectionView reloadData];
        
    } failBlock:^(NSError *error) {
        [HUD hideAnimated:YES];

    } progress:^(CGFloat progress) {
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    return [XFPublishVCTransation transitionWithtype:GiftPresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return [XFPublishVCTransation transitionWithtype:GiftDismiss];
    
}

- (void)clikCacnelButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupGiftView {
    
    CGFloat width = kScreenWidth - 20;
    CGFloat height = width * 44 / 35.f;
    
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setImage:[UIImage imageNamed:@"dashang_cancel"] forState:(UIControlStateNormal)];
    [_cancelButton addTarget:self action:@selector(clikCacnelButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_cancelButton];
    
    _iconView = [[UIImageView alloc] init];
    _iconView.frame = CGRectMake((width - 44)/2, 34 * kRatio, 44, 44);
    [_iconView setImageWithURL:[NSURL URLWithString:self.iconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 22;
    [self.view addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = [NSString stringWithFormat:@"打赏%@",self.userName];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    _rewardButton = [[UIButton alloc] init];
    [_rewardButton setTitle:@"打赏" forState:(UIControlStateNormal)];
    [_rewardButton setTitleColor:kMainRedColor forState:(UIControlStateSelected)];
    [_rewardButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    _rewardButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_rewardButton];
    
    _giftButton = [[UIButton alloc] init];
    [_giftButton setTitle:@"礼物" forState:(UIControlStateNormal)];
    [_giftButton setTitleColor:kMainRedColor forState:(UIControlStateSelected)];
    [_giftButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    _giftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_giftButton];
    
    _slideView = [[UIView alloc] init];
    _slideView.backgroundColor = kMainRedColor;
    [self.view addSubview:_slideView];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = width/5.f;
    CGFloat itemHeight = 102 * kRatio;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    _giftCollectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    _giftCollectionView.backgroundColor = [UIColor whiteColor];
    _giftCollectionView.delegate = self;
    _giftCollectionView.dataSource = self;
    [_giftCollectionView registerClass:[XFGiftCell class] forCellWithReuseIdentifier:@"XFGiftCell"];
    
    [_scrollView addSubview:_giftCollectionView];
    
    _realGiftView = [[UIView alloc] init];
    _realGiftView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_realGiftView];
    
    _minusButton = [[UIButton alloc] init];
    [_minusButton setImage:[UIImage imageNamed:@"gift_minus"] forState:(UIControlStateNormal)];
    [self.view addSubview:_minusButton];
    
    _addButton = [[UIButton alloc] init];
    [_addButton setImage:[UIImage imageNamed:@"gift_add"] forState:(UIControlStateNormal)];
    [self.view addSubview:_addButton];
    
    _numberTextField = [[UITextField alloc] init];
    _numberTextField.font = [UIFont systemFontOfSize:36];
    _numberTextField.text = @"99";
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _numberTextField.returnKeyType = UIReturnKeyDone;
    _numberTextField.delegate = self;
    [self.view addSubview:_numberTextField];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.text = @"朵";
    _numberLabel.textColor = UIColorHex(808080);
    [self.view addSubview:_numberLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorHex(808080);
    [self.view addSubview:lineView];
    
    _doneButton = [[UIButton alloc] init];
    _doneButton.backgroundColor = kMainRedColor;
    _doneButton.layer.cornerRadius = 44 * kRatio / 2;
    [self.view addSubview:_doneButton];
    
    [self setTotalNumberWith:@"0"];

//    [_doneButton setAttributedTitle:buttonStr forState:(UIControlStateNormal)];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:12];
    _detailLabel.textColor = UIColorHex(808080);
    _detailLabel.text = [NSString stringWithFormat:@"您目前钻石余额: %@",@"10000"];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_detailLabel];
    
    _descriptLabel = [[UILabel alloc] init];
    _descriptLabel.text = @"玫瑰到家(您所赠送的玫瑰会快递到TA手中)";
    _descriptLabel.textColor = UIColorHex(808080);
    _descriptLabel.font = [UIFont systemFontOfSize:12];
    _descriptLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_descriptLabel];
    
    _realButton = [[UIButton alloc] init];
    [_realButton setImage:[UIImage imageNamed:@"gift_meigui"] forState:(UIControlStateNormal)];
    [self.realGiftView addSubview:_realButton];
    
    
    _descriptLabel.hidden = YES;
    
    _cancelButton.frame = CGRectMake(width - 40, 0, 40, 40);
    
    _titleLabel.left = 0;
    _titleLabel.top = _iconView.bottom + 8 * kRatio;
    _titleLabel.height = 15;
    _titleLabel.width = width;
    
    _rewardButton.left = (width - 160)/2;
    _rewardButton.width = 60;
    _rewardButton.height = 20 * kRatio;
    _rewardButton.top = _titleLabel.bottom + 27 * kRatio;
    
    _giftButton.centerX = _rewardButton.right + 40;
    _giftButton.width = 60;
    _giftButton.height = 20 * kRatio;
    _giftButton.top = _titleLabel.bottom + 27 * kRatio;
    
    _slideView.frame = CGRectMake(_rewardButton.left, _rewardButton.bottom + 5 * kRatio, 60, 2);
    
    _descriptLabel.frame = CGRectMake(0, _slideView.bottom + 7 * kRatio, width, 12);
    
    _scrollView.frame = CGRectMake(0, _slideView.bottom + 25 * kRatio, width, itemHeight);
    _giftCollectionView.frame = CGRectMake(0, 0, width, itemHeight);
    _realGiftView.frame = CGRectMake(width, 0, width, itemHeight);

    _numberTextField.frame = CGRectMake((width - 110)/2, _scrollView.bottom + 22 * kRatio, 110, 27);
    _numberTextField.textAlignment = NSTextAlignmentCenter;
    
    lineView.frame = CGRectMake(_numberTextField.left, _numberTextField.bottom + 5 * kRatio, _numberTextField.width, 1);
    
    _minusButton.left = _numberTextField.left - 69;
    _minusButton.width = 69;
    _minusButton.height = 27;
    _minusButton.top = _numberTextField.top;
    
    _addButton.left = _numberTextField.right;
    _addButton.width = 69;
    _addButton.height = 27;
    _addButton.top = _numberTextField.top;
    
    _numberLabel.frame = CGRectMake(_numberTextField.right, lineView.bottom - 20, 20, 20);
    
    _detailLabel.frame = CGRectMake(0, height - 17* kRatio - 12, width, 12);

    _doneButton.frame = CGRectMake((width - 230)/2, height - _detailLabel.height - 17 * kRatio - 12 * kRatio - 44, 230, 44);
    
    _realButton.frame = CGRectMake((width - self.scrollView.height)/2, 0, self.scrollView.height, self.scrollView.height);

    [_addButton addTarget:self action:@selector(clicknumberbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    [_minusButton addTarget:self action:@selector(clicknumberbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 设置状态
    _rewardButton.selected = YES;
    
    [_giftButton addTarget:self action:@selector(clickGiftButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [_rewardButton addTarget:self action:@selector(clickGiftButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)clickDoneButton {
    
    if (!self.giftSelectedIndex) {
        
        [XFToolManager showProgressInWindowWithString:@"请选择礼物"];
        
        return;
    }
    
    if ([self.numberTextField.text intValue] <= 0) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的数量"];
        
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:[UIApplication sharedApplication].keyWindow];
        
        XFGiftModel *model = self.gifts[self.giftSelectedIndex.item];
        
        [XFFindNetworkManager rewardSomeoneWithUid:self.uid rewardResourceId:[model.id integerValue] amount:[self.numberTextField.text longValue] successBlock:^(id responseObj) {
            // 打赏成功
            [XFToolManager changeHUD:HUD successWithText:@"打赏成功"];
            
        } failBlock:^(NSError *error) {
            [HUD hideAnimated:YES];
            
        } progress:^(CGFloat progress) {
            
            
        }];
        
    }];
    

    
    
//    [self dismissViewControllerAnimated:YES completion:^{
//
//        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:[UIApplication sharedApplication].keyWindow];
//        HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//        HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
//        HUD.contentColor = [UIColor whiteColor];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            HUD.mode = MBProgressHUDModeCustomView;
//            HUD.detailsLabel.text = @"打赏成功!";
//            UIImageView *img = [[UIImageView alloc] init];
//            img.image = [UIImage imageNamed:@"ds_ok"];
//            HUD.customView = img;
//            HUD.tintColor = [UIColor blackColor];
//            HUD.animationType = MBProgressHUDAnimationZoom;
//            [HUD hideAnimated:YES afterDelay:0.4];
//
//
//            if ([self.delegate respondsToSelector:@selector(xfGiftVC:didSuccessSendGift:)]) {
//
//                [self.delegate xfGiftVC:self didSuccessSendGift:nil];
//            }
//        });
//
//    }];
    

    
}



- (void)setTotalNumberWith:(NSString *)number {
    
    NSString *titleleft = [NSString stringWithFormat:@"打赏(共%@",number];
    NSString *title = [NSString stringWithFormat:@"打赏(共%@)",number];
    
    NSMutableAttributedString *buttonStr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15],
                                                                                                                 NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                                                                 }];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    textAttachment.image = [UIImage imageNamed:@"zuanshi"];
    textAttachment.bounds = CGRectMake(0, -5, 20, 20);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(textAttachment)];
    [buttonStr insertAttributedString:imgStr atIndex:titleleft.length];
    
    
    [_doneButton setAttributedTitle:buttonStr forState:(UIControlStateNormal)];
    
}

- (void)clickGiftButton:(UIButton *)button {
    
    if (button == _rewardButton) {
        
        self.rewardButton.selected = YES;
        self.giftButton.selected = NO;
        _slideView.frame = CGRectMake(_rewardButton.left, _rewardButton.bottom + 5 * kRatio, 60, 2);
        [self.scrollView setContentOffset:(CGPointMake(0, 0)) animated:YES];
        _descriptLabel.hidden = YES;
        self.numberTextField.text = @"99";
        
        if (self.gifts.count == 0 || self.gifts == nil) {
            
            [XFToolManager showProgressInWindowWithString:@"还没有礼物"];
            
            return;
        }
        
        XFGiftModel *model = self.gifts[self.giftSelectedIndex.item];
        NSInteger singlePrice = [model.diamonds intValue];
        NSInteger number = [self.numberTextField.text intValue];
        
        [self setTotalNumberWith:[NSString stringWithFormat:@"%zd",singlePrice * number]];

    } else {
        
        self.rewardButton.selected = NO;
        self.giftButton.selected = YES;
        _slideView.frame = CGRectMake(_giftButton.left, _giftButton.bottom + 5 * kRatio, 60, 2);
        [self.scrollView setContentOffset:(CGPointMake(kGiftViewWidth, 0)) animated:YES];
        _descriptLabel.hidden = NO;
        self.numberTextField.text = @"9";
        
        NSInteger singlePrice = 99;
        
        NSInteger number = [self.numberTextField.text intValue];
        
        [self setTotalNumberWith:[NSString stringWithFormat:@"%zd",singlePrice * number]];
    }
    
}

- (void)clicknumberbutton:(UIButton *)button {
    
    if (button == self.addButton) {
        
        self.numberTextField.text = [NSString stringWithFormat:@"%zd",[self.numberTextField.text integerValue] + 1];

    } else {
        
        if ([self.numberTextField.text intValue] > 1) {
            
            self.numberTextField.text = [NSString stringWithFormat:@"%zd",[self.numberTextField.text integerValue] - 1];

        }
    
    }
    
    if (self.rewardButton.selected) {
        
        if (self.giftSelectedIndex) {
            
            XFGiftModel *model = self.gifts[self.giftSelectedIndex.row];
            
            
//            NSDictionary *info = self.gifts[self.giftSelectedIndex.row];
            
//            NSInteger singlePrice = [info[@"price"] intValue];
            NSInteger singlePrice = [model.diamonds intValue];

            NSInteger number = [self.numberTextField.text intValue];
            
            [self setTotalNumberWith:[NSString stringWithFormat:@"%zd",singlePrice * number]];
        }
        

    } else {
        
        NSInteger singlePrice = 99;
        
        NSInteger number = [self.numberTextField.text intValue];
        
        [self setTotalNumberWith:[NSString stringWithFormat:@"%zd",singlePrice * number]];
        
    }
    

    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.gifts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFGiftCell" forIndexPath:indexPath];
    
    XFGiftModel *model = self.gifts[indexPath.item];
    
//    NSDictionary *info = self.gifts[indexPath.item];
    
//    [cell.flowerButton setImage:[UIImage imageNamed:info[@"icons"]] forState:(UIControlStateNormal)];
//    [cell.flowerButton setImage:[UIImage imageNamed:info[@"icon"]] forState:(UIControlStateSelected)];
    [cell.flowerButton setImageWithURL:[NSURL URLWithString:model.iconUrl] forState:(UIControlStateNormal) options:(YYWebImageOptionSetImageWithFadeAnimation)];
    [cell.flowerButton setBackgroundImage:[UIImage imageNamed:@"hua1none"] forState:(UIControlStateNormal)];
    [cell.flowerButton setBackgroundImage:[UIImage imageNamed:@"hua1"] forState:(UIControlStateSelected)];
    cell.numberLabel.text = model.diamonds;
    
    cell.indexpath = indexPath;
    
    cell.clickFlowButtonBlock = ^(NSIndexPath *giftIndex) {
        
        if (self.giftSelectedIndex) {
            
            XFGiftCell *cell = (XFGiftCell *)[collectionView cellForItemAtIndexPath:self.giftSelectedIndex];
            
            cell.flowerButton.selected = NO;
            
        }
        
        if (self.giftSelectedIndex != giftIndex) {
            
            self.numberTextField.text = @"99";
            
        } else {
            
            self.numberTextField.text = [NSString stringWithFormat:@"%zd",[self.numberTextField.text integerValue] + 1];
            
        }
        
        XFGiftCell *cell = (XFGiftCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell.flowerButton.selected = YES;
        
        self.giftSelectedIndex = indexPath;
        
//        NSDictionary *info = self.gifts[indexPath.row];
        
        XFGiftModel *model = self.gifts[indexPath.item];
        
        NSInteger singlePrice = [model.diamonds integerValue];
        
        NSInteger number = [self.numberTextField.text intValue];
        
        [self setTotalNumberWith:[NSString stringWithFormat:@"%zd",singlePrice * number]];

    };

    return cell;
    
}

@end
