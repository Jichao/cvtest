//
//  AVView.m
//  CVTest
//
//  Created by jichao on 2016/11/1.
//  Copyright © 2016年 jichao. All rights reserved.
//

#import "AVView.h"
#import "AVCell.h"

@interface AVView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) UICollectionView* collectionView;
@end


@implementation AVView

- (AVView*)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.selectedIndex = -1;
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 20;
        flowLayout.itemSize = CGSizeMake(50,50);
        UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 50, [[UIScreen mainScreen] bounds].size.width - 40, 50) collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[AVCell class] forCellWithReuseIdentifier:@"kekeke"];
        [self addSubview: collectionView];
        self.collectionView = collectionView;
    }
    return  self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![self.collectionView pointInside:point withEvent:event]) {
        self.selectedIndex = -1;
        [self.collectionView performBatchUpdates:^{ } completion:nil];
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    AVCell* cell = (AVCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"kekeke" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.index = (int)indexPath.row;
    return cell;
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = (int)indexPath.row;
    [collectionView performBatchUpdates:^{ } completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = -1;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedIndex) {
        return CGSizeMake(100, 50);
    } else {
        return CGSizeMake(50, 50);
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
