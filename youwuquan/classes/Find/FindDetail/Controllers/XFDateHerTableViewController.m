//
//  XFDateHerTableViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFDateHerTableViewController.h"

@interface XFDateHerTableViewController () 
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIButton *addressbutton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *aliPayButton;

@end

@implementation XFDateHerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)clickBeginTImeButton:(id)sender {
    
    if (self.clickTimeButtonBlock) {
        
        self.clickTimeButtonBlock();
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO];
    
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                    
                case 0:
                {
                    if (self.clickTimeButtonBlock) {
                        
                        self.clickTimeButtonBlock();
                        
                    }
                    

                }
                    break;
                case 1:
                {
                    
                }
                    break;
                    
            }
            
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                    
                case 0:
                {
                    self.wechatButton.selected = YES;
                    self.aliPayButton.selected = NO;

                }
                    break;
                case 1:
                {
                    self.aliPayButton.selected = YES;
                    self.wechatButton.selected = NO;


                }
                    break;
                    
            }
            
        }
            break;

    }
    
}

@end
