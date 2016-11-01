//
//  AVLayout.m
//  CVTest
//
//  Created by jichao on 2016/11/1.
//  Copyright © 2016年 jichao. All rights reserved.
//

#import "AVLayout.h"
@interface AVLayout()
@property (nonatomic, strong) NSMutableDictionary* layoutInfoDic;
@property (nonatomic, assign) UICollectionUpdateAction animationType;
@property (nonatomic, strong) NSIndexPath* lastSelectIndexPath;
@property (nonatomic, strong) NSIndexPath* currentSelectIndexPath;
@end

@implementation AVLayout
- (instancetype)init {
    if (self = [super init]) {
        self.lastSelectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
        self.currentSelectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    }
    return self;
}

- (NSIndexPath*)getSelectIndexPath {
    return self.currentSelectIndexPath;
}

- (void)setSelectedIndex:(int)selectedIndex {
    NSIndexPath* index = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    if (index != self.currentSelectIndexPath) {
        self.lastSelectIndexPath = self.currentSelectIndexPath;
        self.currentSelectIndexPath = index;
        NSIndexSet* set = [[NSIndexSet alloc] initWithIndex:0];
        [self.collectionView reloadSections:set];
    } else{
        [self.collectionView scrollToItemAtIndexPath:self.currentSelectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    self.layoutInfoDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; ++i) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        self.layoutInfoDic[indexPath] = attr;
    }
}

- (CGSize)collectionViewContentSize {
    long numOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numOfItems) {
        return CGSizeMake((self.itemSize.width + self.interitemSpacing) * numOfItems + self.interitemSpacing, self.itemSize.height);
    } else {
        return self.collectionView.frame.size;
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
{
    NSMutableArray* attributesArr = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes* attr in self.layoutInfoDic.allValues) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attributesArr addObject:attr];
        }
    }
    return attributesArr;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.frame = [self currentFrameWithIndexPath:indexPath];
    return attribute;
}

//// MARK: - option override method
////    //此方法刷新动画的时候会调用
////    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
////        let frame = self.currentFrameWithIndexPath(self.currentSelectIndexPath)
////        return CGPointMake(frame.centerX-self.collectionView!.width/2.0, 0)
////    }
//
//// MARK: animation method
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    self.animationType = UICollectionUpdateActionNone;
    for (UICollectionViewUpdateItem* item in updateItems) {
        if (item.updateAction == UICollectionUpdateActionReload) {
            self.animationType = UICollectionUpdateActionReload;
            break;
        } 
    }
//    //保存更新的indexPath
//    for item in updateItems {
//        switch item.updateAction {
//        case .insert:
//            let indexPath = item.indexPathAfterUpdate
//            self.insertIndexPathArr.append(indexPath!)
//            self.animationType = .insert
//        case .delete:
//            let indexPath = item.indexPathBeforeUpdate
//            self.deleteIndexPathArr.append(indexPath!)
//            self.animationType = .delete
//        case .reload:
//            let indexPath = item.indexPathBeforeUpdate
//            self.reloadIndexPathArr.append(indexPath!)
//            self.animationType = .reload
//        case .move:
//            self.beforeMoveIndexPath = item.indexPathBeforeUpdate!
//            self.afterMoveIndexPath = item.indexPathAfterUpdate!
//            self.animationType = .move
//        case .none:
//            self.animationType = .none
//            break
//        }
//    }
}
//
//override func finalizeCollectionViewUpdates() {
//    
//}
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes* attribute = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if (self.animationType == UICollectionUpdateActionReload) {
        attribute.frame = [self lastFrameWithIndexPath:itemIndexPath];
    }
    return attribute;

}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes* attribute = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if (self.animationType == UICollectionUpdateActionReload) {
        attribute.alpha = 1.0;
        attribute.frame = [self currentFrameWithIndexPath:itemIndexPath];
    }
    return attribute;
}

//override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//    let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)?.copy() as? UICollectionViewLayoutAttributes
//    switch self.animationType {
//    case .insert:
//        attributes?.frame = self.currentFrameWithIndexPath(IndexPath(row: itemIndexPath.row+1, section: itemIndexPath.section))
//    case .delete:
//        if self.deleteIndexPathArr.contains(itemIndexPath) {
//            //这里写成缩放成(0，0)直接就不见了
//            attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//            attributes?.alpha = 0.0
//        }
//        else {
//            attributes?.frame = self.currentFrameWithIndexPath(IndexPath(row: itemIndexPath.row-1, section: itemIndexPath.section))
//        }
//    case .move:
//        if self.beforeMoveIndexPath == itemIndexPath {
//            //afterMoveIndexPath的消失动画和beforeMoveIndexPath的出现动画重合，设置他们旋转的角度一样，方向相反
//            //                attributes?.transform3D = CATransform3DMakeRotation(1.0/2.0*CGFloat(M_PI), 0, 0, 1)
//        }
//    case .reload:
//        attributes?.alpha = 1.0
//        attributes?.frame = self.currentFrameWithIndexPath(itemIndexPath)
//    default:
//        break
//    }
//    print("fina:")
//    print(attributes)
//    return attributes
//}

#pragma mark - private
-(CGRect) currentFrameWithIndexPath:(NSIndexPath*)indexPath {
    return [self frameWithIndexPath:indexPath selectIndexPath: self.currentSelectIndexPath];
}

-(CGRect) lastFrameWithIndexPath:(NSIndexPath*)indexPath {
    return [self frameWithIndexPath:indexPath selectIndexPath: self.lastSelectIndexPath];
}

-(CGRect) frameWithIndexPath:(NSIndexPath*)indexPath selectIndexPath: (NSIndexPath*)selectIndexPath
{
    CGFloat left;
    CGFloat width;
    if (selectIndexPath.row == -1) {
        left = indexPath.row * (self.itemSize.width + self.interitemSpacing) + self.interitemSpacing;
        width = self.itemSize.width;
    } else {
        if (indexPath.row < selectIndexPath.row) {
            left = indexPath.row * (self.itemSize.width + self.interitemSpacing) + self.interitemSpacing;
            left -= self.itemSize.width / 2;
            width = self.itemSize.width;
        } else if (indexPath.row == selectIndexPath.row) {
            left = indexPath.row * (self.itemSize.width + self.interitemSpacing) + self.interitemSpacing;
            left -= self.itemSize.width / 2;
            width = self.itemSize.width*2;
        } else {
            left = indexPath.row * (self.itemSize.width + self.interitemSpacing) + self.interitemSpacing;
            left += self.itemSize.width / 2;
            width = self.itemSize.width;
        }
    }
    NSLog(@"kkk frame = %f, %f, %f, %f for item %d\n", left, 0.f, width, self.itemSize.height, (int)indexPath.row);
    return CGRectMake(left, 0, width, self.itemSize.height);
}

@end
