//
//  DateTools.m
//  Novel
//
//  Created by th on 2017/2/13.
//  Copyright © 2017年 th. All rights reserved.
//

#import "DateTools.h"

static NSDateFormatter *g_dayDateFormatter = nil;

@interface DateTools ()

@property (strong, nonatomic) NSDateFormatter *dateFormat;

@end

@implementation DateTools

+ (instancetype)shareDate {
    static DateTools *dateM = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateM = [[self alloc] init];
    });
    return dateM;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormat = [[NSDateFormatter alloc] init];
        self.dateFormat.dateFormat = kCustomDateFormat;
    }
    return self;
}

- (NSDate *)dateWithCustomDateFormat:(NSString *)dateStr {
    self.dateFormat.dateFormat = kCustomDateFormat;
    return [self.dateFormat dateFromString:dateStr];
}

- (NSString *)getUpdateStringWith:(NSDate *)date {
    if (!date || ![date isKindOfClass:[NSDate class]]) {
        return @"long long ago";
    } else {
        NSString *unit = nil;
        NSInteger number = 0;
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
        if (interval > 365 * 24 * 60 * 60) {
            number = interval / (365 * 24 * 60 * 60);
            unit = @"年";
        } else if (interval > 30 * 24 * 60 * 60) {
            number = interval / (30 * 24 * 60 * 60);
            unit = @"月";
        } else if (interval > 24 * 60 * 60) {
            number = interval / (24 * 60 * 60);
            unit = @"天";
        } else if (interval > 60 * 60) {
            number = interval / (60 * 60);
            unit = @"小时";
        } else if (interval > 60) {
            number = interval / 60;
            unit = @"分钟";
        } else {
            return @"刚刚";
        }
        return [NSString stringWithFormat:@"%zi%@前",number,unit];
    }
}

- (NSString *)getTimeString {
    self.dateFormat.dateFormat = @"HH:mm";
    return [self.dateFormat stringFromDate:[NSDate date]];
}

#pragma mark - 初始化一个时间模型
- (instancetype)initWithTimeString:(NSString *)timeString
{
    if (self = [super init]) {
        
        NSArray *array = [timeString componentsSeparatedByString:@"-"];
        NSString *year = [array objectAtIndex:0];
        NSString *month = [array objectAtIndex:1];
        
        //日和时分秒
        NSString *day = [array lastObject];
        array = [day componentsSeparatedByString:@" "];
        day = [array firstObject];
        
        //时分秒
        NSString *hours = [array lastObject];
        array = [hours componentsSeparatedByString:@":"];
        hours = [array objectAtIndex:0];
        NSString *minutes = [array objectAtIndex:1];
        NSString *seconds = [array lastObject];
        
        self.year = year;
        self.month = month;
        self.day = day;
        self.hours = hours;
        self.minutes = minutes;
        self.seconds = seconds;
    }
    return self;
}

#pragma mark - 获取一个NString类型的时间戳
+ (NSString *)getTimeInterval {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%.0lf",interval];
}

#pragma mark - 获取时间格式
-(NSDateComponents*)getDateNow
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *conponent = [cal components:unitFlags fromDate:[NSDate date]];
    return conponent;
}

#pragma mark - 获取系统当前时间
+(NSString*)getDateTimeNow:(DateType)type
{
    NSDate *date = [NSDate date];
    
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }
    
    NSDateFormatter *dateFormatter = g_dayDateFormatter;
    switch (type) {
        case DateTypeHHmm:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case DateTypeHHmmss:
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            break;
        case DateTypeYAll:
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            break;
        case DateTypeYYYYmmdd:
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        default:
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            break;
    }
    return [dateFormatter stringFromDate:date];
}

#pragma mark - 获取当前时间小时
+(double)getDateHour
{
    NSDate *date = [NSDate date];
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }
    
    NSDateFormatter *dateFormatter = g_dayDateFormatter;
    [dateFormatter setDateFormat:@"HH"];
    NSString *strHour = [dateFormatter stringFromDate:date];
    return [strHour doubleValue];
}

#pragma mark - 获取当前分钟数
+(double)getDateMini
{
    NSDate *date = [NSDate date];
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }
    
    NSDateFormatter *dateFormatter = g_dayDateFormatter;
    [dateFormatter setDateFormat:@"mm"];
    NSString *strHour = [dateFormatter stringFromDate:date];
    return [strHour doubleValue];
}


#pragma mark -将时间字符串nsstring转为date
+ (NSDate *)dateFromString:(NSString *)dateString dateformatter:(NSString *)formatter {
    
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }
    
    NSDateFormatter *dateFormatter = g_dayDateFormatter;
    [dateFormatter setDateFormat: formatter];//kYCustomDateFormat
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma mark - 将时间date转为字符串nsstring
+ (NSString *)stringFromDate:(NSDate *)date dateformatter:(NSString *)formatter{
    
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }
    
    NSDateFormatter *dateFormatter = g_dayDateFormatter; //zzz表⽰示时区,zzz可以删除,这样返回的⽇日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:formatter];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSString *)stringFromTimeStamp:(double)timeStamp dateFormatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:formatter];
    
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
    
    return timeStr;
}

@end
