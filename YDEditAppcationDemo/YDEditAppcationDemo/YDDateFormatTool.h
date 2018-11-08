//
//  YDDateFormatTool.h
//  
//
//  Created by wj on 17/6/23.
//  Copyright © 2017年 LS-LONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDDateFormatTool : NSObject

+ (YDDateFormatTool *)sharedDateFormatTool;

//获取当前时间,默认格式
- (NSString *)getNowDefultFormatDateStr;
//获取当前时间,指定格式
- (NSString *)getNowDateStringWithFormat:(NSString *)dateFormat;
//时间字符串,转换格式,生成新的时间字符.
- (NSString *)convertDateString:(NSString *)dateString FromDateFormat:(NSString *)oldDateFormat toDateFormat:(NSString *)newDateFormat;
//本地时间转化指定格式
- (NSString *)convertDateToStringWithFormat:(NSString *)format withDate:(NSDate *)date;
//转换指定时间字符串,指定格式转换出的date.
- (NSDate *)getDateWithDateString:(NSString *)dateString format:(NSString *)dateFormat;
//转换指定时间,指定格式转换出的date字符串.
- (NSString *)getDateStringWithFormat:(NSString *)dateFormat date:(NSDate *)date;
@end
