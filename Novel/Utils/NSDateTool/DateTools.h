//
//  DateTools.h
//  Novel
//
//  Created by th on 2017/2/13.
//  Copyright © 2017年 th. All rights reserved.
//
#define kCustomDateFormat @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"

#import <Foundation/Foundation.h>

typedef enum {
    DateTypeHHmm,   //HH:mm
    DateTypeHHmmss, //HH:mm:ss
    DateTypeYYYYmmdd,
    DateTypeMMddHHmm,
    DateTypeYAll    //YYYY-MM-dd HH:mm:ss
}DateType;

@interface DateTools : NSObject

+ (instancetype)shareDate;

- (NSDate *)dateWithCustomDateFormat:(NSString *)dateStr;
- (NSString *)getUpdateStringWith:(NSDate *)date;
- (NSString *)getTimeString;

#pragma mark - 获取一个NString类型的时间戳
+ (NSString *)getTimeInterval;

@property (nonatomic,copy) NSString*year;
@property (nonatomic,copy) NSString*month;
@property (nonatomic,copy) NSString*day;
@property (nonatomic,copy) NSString*hours;
@property (nonatomic,copy) NSString*minutes;
@property (nonatomic,copy) NSString*seconds;



/**
 *  根据标准时间戳初始化一个时间模型 2012-10-21 10:10:10
 *
 *  @param timeString 时间按
 *
 *  @return 时间模型
 */
- (instancetype)initWithTimeString:(NSString *)timeString;

#pragma mark 时间格式
/**
 *	@brief	获取当前系统日期
 *
 *	@return	Year = [conponent year];
 *  @return	month = [conponent month];
 *  @return	day = [conponent day];
 */
- (NSDateComponents*)getDateNow;

#pragma mark - 获取系统当前时间
/**
 *	@brief	获取系统当前时间
 *
 *	@param 	type 	DateType
 *
 *	@return	typeStyle
 */
+ (NSString*)getDateTimeNow:(DateType)type;


#pragma mark - 获取当前时间小时
/**
 *	@brief	获取当前时间小时
 *
 *	@return	当前小时数
 */
+ (double)getDateHour;


#pragma mark - 获取当前分钟数
/**
 *	@brief	获取当前分钟数
 *
 *	@return	当前分钟数
 */
+ (double)getDateMini;



#pragma mark -将时间字符串nsstring转为date
/**
 *  将时间字符串转为date
 *
 *  @param dateString 时间字符串
 *
 *  @return date
 */
+ (NSDate *)dateFromString:(NSString *)dateString dateformatter:(NSString *)formatter;


#pragma mark - 将时间date转为字符串nsstring
/**
 *  将时间转为字符串
 *
 *  @param date date
 *
 *  @return 时间字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date dateformatter:(NSString *)formatter;


/**
 将时间戳转化为字符串

 @param timeStamp 时间戳
 @param formatter 时间格式
 @return 返回时间字符串
 */
+ (NSString *)stringFromTimeStamp:(double)timeStamp dateFormatter:(NSString *)formatter ;

@end
