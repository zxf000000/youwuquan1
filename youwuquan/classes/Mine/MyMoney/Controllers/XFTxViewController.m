//
//  XFTxViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFTxViewController.h"

@implementation XFtxCellNode

- (instancetype)init {
    
    if (self = [super init]) {
        _titleNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:@"提现"];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:14],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _titleNode.attributedText = str;
        
        _titleNode.maximumNumberOfLines = 1;
        [self addSubnode:_titleNode];
        
        _timeNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *timestr = [[NSMutableAttributedString  alloc] initWithString:@"2019-09-09 14:30"];
        
        timestr.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:11],
                           NSForegroundColorAttributeName:UIColorHex(808080)
                           };
        
        _timeNode.attributedText = timestr;
        
        _timeNode.maximumNumberOfLines = 1;
        [self addSubnode:_timeNode];
        
        
        _moneyNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *money = [[NSMutableAttributedString  alloc] initWithString:@"-3333元"];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:14],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _moneyNode.attributedText = money;
        
        _moneyNode.maximumNumberOfLines = 1;
        [self addSubnode:_moneyNode];
    
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *layout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_titleNode,_timeNode]];
    
    ASStackLayoutSpec *alllayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) children:@[layout,_moneyNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 10, 10)) child:alllayout];
    
}

@end

@interface XFTxViewController () <ASTableDelegate,ASTableDataSource>

@property (nonatomic,strong) ASTableNode *tableNode;

@end

@implementation XFTxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易记录";
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    
    [self.view addSubnode:self.tableNode];
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;

}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {

    return ^ASCellNode *() {
        
        XFtxCellNode *node = [[XFtxCellNode alloc] init];
        
        
        return node;
    };
    
}

@end
