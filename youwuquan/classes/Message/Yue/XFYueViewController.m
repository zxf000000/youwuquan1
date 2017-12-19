//
//  XFYueViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFYueViewController.h"
#import "XFYueTableViewCell.h"
#import "XFAcceptTableViewCell.h"
#import "XFAvtivityMsgTableViewCell.h"
#import "XFCommentMessageTableViewCell.h"

@interface XFYueViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XFYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];

}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    self.tableView.separatorStyle = self.hasSeprator?UITableViewCellSeparatorStyleSingleLineEtched: UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorHex(f4f4f4);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.msgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger type = [self.msgs[indexPath.row] integerValue];
    
    switch (type) {
        case 0:
        {
            XFYueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFYueTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFYueTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            cell.clickDenyButtonBlock = ^{
                
                
            };
            
            cell.clickAcceptButtonBlock = ^{
                
                [self.msgs addObject:@(1)];
                
                [self.tableView insertRow:self.msgs.count-1 inSection:0 withRowAnimation:(UITableViewRowAnimationFade)];
                
                [self.tableView scrollToRow:self.msgs.count-1 inSection:0 atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
            };
            
            return cell;
        }
            break;
        case 1:
        {
            XFAcceptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFAcceptTableViewCell"];

            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFAcceptTableViewCell" owner:nil options:nil] lastObject];
            }
            
            return cell;
        }
            break;
            
        case 2:
        {
            XFAvtivityMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFAvtivityMsgTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFAvtivityMsgTableViewCell" owner:nil options:nil] lastObject];
            }
            
            return cell;
        }
            break;
            
        case 3:
        {
            // XFCommentMessageTableViewCell
            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
            }

            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
        
            cell.statusPic.hidden = NO;
            
            cell.hasPicConstain.active = NO;
            cell.hasNoPicContrains.active = YES;
            cell.likeButton.hidden = YES;
            cell.commentBottomContrains.active = YES;
            cell.likeBottomContrains.active = NO;
            return cell;
        }
        case 4:
        {
            // XFCommentMessageTableViewCell
            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
            }
            
            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
            
            cell.statusPic.hidden = YES;
            
            cell.hasPicConstain.active = YES;
            cell.hasNoPicContrains.active = NO;
            
            [cell layoutIfNeeded];
            cell.likeButton.hidden = YES;
            cell.commentBottomContrains.active = YES;
            cell.likeBottomContrains.active = NO;
            return cell;
        }
            
        case 5:
        {
            // XFCommentMessageTableViewCell
            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
            }
            
            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
            
            cell.statusPic.hidden = NO;
            
            cell.hasPicConstain.active = NO;
            cell.hasNoPicContrains.active = YES;
            
            cell.likeButton.hidden = NO;
            cell.commentBottomContrains.active = NO;
            cell.likeBottomContrains.active = YES;
            return cell;
        }
        case 6:
        {
            // XFCommentMessageTableViewCell
            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
            }
            
            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
            
            cell.statusPic.hidden = YES;
            
            cell.hasPicConstain.active = YES;
            cell.hasNoPicContrains.active = NO;
            
            cell.likeButton.hidden = NO;
            cell.commentBottomContrains.active = NO;
            cell.likeBottomContrains.active = YES;
            return cell;
        }
    }

    return nil;
}

@end
