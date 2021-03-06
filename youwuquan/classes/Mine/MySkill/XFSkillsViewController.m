//
//  XFSkillsViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFSkillsViewController.h"
#import "XFSkillModel.h"
#import "XFSkillCollectionViewCell.h"
#import "XFEditSkillTableViewController.h"
#import "XFUserInfoNetWorkManager.h"

@interface XFSkillsViewController () <UICollectionViewDelegate,UICollectionViewDataSource,XFSkillCelldelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,copy) NSArray *skills;

@property (nonatomic,copy) NSArray *mySkills;

@property (nonatomic,copy) NSArray *skillNames;

@end

@implementation XFSkillsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的技能";
    [self setupCollectionView];
    
    [self getData];
}



- (void)getData {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    [XFUserInfoNetWorkManager getAllSkillsWithSuccessBlock:^(NSDictionary *responseDic) {
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (!responseDic) {
                
                [self.navigationController popViewControllerAnimated:YES];
                [HUD hideAnimated:YES];
                
            }
            
        });
        
        if (responseDic) {
            
            NSArray *datas = responseDic[@"data"][0];
            
            NSMutableArray *skills = [NSMutableArray array];
            for (NSInteger i = 0; i < datas.count; i ++ ) {
                
                [skills addObject:[XFSkillModel modelWithDictionary:datas[i]]];
                
            }
            self.skills = skills.copy;
            
            [XFUserInfoNetWorkManager getUserSkillsWithSuccessBlock:^(NSDictionary *responseDic) {
                [HUD hideAnimated:YES];

                if (responseDic) {
                    
                 // 刷新信息
                    NSArray *selectedS = responseDic[@"data"][0];
                    
                    NSMutableArray *selectedSkill = [NSMutableArray array];
                    NSMutableArray *selectedIds = [NSMutableArray array];
                    for (NSInteger i = 0; i < selectedS.count; i ++ ) {
                        
                        [selectedSkill addObject:[XFSkillModel modelWithDictionary:selectedS[i]]];
                        [selectedIds addObject:selectedS[i][@"skillNo"]];
                        
                    }
                    
                    self.skillNames = selectedIds.copy;
                    
                    self.mySkills = selectedSkill.copy;
                    
                    [self.collectionView reloadData];
                    
                } else {
                
                    [self.navigationController popViewControllerAnimated:YES];

                }
                
            } failedBlock:^(NSError *error) {
                
                [self.navigationController popViewControllerAnimated:YES];
                [HUD hideAnimated:YES];

            }];
            
        } else {
            [self.navigationController popViewControllerAnimated:YES];

            [HUD hideAnimated:YES];
        }
        
    } failedBlock:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];

        [HUD hideAnimated:YES];

    }];
    
    
    
}

- (void)skillCell:(XFSkillCollectionViewCell *)cell didClickEditButtonWithStatus:(BOOL)status skillId:(NSString *)skillId {
    
    if (status) {
        // 编辑
        XFEditSkillTableViewController *editSkillVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFEditSkillTableViewController"];
        
        editSkillVC.skill = cell.model;
        
        editSkillVC.refreshSkillsBlock = ^{
          
            [self getData];
            
        };
        
        [self.navigationController pushViewController:editSkillVC animated:YES];
        
    } else {
        
        // 点亮
        XFEditSkillTableViewController *editSkillVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFEditSkillTableViewController"];
        editSkillVC.skill = cell.model;

        editSkillVC.refreshSkillsBlock = ^{
            
            [self getData];
            
        };
        
        
        [self.navigationController pushViewController:editSkillVC animated:YES];
        
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.skills.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFSkillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFSkillCollectionViewCell" forIndexPath:indexPath];
    
    XFSkillModel *model = self.skills[indexPath.item];
    
    cell.model = model;
    
    cell.delegate = self;
    
    if ([self.skillNames containsObject:model.skillNo]) {
        
        cell.isOpen = YES;
        
    } else {
        
        cell.isOpen = NO;
    }
    
    return cell;
    
}


- (void)setupCollectionView {
    
    CGFloat leftPadding = 53/750.f * kScreenWidth;
    CGFloat middlePadding = 35/750.f * kScreenWidth;
    CGFloat itemWidth = (kScreenWidth - leftPadding * 2 - middlePadding)/2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(middlePadding, leftPadding, middlePadding, leftPadding);
    layout.minimumLineSpacing = middlePadding;
    layout.minimumInteritemSpacing = middlePadding;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth * 26/30.f);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XFSkillCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFSkillCollectionViewCell"];
    
}

- (NSArray *)skills {
    
    if (_skills == nil) {
        
        _skills = [NSArray array];
    }
    return _skills;
}

@end
