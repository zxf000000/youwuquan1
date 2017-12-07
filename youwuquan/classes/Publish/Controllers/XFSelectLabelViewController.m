//
//  XFSelectLabelViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/23.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFSelectLabelViewController.h"
#import "XFSearchViewController.h"
#import "XFHistoryCollectionViewCell.h"
#import "XFLabelCollectionViewCell.h"
#import "XFHistoryViewRowsCaculator.h"
#import "XFMutableTagsView.h"

#import <YYCache.h>

#import "XFStatusNetworkManager.h"


@interface XFSelectLabelViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UICollectionViewDelegateFlowLayout,ASTableDelegate,ASTableDataSource,XFHomeNodedelegate,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionView *historyView;

@property (nonatomic,copy) NSArray *titleArr;

@property (nonatomic,strong) UILabel *desLabel;


@property (nonatomic,copy) NSArray *hotDatas;

@property (nonatomic,strong) NSMutableArray *historyArr;

@property (nonatomic,strong) UIGestureRecognizer *tapWindow;

// 标签栏
@property (nonatomic,strong) XFMutableTagsView *labelsView;

@property (nonatomic,strong) UIButton *creatLabelButton;

@property (nonatomic,assign) CGFloat topHeight;

@property (nonatomic,strong) UITextField *inputTagView;

@property (nonatomic,strong) YYCache *historyCache;

@property (nonatomic,strong) UIButton *doneButton;


@end


@implementation XFSelectLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"选择标签";
    
    UIButton *backButton = [UIButton naviBackButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    _doneButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 60, 30))];
    _doneButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [_doneButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [_doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    if (self.labelsArr.count > 0) {
        [_doneButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];

        self.doneButton.enabled = YES;
    } else {
        [_doneButton setTitleColor:UIColorHex(808080) forState:(UIControlStateNormal)];

        self.doneButton.enabled = NO;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
    
    // 历史记录
    [self setuphistoryView];
    
    [self setupLabelsView];
    
    [self getHistoryData];
    
    [self getTags];
    
    [self addObserver:self forKeyPath:@"labelsArr" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [self.view setNeedsUpdateConstraints];

}

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"labelsArr"];
}

- (void)getTags {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:nil];
    // 获取标签
    [XFStatusNetworkManager getAllTagsWithsuccessBlock:^(NSDictionary *reponseDic) {
        
        [HUD hideAnimated:YES];
        
        if (reponseDic) {
            
            NSArray *datas = reponseDic[@"data"][0];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                
                [arr addObject:datas[i][@"labelName"]];
                
            }
            
            self.titleArr = arr.copy;
            
            [self.historyView reloadData];
            
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failedBlock:^(NSError *error) {
        [HUD hideAnimated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
}

- (void)getHistoryData {
    
    if ([self.historyCache containsObjectForKey:kTagsHistoryKey]) {
        
        NSArray *historyDatas = (NSArray *)[self.historyCache objectForKey:kTagsHistoryKey];
        
        [self.historyArr addObjectsFromArray:historyDatas];
        
        [self.historyView reloadData];
    }
    
}

- (void)clickBackButton {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickDoneButton {
    
    if ([self.delegate respondsToSelector:@selector(selecteTagVC:didSelectedTagsWith:)]) {
        
        [self.delegate selecteTagVC:self didSelectedTagsWith:self.labelsArr.copy];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}
// 删除历史记录
- (void)deleteHistory {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除全部历史记录?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.historyArr = [NSMutableArray array];
        [self.historyCache removeObjectForKey:kTagsHistoryKey];
        [self.historyView.collectionViewLayout invalidateLayout];
        
        [self.historyView reloadData];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:actionDone];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 45);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        
        if (indexPath.section == 0) {
            
            if (self.historyArr.count > 0) {
                
                XFSearchDeleteHeader *delete = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"deleteheader" forIndexPath:indexPath];
                
                delete.titleLabel.text = @"历史标签";
                
                delete.clickDeleteButtonBlock = ^{
                    
                    [self deleteHistory];
                    
                    
                };
                
                return delete;
                
            } else {
                
                XFSearchHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
                
                header.titleLabel.text = @"热门标签";
                
                return header;
                
            }
            
        } else {
            XFSearchHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            
            header.titleLabel.text = @"热门标签";

            return header;

        }
    }
    return nil;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.historyArr.count > 0) {
        
        return 2;
        
    } else {
        
        return 1;
    }
    return 2;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        
    if (_historyArr.count > 0) {
        
        if (section == 0) {
            
            return self.historyArr.count;
            
        } else {
            
            return self.titleArr.count;
        }
        
    }
    
    return self.titleArr.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        XFHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"history" forIndexPath:indexPath];
        
        if (_historyArr.count > 0) {
            
            switch (indexPath.section) {
                    
                case 0:
                {
                    cell.titleLabel.text = self.historyArr[indexPath.item];
                }
                    break;
                case 1:
                {
                    cell.titleLabel.text = self.titleArr[indexPath.item];
                    
                }
                    break;
            }
        } else {
            
            cell.titleLabel.text = self.titleArr[indexPath.item];
            
        }
        
        return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *text;
    
    if (_historyArr.count > 0) {
        
        switch (indexPath.section) {
                
            case 0:
            {
                text = self.historyArr[indexPath.item];
            }
                break;
            case 1:
            {
                text = self.titleArr[indexPath.item];
                
            }
                break;
        }
    } else {
        
        text = self.titleArr[indexPath.item];
        
    }
    
    // 添加标签

    [self addTagWithText:text];

    
}
#pragma mark - 添加标签
- (void)addTagWithText:(NSString *)text {
    
    if ([self.labelsArr containsObject:text]) {
        
        [XFToolManager showProgressInWindowWithString:@"请勿重复添加"];
        
        return;
    }
    
    [self.labelsView addTagViewWith:text];
    
//    [self.labelsArr addObject:text];
    
    // 更新缓存
    [self.historyCache setObject:self.labelsArr forKey:kTagsHistoryKey];
    
    NSLog(@"%@0------",[self.historyCache objectForKey:kTagsHistoryKey]);
    
    [self.historyView reloadData];
    
    [self.labelsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.top.mas_offset(0);
        make.height.mas_equalTo(self.labelsView.tagsViewHeight);
        make.width.mas_equalTo(kScreenWidth);
    }];
}


