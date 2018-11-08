//
//  YDSortTool.h
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/9/27.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDApplicationModel.h"
#import "FMDB.h"

@interface YDSortTool : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

// 初始化
+ (YDSortTool *)sharedSortTool;

- (void)addApplicationModelArray:(NSArray <YDApplicationModel *> *)applicationModelArray ApplicationType:(YDApplicationType)type;

- (NSArray *)getApplicationWithType:(YDApplicationType)type;
@end
