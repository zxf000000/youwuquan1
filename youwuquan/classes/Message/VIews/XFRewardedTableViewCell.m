//
//  XFRewardedTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFRewardedTableViewCell.h"

@implementation XFMessageRewardedCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu44"]];
        _iconView.layer.cornerRadius = 30;
        _iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorHex(868383);
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.text = @"小王八蛋";
        [self.contentView addSubview:_nameLabel];
        
        [self setNeedsUpdateConstraints];
        
    }
    return self;
}

- (void)updateConstraints {
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_offset(10);
        make.height.width.mas_equalTo(60);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(_iconView.mas_bottom).offset(10);
        
    }];
    
    [super updateConstraints];
}

@end


@implementation XFRewardedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(81, 106);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XFMessageRewardedCollectionCell class] forCellWithReuseIdentifier:@"XFMessageRewardedCollectionCell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMessageRewardedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFMessageRewardedCollectionCell" forIndexPath:indexPath];
    
    return cell;
    
}
@end
