//
//  XFAvtivityMsgTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAvtivityMsgTableViewCell.h"

@implementation XFAvtivityMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentBg.image = [[UIImage imageNamed:@"chat_qipao1"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}
- (IBAction)clickdetailButton:(id)sender {
    
    
    
}

@end
