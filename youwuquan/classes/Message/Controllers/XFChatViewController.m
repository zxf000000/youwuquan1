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
#import "XFGiftViewController.h"
#import "XFMineNetworkManager.h"
#import "XFFindDetailViewController.h"

@interface XFChatViewController () <XFGiftVCDelegate>

@property (nonatomic,copy) NSString *headerIconUrl;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,strong) UIImageView *iconView;


@end

@implementation XFChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *backButton = [UIButton naviBackButton];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 注册送钻石Cell
    [self registerClass:XFDiamondCollectionViewCell.class forMessageClass:XFDiamondMessageContent.class];
    
    
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:[UIImage imageNamed:@"msg_pic"] title:@"照片"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:1 image:[UIImage imageNamed:@"msg_shot"] title:@"拍摄"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:2 image:[UIImage imageNamed:@"msg_location"] title:@"位置"];
    
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"msg_sendgift"] title:@"送礼物" tag:9004];

    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"msg_dateher"] title:@"约她" tag:9005];
    
    [self.conversationMessageCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];

    [self loadInnfo];

}

- (void)loadInnfo {
    
    [XFMineNetworkManager getOtherInfoWithUid:self.targetId successBlock:^(id responseObj) {
        
        NSDictionary *info = ((NSDictionary *)responseObj)[@"bar"];
        
        self.nickName = info[@"nickname"];
        self.headerIconUrl = info[@"headIconUrl"];
        
        [self.iconView setImageWithURL:[NSURL URLWithString:self.headerIconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    } failedBlock:^(NSError *error) {
        
    } progressBlock:^(CGFloat progress) {
        
    }];
    
    
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    
    if (tag == 9004) {
        
        XFGiftViewController *giftVC = [[XFGiftViewController alloc] init];
        giftVC.userName = self.nickName;
        giftVC.uid = self.targetId;
        giftVC.iconUrl = self.headerIconUrl;
        giftVC.delegate = self;

        [self presentViewController:giftVC animated:YES completion:nil];
        [[IQKeyboardManager sharedManager] setEnable:YES];


    }
    
    if (tag == 9005) {
        
        [XFToolManager showProgressInWindowWithString:@"功能尚在开发"];
        
    }
    
}

- (void)xfGiftVC:(XFGiftViewController *)giftVC didSuccessSendGift:(NSDictionary *)info {
    
        XFDiamondMessageContent *msg = [XFDiamondMessageContent messageWithContent:@"我送你了一打礼物"];
    
        [self sendMessage:msg pushContent:@"有送钻石消息"];
    
        [[IQKeyboardManager sharedManager] setEnable:NO];

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        header.backgroundColor = collectionView.backgroundColor;
        
        CGFloat height = 230 * kScreenWidth / 375.f - 20;
        CGFloat width = kScreenWidth - 30;
        // cardView
        UIView *shadowView = [[UIView alloc] init];
        UIView *cardView = [[UIView alloc] init];
        
        shadowView.frame = CGRectMake(15, 10, width, height);
        [shadowView setMyShadow];
        
        cardView.frame = shadowView.bounds;
        
        [header addSubview:shadowView];
        [shadowView addSubview:cardView];
        
        cardView.backgroundColor =[UIColor whiteColor];
        cardView.layer.cornerRadius = 10;
        
        UIView *iconBg = [[UIView alloc] init];
        iconBg.backgroundColor = UIColorHex(808080);
        iconBg.frame = CGRectMake( (width - 70)/2, (height - 70)/2 - 20, 70, 70);
        [cardView addSubview:iconBg];
        iconBg.layer.cornerRadius = 35;
        iconBg.layer.masksToBounds = YES;

        UIImageView *iconCircle = [[UIImageView alloc] init];
        iconCircle.image = [UIImage imageNamed:@"chat_iconbg"];
        iconCircle.frame = iconBg.bounds;
        [iconBg addSubview:iconCircle];
        // 头像
        self.iconView = [[UIImageView alloc] init];
        self.iconView.frame = CGRectMake(10, 10 , 50, 50);
        [iconBg addSubview:self.iconView];
        self.iconView.layer.cornerRadius = 25;
        self.iconView.layer.masksToBounds = YES;
        
        UIButton *lookButton = [[UIButton alloc] init];
        [lookButton setBackgroundImage:[UIImage imageNamed:@"chat_look"] forState:(UIControlStateNormal)];
        [cardView addSubview:lookButton];
        lookButton.frame = CGRectMake(width - 100 * kScreenWidth/375.f, 140 * kScreenWidth/375.f, 100 * kScreenWidth/375.f, 50 * kScreenWidth/375.f);
        
        [lookButton addTarget:self action:@selector(clickLookButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        UILabel *detail = [[UILabel alloc] init];
        detail.text = @"小提示:";
        detail.font = [UIFont systemFontOfSize:12];
        detail.textColor = UIColorHex(e0e0e0);
        [cardView addSubview:detail];
        
        detail.frame = CGRectMake(10, iconBg.bottom + 5, 100, 15);
        
        UILabel *subDetail = [[UILabel alloc] init];
        subDetail.text = @"查看ta主页,试着查看ta最新动态吧";
        subDetail.font = [UIFont systemFontOfSize:13];
        subDetail.textColor = [UIColor blackColor];
        [cardView addSubview:subDetail];
        subDetail.left = detail.left + 10;
        subDetail.top = detail.bottom + 10;
        subDetail.width = width/2;
        subDetail.height = 42;
        subDetail.numberOfLines = 0;
        
        return header;
    }
    return nil;
}

- (void)clickLookButton {
    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];

    detailVC.userId = self.targetId;
    detailVC.userName = self.nickName;
    detailVC.iconUrl = self.headerIconUrl;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeMake(kScreenWidth, 230 * kScreenWidth / 375.f);

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
