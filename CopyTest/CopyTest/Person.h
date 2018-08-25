//
//  Person.h
//  CopyTest
//
//  Created by wj on 2017/8/30.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Person : NSObject<NSCopying,NSMutableCopying,NSCoding>

@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * name;

- (instancetype)copyMyself;
@end