#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}


// 监听变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"labelsArr"]) {
        
        // 标签变化
        if (self.labelsArr.count > 0) {
            
            [_doneButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
            
            self.doneButton.enabled = YES;
        } else {
            [_doneButton setTitleColor:UIColorHex(808080) forState:(UIControlStateNormal)];
            
            self.doneButton.enabled = NO;
            
        }
        
        
    } else {
        
        
        NSString *text = [change objectForKey:NSKeyValueChangeNewKey];
        CGFloat height;
        
        if (text.length > 0 && text != nil) {
            
            height = 25;
            [self.creatLabelButton setTitle:[NSString stringWithFormat:@"点击生成标签:%@",self.inputTagView.text] forState:(UIControlStateNormal)];
        } else {
            
            height = 0;
            
        }
        
        [self.creatLabelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.inputTagView.mas_bottom);
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(height);
        }];
        
    }
    

    
}
/**
 点击按钮添加自定标签
 */
- (void)clickCreatButton {
    
    // 添加标签
    [self addTagWithText:self.inputTagView.text];
    
    self.inputTagView.text = @"";
}


- (void)setupLabelsView {
    
    self.labelsView = [[XFMutableTagsView alloc] init];
    self.labelsView.tagArr = self.labelsArr;
    self.labelsView.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    
    self.labelsView.reloadTagViewBlock = ^{
        
        weakSelf.labelsArr = weakSelf.labelsView.tagArr;
        
        [weakSelf.labelsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_offset(0);
            make.top.mas_offset(0);
            make.height.mas_equalTo(weakSelf.labelsView.tagsViewHeight == 0 ? 40:weakSelf.labelsView.tagsViewHeight);
            make.width.mas_equalTo(kScreenWidth);
            
        }];
    };

    [self.view addSubview:self.labelsView];
    
    self.inputTagView = [[UITextField alloc] init];
    self.inputTagView.backgroundColor = UIColorHex(f4f4f4);
    [self.view addSubview:self.inputTagView];
    self.inputTagView.clearButtonMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 10, 10))];
    self.inputTagView.leftView = leftView;
    self.inputTagView.leftViewMode = UITextFieldViewModeAlways;
    self.inputTagView.delegate = self;
    self.inputTagView.font = [UIFont systemFontOfSize:12];
    self.inputTagView.returnKeyType = UIReturnKeyDone;
    self.inputTagView.placeholder = @"输入自定义标签";
    // 监听变化
    [self.inputTagView addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
    
    self.creatLabelButton = [[UIButton alloc] init];
    [self.creatLabelButton  setTitle:@"点击生成标签:" forState:(UIControlStateNormal)];
    [self.creatLabelButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.creatLabelButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.creatLabelButton.backgroundColor = kMainRedColor;
    
    [self.view addSubview:self.creatLabelButton];
    
    [self.creatLabelButton addTarget:self action:@selector(clickCreatButton) forControlEvents:(UIControlEventTouchUpInside)];

}

- (void)setuphistoryView {
    
    
    //    UICollectionViewFlowLayout
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 0;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 0;
    // 3.设置item块的大小 (可以用于自适应)
    //    layout.estimatedItemSize = CGSizeMake(20, 60);
    layout.itemSize = CGSizeMake((kScreenWidth - 20)/3, 45.5);
    // 设置滑动的方向 (默认是竖着滑动的)
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    // 设置item的内边距
    layout.sectionInset = UIEdgeInsetsMake(0,10,10,10);
    
    self.historyView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 50) collectionViewLayout:layout];
    self.historyView.backgroundColor = [UIColor whiteColor];
    self.historyView.delegate = self;
    self.historyView.dataSource = self;
    
    [self.historyView registerNib:[UINib nibWithNibName:@"XFHistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"history"];
    [self.historyView registerClass:[XFSearchHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.historyView registerClass:[XFSearchDeleteHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"deleteheader"];
    
    _historyView.frame = CGRectMake(0, 0, kScreenWidth , kScreenHeight-64);
    
    _historyView.allowsSelection = YES;
    
    [self.view addSubview:self.historyView];
    
    if (@available (ios 11, * )) {
        
        _historyView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    
}


- (void)updateViewConstraints {

    
    [self.labelsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.top.mas_offset(0);
        make.height.mas_equalTo(self.labelsView.tagsViewHeight == 0? 40:self.labelsView.tagsViewHeight);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    [self.inputTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelsView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(25);
    }];
    
    [self.creatLabelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.inputTagView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(0);
    }];
    
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.creatLabelButton.mas_bottom);
        make.left.right.bottom.mas_offset(0);
        
    }];
    
    [super updateViewConstraints];
}

- (NSArray *)titleArr {
    
    if (_titleArr == nil) {
        
        _titleArr = @[@"写真秀",@"小萝莉",@"小清新",@"火辣",@"摩登",@"有人",@"历史",@"女仆装",@"美腿",@"酥胸",@"运动",@"制服诱惑",@"魅族"];
    }
    return _titleArr;
}

- (NSMutableArray *)historyArr {
    
    if (_historyArr == nil) {
        
        _historyArr = [NSMutableArray array];
    }
    return _historyArr;
}

- (YYCache *)historyCache {
    
    if (_historyCache == nil) {
        _historyCache = [YYCache cacheWithName:kTagsHistoryKey];
    }
    return _historyCache;
}


@end
