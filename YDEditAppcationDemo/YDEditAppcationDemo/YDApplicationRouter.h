//
//  YDApplicationRouter.h
//  YDEditAppcationDemo
//
//  Created by 陈小勇 on 2018/10/24.
//  Copyright © 2018年 陈小勇. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YDApplicationModel;

@interface YDApplicationRouter : NSObject

+ (YDApplicationRouter *)sharedApplicationRouter ;
- (void)didClickApplicaton:(YDApplicationModel *)model;

@end
