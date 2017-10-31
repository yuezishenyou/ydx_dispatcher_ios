//
//  NSString+date.m
//  Briefing
//
//  Created by maoziyue on 2017/9/25.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "NSString+date.h"

@implementation NSString (date)

#pragma mark - 获取当前时间的 时间戳

+ (NSDate *)getNowDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    //NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    return datenow;
}

+ (NSInteger)getNowTimeInterval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    //NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    NSLog(@"设备当前的时间戳:%ld",(long)timeSp); //时间戳的值
    return timeSp;
}


+ (NSInteger)dateToTimeInterval:(NSString *)time
{
    return [NSString dateToTimeInterval:time andFormatter:@"YYYY-MM-dd HH:mm:ss"];
}



//将某个时间转化成 时间戳
+ (NSInteger)dateToTimeInterval:(NSString *)time andFormatter:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    //------------将字符串按formatter转成nsdate
    NSDate* date = [formatter dateFromString:time];
    //时间转时间戳的方法
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    NSLog(@"将某个时间转化成时间戳:%ld",(long)timeSp); //时间戳的值
    return timeSp;
}

+ (NSString *)timeIntervalToDate:(NSInteger)timeInterval
{
    return [NSString timeIntervalToDate:timeInterval andFormatter:@"YYYY-MM-dd HH:mm:ss"];
}

//将某个时间戳转化成 时间
+ (NSString *)timeIntervalToDate:(NSInteger)timeInterval andFormatter:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"某个时间戳转化成时间:%@",confromTimespStr);
    return confromTimespStr;
}










// 日期格式转字符串
+ (NSString *)dateToString:(NSDate *)mdate
{
    return [NSString dateToString:mdate withDateFormat:@"yyyy年MM月"];
}

//201709
+ (NSString *)dateToYYYYMMString:(NSDate *)mdate
{
    return [NSString dateToString:mdate withDateFormat:@"yyyyMM"];
}

+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    //    NSDate *nowDate = [NSDate date];
    //    NSString *str = [self dateToString:nowDate withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSLog(@"%@",str);
    //    NSDate *newdate = [self stringToDate:str   //2016-01-18 15:13:12
    //                          withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSLog(@"%@",newdate);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}



//字符串转日期格式
+ (NSDate *)stringToYYYYMMDate:(NSString *)dateString;//201709
{
    return [NSString stringToDate:dateString withDateFormat:@"yyyyMM"];
}
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSDate *mmm = [NSString worldTimeToChinaTime:date];
    return mmm;
}

//将世界时间转化为中国区时间
+ (NSDate *)worldTimeToChinaTime:(NSDate *)date
{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    return localeDate;
}



//13位时间戳转化为字符串
+ (NSString *)timeInterval13bitToDateString:(NSString *)timeInterval
{
    NSTimeInterval _interval=[timeInterval doubleValue] / 1000.0;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    return [objDateformat stringFromDate: date];
}












@end
