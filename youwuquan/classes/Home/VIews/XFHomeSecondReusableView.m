//
//  XFHomeSecondReusableView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeSecondReusableView.h"
#import "XFHomeSecCollectionViewCell.h"

@implementation XFHomeSecondReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    self.moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat itemHeight = 180;
    CGFloat itemWidth = 100;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.collectionVIew.showsHorizontalScrollIndicator = NO;
    self.collectionVIew.collectionViewLayout = layout;
    
    self.collectionVIew.delegate = self;
    self.collectionVIew.dataSource = self;
    
    [self.collectionVIew registerNib:[UINib nibWithNibName:@"XFHomeSecCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFHomeSecCollectionViewCell"];
    
    self.collectionVIew.backgroundColor = UIColorFromHex(0xf4f4f4);
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFHomeSecCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFHomeSecCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
    
}

@end
