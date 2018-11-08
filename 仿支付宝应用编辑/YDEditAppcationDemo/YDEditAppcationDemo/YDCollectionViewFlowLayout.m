//
//  YDCollectionViewFlowLayout.m
//  yundabmapp
//
//  Created by wj on 16/10/26.
//  Copyright © 2016年 LS-LONG. All rights reserved.
//

#import "YDCollectionViewFlowLayout.h"

@implementation YDCollectionViewFlowLayout
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //collectionView只能设置cell间的最小间距,有时布局会乱,原因未知。
    //这里重写方法,修改cell的Frame,调整为自己想要的间距。
     NSMutableArray * attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];    
    for(int i = 1; i < [attributes count]; ++i) {
      
        UICollectionViewLayoutAttributes * currentLayoutAttributes = attributes[i];
        UICollectionViewLayoutAttributes * prevLayoutAttributes = attributes[i - 1];
        
        NSLog(@"%d,%@,%@",i,NSStringFromCGRect(prevLayoutAttributes.frame),NSStringFromCGRect(currentLayoutAttributes.frame));

        if(currentLayoutAttributes.representedElementCategory == UICollectionElementCategoryCell && prevLayoutAttributes.representedElementCategory == UICollectionElementCategoryCell && currentLayoutAttributes.indexPath.section == prevLayoutAttributes.indexPath.section)
        {
            CGFloat maximumSpacing = 0;
            CGFloat origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width <= self.collectionViewContentSize.width)
            {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = origin + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
    }
    return attributes;
}
@end
