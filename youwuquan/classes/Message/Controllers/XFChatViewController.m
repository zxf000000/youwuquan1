//
//  XFChatViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFChatViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "XFDiamondCollectionViewCell.h"
#import "XFDiamondMessageContent.h"

@interface XFChatViewController ()

@end

@implementation XFChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *backButton = [UIButton naviBackButton];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 注册送钻石Cell
    [self registerClass:XFDiamondCollectionViewCell.class forMessageClass:XFDiamondMessageContent.class];
    
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:nil title:@"钻石" tag:9007];

}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    
    if (tag == 9007) {
        
        XFDiamondMessageContent *msg = [XFDiamondMessageContent messageWithContent:@"我送你了一打钻石"];
        
        [self sendMessage:msg pushContent:@"有送钻石消息"];
    }
    
}


-(RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
    NSString * cellIndentifier=@"SimpleMessageCell";
    RCMessageBaseCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    [cell setDataModel:model];

    if ([model.objectName isEqualToString:@"diamondMessage"]) {
        
        XFDiamondMessageContent *msgContent = (XFDiamondMessageContent *)model.content;
        
        XFDiamondCollectionViewCell *myCell = (XFDiamondCollectionViewCell *)cell;
        
        myCell.textLabel.text = @"你收到了钻石";
    }
    
    return cell;
}
-(CGSize)rcConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //返回自定义cell的实际高度
    return CGSizeMake(300, 60);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
