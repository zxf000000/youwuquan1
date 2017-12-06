//
//  XFHomeTopHeaderReusableView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeTopHeaderReusableView.h"
#import "XFHomeHeaderCollectionViewCell.h"

@implementation XFHomeTopHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.centerPiciew.layer.masksToBounds = YES;
    
    self.moreButton.layer.cornerRadius = 7.5;
    self.moreButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.moreButton.layer.shadowOpacity = 0.6;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(17, 5, 15, 5);
    layout.minimumLineSpacing = 10;
    CGFloat itemHeight = 210 - 17 - 15;
    CGFloat itemWidth = 130;
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionVIew.showsHorizontalScrollIndicator = NO;
    
    self.collectionVIew.collectionViewLayout = layout;
    
    self.collectionVIew.delegate = self;
    self.collectionVIew.dataSource = self;
    
    [self.collectionVIew registerNib:[UINib nibWithNibName:@"XFHomeHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFHomeHeaderCollectionViewCell"];

    
    
}

- (void)setType:(HomeHeaderType)type {
    
    _type = type;
    if (_type == Home) {
        
        self.centerPiciew.hidden = NO;
        self.centerbutton.hidden = NO;
        self.centerShadow.hidden = NO;
        self.bottomLine.hidden = NO;
        self.title2.hidden = NO;
        self.bottomLineTop.constant = 386.5;
        
    } else {
        
        self.centerPiciew.hidden = YES;
        self.centerShadow.hidden = YES;
        self.centerbutton.hidden = YES;
        self.bottomLine.hidden = NO;
        self.title2.hidden = NO;
        self.bottomLineTop.constant = 386.5 - 100 - 15;

    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView  numberOfItemsInSection:(NSInteger)section {
    
    return 5;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFHomeHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFHomeHeaderCollectionViewCell" forIndexPath:indexPath];

    
    return cell;
}

@end
