//
//  YDDateFormatTool.m
//
//
//  Created by wj on 17/6/23.
//  Copyright © 2017年 LS-LONG. All rights reserved.
//

#import "YDDateFormatTool.h"

@interface YDDateFormatTool ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSTimeZone *timeZone;

@end

@implementation YDDateFormatTool

#pragma mark - singleTon
static YDDateFormatTool *dateFormatTool = nil;

+ (YDDateFormatTool *)sharedDateFormatTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatTool = [[self alloc] init];
    });
    return dateFormatTool;
}
#pragma mark - 获取时间
//获取当前时间,默认格式
- (NSString *)getNowDefultFormatDateStr
{
   return  [self getNowDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
//获取当前时间,指定格式
- (NSString *)getNowDateStringWithFormat:(NSString *)dateFormat
{
    return [self getDateStringWithFormat:dateFormat date:[NSDate date]];
}

//本地时间转化指定格式
- (NSString *)convertDateToStringWithFormat:(NSString *)format withDate:(NSDate *)date
{
    if (!date) {
        NSDate *dateNow = [NSDate date]; // 获得时间对象
        
        NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
        
        NSTimeInterval time = [zone secondsFromGMTForDate:dateNow];// 以秒为单位返回当前时间与系统格林尼治时间的差
        
       NSDate * mydate = [dateNow dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        [dateFormatter setTimeZone:timeZone];
        NSString *dateStr = [dateFormatter stringFromDate:mydate];
        return dateStr;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//转换指定时间,指定格式转换出的date字符串.
- (NSString *)getDateStringWithFormat:(NSString *)dateFormat date:(NSDate *)date
{
    [self.dateFormatter setDateFormat:dateFormat];
    NSString * dateStr = [self.dateFormatter stringFromDate:date];
    return dateStr;
}
//转换指定时间字符串,指定格式转换出的date.
- (NSDate *)getDateWithDateString:(NSString *)dateString format:(NSString *)dateFormat
{
    [self.dateFormatter setDateFormat:dateFormat];
    NSDate *date = [self.dateFormatter  dateFromString:dateString];
    return date;
}
//时间字符串,转换格式,生成新的时间字符.
- (NSString *)convertDateString:(NSString *)dateString FromDateFormat:(NSString *)oldDateFormat toDateFormat:(NSString *)newDateFormat
{
    NSDate  * date = [self getDateWithDateString:dateString format:oldDateFormat];
    NSString * dateStr =  [self getDateStringWithFormat:newDateFormat date:date] ;
    return dateStr ;
}

#pragma mark - LazyLoad

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
- (NSTimeZone *)timeZone
{
    if (!_timeZone) {
        _timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*60*60];
    }
    return _timeZone;
}
@end
