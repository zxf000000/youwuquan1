//
//  XFPayViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFPayViewController.h"
#import "XFSlideView.h"
#import "XFVipTableViewCell.h"
#import "XFChargeTableViewCell.h"
#import "XFChargeSuccessViewController.h"

@interface XFPayViewController () <UITableViewDelegate,UITableViewDataSource,XFVipTableViewCellDelegate,XChargeTableViewCellDelegate>

@property (nonatomic,weak) UIView *topView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,weak) UIButton *chargeButton;

@property (nonatomic,weak) UIButton *vipButton;

@property (nonatomic,copy) NSArray *titleButtons;

@property (nonatomic,strong) UITableView *vipView;
@property (nonatomic,strong) UITableView *chargView;


@end

@implementation XFPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTopView];
    [self setupScrolLView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)clickBackButton {
    
    [super clickBackButton];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)clickTopButton:(UIButton *)sender {
    
    CGFloat centerOffset = 0;
    
    if (sender == self.vipButton) {
        
        centerOffset = -45;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (sender == self.chargeButton) {
        
        centerOffset = 45;
        self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);

    }
    
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_offset(centerOffset);
        make.height.mas_equalTo(2);
    }];
    
    for (UIButton *button in self.titleButtons) {
        
        if (sender == button) {
            
            button.selected = YES;
            
        } else {
            
            button.selected = NO;
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    if (scrollView != self.scrollView) {
        
        return;
    }
   
    if (scrollView.contentOffset.x != 0) {
        
        self.chargeButton.selected = YES;
        self.vipButton.selected = NO;


    } else {
        
        self.chargeButton.selected = NO;
        self.vipButton.selected = YES;
    }
    
    CGFloat centerOffset = 0;
    
    if (self.vipButton.selected) {
        
        centerOffset = -45;
    }
    if (self.chargeButton.selected) {
        
        centerOffset = 45;
        
    }
    
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_offset(centerOffset);
        make.height.mas_equalTo(2);
    }];
    
}

#pragma mark - cellDelegate
- (void)vipTableViewCell:(XFVipTableViewCell *)cell didClickPayButton:(UIButton *)payButton {
    
    XFChargeSuccessViewController *successVC = [[XFChargeSuccessViewController alloc] init];
    
    successVC.type = XFSuccessViewTypeVipSuccess;
    
    [self.navigationController pushViewController:successVC animated:YES];
}

- (void)chargeTableViewCell:(XFChargeTableViewCell *)cell didClickPayButton:(UIButton *)payButton {
    
    XFChargeSuccessViewController *successVC = [[XFChargeSuccessViewController alloc] init];
    
    successVC.type = XFSuccessViewTypeChargeFailed;
    
    [self.navigationController pushViewController:successVC animated:YES];
    
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView == _vipView) {
        
        XFVipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFVipTableViewCell"];
        
        if (!cell)  {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XFVipTableViewCell" owner:nil options:nil] lastObject];
        }
        
        cell.delegate = self;
        
        return cell;

    } else {
        
        XFChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFChargeTableViewCell"];
        
        if (!cell)  {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XFChargeTableViewCell" owner:nil options:nil] lastObject];
        }
        
        cell.delegate = self;
        
        return cell;
    }
    

}

- (void)setupScrolLView {
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.vipView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    
    self.vipView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.vipView];
    
    self.chargView = [[UITableView alloc] initWithFrame:(CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64))];
    
    self.chargView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.chargView];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    self.scrollView.pagingEnabled = YES;
    
    self.chargView.delegate = self;
    self.chargView.dataSource = self;
    self.vipView.delegate = self;
    self.vipView.dataSource = self;
    
    self.vipView.estimatedRowHeight = kScreenHeight;
    self.vipView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.vipView.showsVerticalScrollIndicator = NO;
    self.chargView.estimatedRowHeight = kScreenHeight;
    self.chargView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chargView.showsVerticalScrollIndicator = NO;

}

- (void)setupTopView {
    
    UIView *titleView = [[UIView alloc] init];
    
    titleView.frame = CGRectMake(0, 0, 180, 44);
    
    self.navigationItem.titleView = titleView;

    
    UIButton *whButton = [[UIButton alloc] init];
    
    [whButton setTitle:@"会员" forState:(UIControlStateNormal)];
    
    [whButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [whButton setTitleColor:kMainColor forState:(UIControlStateSelected)];
    whButton.titleLabel.font = [UIFont systemFontOfSize:16];
    whButton.tag = 1001;
    [titleView addSubview:whButton];
    whButton.selected = YES;
    
    UIButton *yyButton = [[UIButton alloc] init];
    
    [yyButton setTitle:@"充值" forState:(UIControlStateNormal)];
    
    [yyButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [yyButton setTitleColor:kMainColor forState:(UIControlStateSelected)];
    yyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    yyButton.tag = 1002;
    [titleView addSubview:yyButton];
    
    
    self.slideView = [[UIView alloc] init];
    self.slideView.backgroundColor = kMainColor;
    
    self.vipButton = whButton;
    self.chargeButton = yyButton;
    
    self.topView = titleView;
    
    [self.topView addSubview:self.slideView];
    self.titleButtons = @[self.chargeButton,self.vipButton];
    
    [self.chargeButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.vipButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];

}

- (void)updateViewConstraints {
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.mas_offset(0);

    }];
    
    [self.vipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(90);
        
    }];
    
    [self.chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.vipButton.mas_right);
        make.top.bottom.right.mas_offset(0);
        make.width.mas_equalTo(90);
    }];
    
    [@[self.chargeButton,self.vipButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(44);
        
    }];
    
    
    CGFloat centerOffset = 0;
    
    if (self.vipButton.selected) {
        
        centerOffset = -45;
    }
    if (self.chargeButton.selected) {
        
        centerOffset = 45;
    }
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_offset(centerOffset);
        make.height.mas_equalTo(2);
    }];
    
    [super updateViewConstraints];
}
@end
