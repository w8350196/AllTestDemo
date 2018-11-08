//
//  YDApplicationModel.h
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/9/25.
//  Copyright © 2018年 陈小勇. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YDApplicationType) {
    YDApplicationTypeCommen,
    YDApplicationTypeMoney,
    YDApplicationTypeOther,
};

@interface YDApplicationModel : NSObject

@property (nonatomic,copy) NSString * imageName;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,assign) BOOL     canEdit;
@property (nonatomic,copy) NSString * sortOrder;
@property (nonatomic,assign) YDApplicationType type;

+ (instancetype)ApplicationModelWithImageName:(NSString *)imageName title:(NSString *)title type:(YDApplicationType )type;

@end
