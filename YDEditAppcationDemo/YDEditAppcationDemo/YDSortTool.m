//
//  YDSortTool.m
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/9/27.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import "YDSortTool.h"
#import "YDApplicationModel.h"
#import "YDDateFormatTool.h"

@implementation YDSortTool

static YDSortTool * sortTool = nil;

+ (YDSortTool *)sharedSortTool
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sortTool = [[self alloc] init];
    });
    return sortTool;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 1.数据库路径
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"demo.sqlite"];
        NSLog(@"path === %@", path);
        
        // 2,创建数据库
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        // 3,创建表
        [self creatTable];
        
    }
    return self;
}

- (void)creatTable
{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        // 创建排序表.
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS 'tmsApplicationSort' ('imageName'  TEXT , 'title'  TEXT NOT NULL,  'sortOrder'  INTEGER, 'applicationType'  INTEGER , 'updateTime'  DATETIME , 'loginAccount'  TEXT NOT NULL ,PRIMARY KEY('title','applicationType','loginAccount'));"];
    }];
}

- (void)addApplicationModelArray:(NSArray <YDApplicationModel *> *)applicationModelArray ApplicationType:(YDApplicationType)type
{
    NSString * loginAccount = @"12312313";
    NSString * updateTime = [[YDDateFormatTool sharedDateFormatTool] getNowDefultFormatDateStr];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        //先清除旧数据.在添加该类型的数据.
        NSString *sql = [NSString stringWithFormat:@"DELETE  FROM 'tmsApplicationSort' WHERE loginAccount = '%@' AND  applicationType = '%ld' " ,loginAccount,type];
        [db executeUpdate:sql];
        
        [applicationModelArray enumerateObjectsUsingBlock:^(YDApplicationModel * _Nonnull applicationModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString * sql = [NSString stringWithFormat:@"REPLACE INTO 'tmsApplicationSort' ( title, imageName,applicationType,sortOrder,updateTime,loginAccount) VALUES ( '%@', '%@', '%ld','%ld','%@','%@')",applicationModel.title,applicationModel.imageName,type,idx,updateTime,loginAccount];
            [db executeUpdate:sql];
            
        }];
    }];
}

- (NSArray *)getApplicationWithType:(YDApplicationType)type
{
    __block NSMutableArray * applicationModelArray = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString * loginAccount = @"12312313";
        NSString *   sql = [NSString stringWithFormat:@"SELECT * FROM 'tmsApplicationSort' WHERE  loginAccount = '%@' AND applicationType = '%ld' ORDER BY sortOrder ",loginAccount,(long)type];
        FMResultSet *set = [db executeQuery:sql];
        // 不断往下取数据
        while (set.next)
        {
            YDApplicationModel * applicationModel = [self setApplicationModelWithResultSet:set];
            [applicationModelArray addObject:applicationModel];
        }
        
    }];
    return applicationModelArray;
}

- (YDApplicationModel *)setApplicationModelWithResultSet:(FMResultSet *)set
{
    YDApplicationModel * applicationModel = [[YDApplicationModel alloc]init];
    applicationModel.imageName = [set stringForColumn:@"imageName"];
    applicationModel.title = [set stringForColumn:@"title"];
    applicationModel.canEdit = [set boolForColumn:@"canEdit"];
    applicationModel.sortOrder = [set stringForColumn:@"sortOrder"];
    applicationModel.type = [set intForColumn:@"applicationType"];
    return applicationModel;
}

@end
