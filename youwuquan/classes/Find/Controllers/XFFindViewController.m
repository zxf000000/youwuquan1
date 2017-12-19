//
//  XFFindViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindViewController.h"

#import "XFFindModel.h"
#import "XFFindLayout.h"
#import "XFFindTableViewCell.h"
#import "YYTableView.h"

#import "XFFindTopTableViewCell.h"
#import "XFFindNewTableViewCell.h"
#import "XFFindCellLayout.h"

//#import "YYPhotoGroupView.h"
//#import "YYFPSLabel.h"

@interface XFFindViewController ()<UITableViewDelegate, UITableViewDataSource, WBStatusCellDelegate,XFFindCelldelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *layouts;

@property (nonatomic,copy) NSArray *models;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) NSIndexPath *openIndexPath;

@end

@implementation XFFindViewController

- (instancetype)init {
    self = [super init];
    _tableView = [YYTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _layouts = [NSMutableArray new];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

    if (@available (ios 11 , * )) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        for (XFFindModel *status in self.models) {
            XFFindLayout *layout = [[XFFindLayout alloc] initWithStatus:status];
            [_layouts addObject:layout];
        }
    
        // 复制一下，让列表长一些，不至于滑两下就到底了
        [_layouts addObjectsFromArray:_layouts];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            self.navigationController.view.userInteractionEnabled = YES;
            [_tableView reloadData];
        });
    });
    
    self.cellHeight = [XFfindCellLayout caculateHeightForCell];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            {
                return 2;
            }
            break;
        case 1:
        {
            return self.models.count;
            
        }
            
        default:
            break;
    }
    
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            XFFindTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFFindTopTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFFindTopTableViewCell" owner:nil options:nil] lastObject];
                
            }
            return cell;
        }
            break;
        case 1:
        {
            
            XFFindNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"findNew"];
            
            if (cell == nil) {
                
                cell = [[XFFindNewTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"findNew" height:_cellHeight];
            }
            
            cell.delegate = self;
            
            cell.indexPath = indexPath;
            
            if (self.openIndexPath == indexPath) {
                
                cell.height = [XFfindCellLayout caculateHeightForCellWithText:@"这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容"];
                cell.isOpen = YES;
            } else {
                
                cell.height = _cellHeight;
                cell.isOpen = NO;
            }

            return cell;
            
        }
            
        default:
            break;
    }
    return nil;
}

- (void)clickedCellForIndexPath:(NSIndexPath *)indexPath open:(BOOL)open {
    
    if (open) {
        self.openIndexPath = indexPath;
        
    } else {
        
        self.openIndexPath = nil;
    }
    self.tableView.hidden = YES;

    if (indexPath.row == 0) {

        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:(UITableViewRowAnimationFade)];

    } else {

        [self.tableView reloadSection:1 withRowAnimation:(UITableViewRowAnimationNone)];

    }
    self.tableView.hidden = NO;



}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            
            return (kScreenWidth - 20)*24/71.f;
        }
            break;
        case 1:
        {
            if (indexPath == self.openIndexPath) {
                
                return [XFfindCellLayout caculateHeightForCellWithText:@"这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容"];

                
            } else {
                
                return _cellHeight;

                
            }
        
        }
            
        default:
            break;
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSArray *)models {
    
    if (_models == nil) {
        
        NSMutableArray *array = [NSMutableArray array];
    
        for (NSInteger i = 0 ; i < 10 ; i++) {
            
            XFFindModel *model = [[XFFindModel alloc] init];
            
            model.name = @"名字";
            
            model.icon = [UIImage imageNamed:@"actor_pic2"];
            
            WBPicture *picture = [[WBPicture alloc] init];
            
            WBPictureMetadata *pic = [[WBPictureMetadata alloc] init];
            
            pic.url = [NSURL URLWithString:@"http://47.95.38.122:80/imghouse/pm/upload/image/2017/10/2/1WNLzwRw4ax5V7nnIRAUMnltoYWpGABb_$xxx$.jpg"];
            
            pic.height = 100;
            pic.width = 200;
            
            picture.bmiddle = pic;
            
            model.comment = @"约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约约不约";
            
            model.time = @"20小时以前";
            
            NSInteger count = i;
        
            NSMutableArray *pics = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i < count; i ++) {
                
                [pics addObject:picture];
                
            }
            
            model.images = pics;
            
            [array addObject:model];
            
        }
        _models = array.copy;
        
    }
    return _models;
}


@end
