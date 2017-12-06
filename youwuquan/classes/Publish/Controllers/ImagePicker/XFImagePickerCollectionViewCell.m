//
//  XFImagePickerCollectionViewCell.m
//  chaofen
//
//  Created by mr.zhou on 2017/8/8.
//  Copyright © 2017年 a.hep. All rights reserved.
//

#import "XFImagePickerCollectionViewCell.h"

@implementation XFImagePickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.canSeleted = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countEnough:) name:@"imageCountEnough" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countOk:) name:@"imageCountOk" object:nil];

    
    
}

- (void)countOk:(NSNotification *)notification {

    self.canSeleted = YES;
    
}

- (void)countEnough:(NSNotification *)notification {

    NSArray *indexPaths = notification.object;
    
    if (![indexPaths containsObject:self.indexPath]) {
    
        self.canSeleted = NO;
    
    }
}


- (IBAction)clickSelectedButton:(id)sender {
    
    if (self.canSeleted == NO) {
        
        if (self.selectedButton.selected == NO) {
        
            // 弹出不能选择对话
            self.selectedEnoughBlock();
        
        } else {
        
            // 正常取消选择
            self.selectedButton.selected = !self.selectedButton.selected;
            
            self.selectedImageBlock(self.selectedButton.selected, self.indexPath);
        
        }
    
    
    } else {
    
        // 正常选择
        self.selectedButton.selected = !self.selectedButton.selected;
        
        self.selectedImageBlock(self.selectedButton.selected, self.indexPath);
        
        
    
    }
    

}

@end
