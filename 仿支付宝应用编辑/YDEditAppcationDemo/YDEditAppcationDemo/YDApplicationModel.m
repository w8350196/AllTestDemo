//
//  YDApplicationModel.m
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/9/25.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import "YDApplicationModel.h"

@implementation YDApplicationModel

- (instancetype)copyWithZone:(NSZone *)zone {
    
    YDApplicationModel *copyModel = [[YDApplicationModel allocWithZone:zone] init];
    
    copyModel.title = self.title;
    copyModel.imageName = self.imageName;

    return copyModel;
}


- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title type:(YDApplicationType )type
{
    if (self = [super init])
    {
        _imageName = imageName;
        _title = title;
        _type = type;
    }
    return self;
}

+ (instancetype)ApplicationModelWithImageName:(NSString *)imageName title:(NSString *)title type:(YDApplicationType )type
{
    return [[self alloc] initWithImageName:imageName title:title type:type];
}

@end
