//
//  YDAppCollectionViewCell.h
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/9/25.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDApplicationModel;

typedef void(^YDAppCollectionViewCellBlock)();


typedef NS_ENUM(NSInteger, YDAppCollectionViewCellEditButtonState) {
   
    YDAppCollectionViewCellEditButtonStateNone,
    YDAppCollectionViewCellEditButtonStateAdd,
    YDAppCollectionViewCellEditButtonStateRemove,
    YDAppCollectionViewCellEditButtonStateNonRemove,
    
};

@interface YDAppCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) YDAppCollectionViewCellBlock buttonClickBlock;

- (void)updateUIWithApplicationModel:(YDApplicationModel *)model;
- (void)setEditState:(YDAppCollectionViewCellEditButtonState )state;

@end
