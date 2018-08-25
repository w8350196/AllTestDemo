//
//  NSArray+Description.m
//  CopyTest
//
//  Created by wj on 2017/8/30.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "NSArray+Description.h"

@implementation NSArray (Description)

- (NSString *)description
{
    NSMutableString * str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"NSArray %p",self]];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [str appendFormat:@",%p", obj];
        
    }];
    return str;
}

@end
