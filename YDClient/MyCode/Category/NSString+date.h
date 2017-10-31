//
//  NSString+date.h
//  Briefing
//
//  Created by maoziyue on 2017/9/25.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (date)

+ (NSDate *)getNowDate;
+ (NSInteger)getNowTimeInterval;
+ (NSInteger)dateToTimeInterval:(NSString *)time;
+ (NSString *)timeIntervalToDate:(NSInteger)timeInterval;
+ (NSInteger)dateToTimeInterval:(NSString *)time andFormatter:(NSString *)format;
+ (NSString *)timeIntervalToDate:(NSInteger)timeInterval andFormatter:(NSString *)format;


//字符串201709 转日期2017年09月
+ (NSString *)dateToString:(NSDate *)mdate;//2017年09月
+ (NSString *)dateToYYYYMMString:(NSDate *)mdate;//201709


+ (NSDate *)stringToYYYYMMDate:(NSString *)dateString;//201709

+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format;
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format;


//13位时间戳转化为字符串
+ (NSString *)timeInterval13bitToDateString:(NSString *)timeInterval;


@end
