//
//  XFStatusDetailViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFStatusDetailViewController.h"
#import "XFStatusDetailCellNode.h"
#import "XFStatusCommentCellNode.h"
#import <IQKeyboardManager.h>

@implementation XFStatusCenterNode


- (instancetype)init {
    
    if (self = [super init]) {
        
        _titleNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:@"评论"];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _titleNode.attributedText = str;
        
        _titleNode.maximumNumberOfLines = 1;
        [self addSubnode:_titleNode];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    
    return self;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 10, 0)) child:_titleNode];
    
}

@end

@implementation XFStatusBottomNode

- (instancetype)init {
    
    if (self = [super init]) {
        
        _bgNode = [[ASDisplayNode alloc] init];
        _bgNode.backgroundColor = [UIColor whiteColor];
        _bgNode.shadowColor = UIColorHex(040000).CGColor;
        _bgNode.shadowOffset = CGSizeMake(0, 0);
        _bgNode.shadowOpacity = 0.1;
        _bgNode.cornerRadius = 4;
        [self addSubnode:_bgNode];
        
        _moreButton = [[ASButtonNode alloc] init];
        
        [_moreButton setTitle:@"点击查看更多评论" withFont:[UIFont systemFontOfSize:13] withColor:kMainRedColor forState:(UIControlStateNormal)];
        [self addSubnode:_moreButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [_moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
    }
    
    
    return self;
}
- (void)clickMoreButton {
    
    if (self.clickMoreButtonBlock) {
        
        self.clickMoreButtonBlock();
    }
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _moreButton.style.preferredSize = CGSizeMake(kScreenWidth, 45);

    ASBackgroundLayoutSpec *bgLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:[ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0, 0)) child:_moreButton] background:_bgNode];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:bgLayout];
    
}

@end



@interface XFStatusDetailViewController () <ASTableDelegate,ASTableDataSource,UITextFieldDelegate,XFStatusCommentDelegate>

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,assign) NSInteger count;


@property (nonatomic,strong) UITextField *inputTextField;

@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,strong) UIView *inputView;

@property (nonatomic,strong) UIView *shadowView;


@end

@implementation XFStatusDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    
    // 返回按钮
    UIButton *backButton = [UIButton naviBackButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.count = 12;
    
    self.isOpen = NO;
    
    [self setupTableNode];
//    [self setupCommentView];

    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:)
//                                                 name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisppear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return self.count;
    
    
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return ^ASCellNode *{
            
            XFStatusDetailCellNode *node = [[XFStatusDetailCellNode alloc] initWithImages:@[@"find_pic4",@"find_pic8",@"find_pic10",@"find_pic12"] likeImgs:@[@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2",@"find_icon2"]];
            
            if (self.type == Mine) {
                
                node.followButton.hidden = YES;
            }
            
            return node;
            
        };
        
    } else if (indexPath.row == 1) {
        
        
        return ^ASCellNode *{
            
            XFStatusCenterNode *node = [[XFStatusCenterNode alloc] init];
            
            return node;
            
        };
        
    } else if (indexPath.row == self.count - 1) {
        
        if (!self.isOpen) {
            
            return ^ASCellNode *{
                
                XFStatusBottomNode *node = [[XFStatusBottomNode alloc] init];
                
                // 加载更多评论
                node.clickMoreButtonBlock = ^{
                    
                    self.count = 20;
                    self.isOpen = YES;
                    [self.tableNode reloadData];
                    
                    
                };
                
                return node;
                
                
            };
            
        } else {
            
            return ^ASCellNode *{
                
                XFStatusCommentCellNode *node = [[XFStatusCommentCellNode alloc] init];
                
                node.delegate = self;
                
                return node;
                
            };
        }
        
    } else {
        
        return ^ASCellNode *{
            
            XFStatusCommentCellNode *node = [[XFStatusCommentCellNode alloc] init];
            
            node.delegate = self;

            
            return node;
            
        };
        
    }
    
}

#pragma mark - statusCommentDelegate
- (void)statusCommentNode:(XFStatusCommentCellNode *)commentNode didClickComplyTextWithIndex:(NSIndexPath *)indexPath {
    
    // 回复评论内容
    NSLog(@"开始回复");
    
}

//- (void)setupCommentView {
//    
//    self.inputView = [[UIView alloc] initWithFrame:(CGRectMake(0, kScreenHeight - 44 - 64, kScreenWidth, 44))];
//    
//    [self.view addSubview:self.inputView];
//    self.inputView.backgroundColor = [UIColor redColor];
//    
//    self.inputTextField = [[UITextField alloc] init];
//    
//    self.inputTextField.frame = CGRectMake(0, 0, kScreenWidth * 58/75.f, 44);
//    
//    self.inputTextField.backgroundColor = [UIColor whiteColor];
//    self.inputTextField.placeholder = @"客官,来了就留下点什么吧...";
//    self.inputTextField.borderStyle = UITextBorderStyleNone;
//    self.inputTextField.font = [UIFont systemFontOfSize:12];
//    UIView *leftView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 13, 10))];
//    self.inputTextField.leftView = leftView;
//    self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
//    [self.inputView addSubview:self.inputTextField];
//    
//    self.sendButton = [[UIButton alloc] init];
//    self.sendButton.frame = CGRectMake(kScreenWidth * 58/75.f, 0, kScreenWidth * 17/75.f, 44);
//    self.sendButton.backgroundColor = kMainRedColor;
//    [self.sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
//    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    [self.inputView addSubview:self.sendButton];
//    
//    self.inputTextField.delegate = self;
//    
//    self.shadowView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
//    
//    self.shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    [self.view insertSubview:self.shadowView belowSubview:self.inputView];
//    self.shadowView.alpha = 0;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadowView)];
//    [self.shadowView addGestureRecognizer:tap];
//    
//}


- (void)setupTableNode {
    
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44);
    [self.view addSubnode:self.tableNode];
    
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
}
// 设置IQkeyboard不滑动导航栏
-(void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}



@end
