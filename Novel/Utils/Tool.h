//
//  Tool.h
//  xx
//
//  Created by th on 2017/4/22.
//  Copyright © 2017年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CoreArchive.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#define kTool [Tool shareInstance]

#ifndef kIsNetwork
#define kIsNetwork     [kTool isNetwork]  // 一次性判断是否有网的宏
#endif

#ifndef kIsWWANNetwork
#define kIsWWANNetwork [kTool isWWANNetwork]  // 一次性判断是否为手机网络的宏
#endif

#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork [kTool isWiFiNetwork]  // 一次性判断是否为WiFi网络的宏
#endif

#define keyChainIDFA @"keyChainIDFA" //IDFA keychain   缓存宏定义

#define keyChainIDFV @"keyChainIDFV" //IDFV keychainh  缓存宏定义

#define keyChainUUID @"keyChainUUID" //UUID keychainh  缓存宏定义

typedef NS_ENUM(NSUInteger, HttpStatusType) {
    /** 未知网络*/
    HttpStatusUnknown,
    /** 无网络*/
    HttpStatusNotReachable,
    /** 手机网络*/
    HttpStatusReachableViaWWAN,
    /** WIFI网络*/
    HttpStatusReachableViaWiFi
};

@interface Tool : NSObject

+ (instancetype)shareInstance;

/**
 检测是否是新版本

 @return bool
 */
- (BOOL)isNewVersion;

#pragma mark - 获取缓存大小
/**
 获取缓存大小

 @param completion block打印缓存size
 */
- (void)getCachesFileSize:(void (^)(NSString *size))completion;

/**
 *  清除缓存
 *
 *  @param completion block bool是否成功
 */
- (void)removeCache:(void (^)(BOOL flag))completion;

#pragma mark - 将字典，数组写到沙盒
/**
 *  将字典，数组写到沙盒
 *
 *  @param dataSource 字典，数组
 *  @param fileName   文件名：region.plist
 *
 *  @return 文件的路径
 */
- (NSString *)writeToDocumentsWithDataSource:(id)dataSource FileName:(NSString *)fileName;

/**
读取沙盒plist,只能读取存储为Array格式的数据

 @param fileName plist文件名
 @return 数组
 */
- (NSArray *)readArrayFromDocumentWithFileName:(NSString *)fileName;


/**
 读取沙盒plist,只能读取存储为Dictionary格式的数据

 @param fileName plist文件名
 @return 字典
 */
- (NSDictionary *)readDictFromDocumentWithFileName:(NSString *)fileName;

/**
 获取沙盒Library目录下的Private Documents目录下的某个文件路径

 @param key 文件名
 @param type 文件后缀 例如.plist  .data
 @return 文件路径
 */
- (NSString *)getPathWithKey:(NSString *)key ofType:(NSString *)type;

#pragma mark - 取得wifi名
/**
 *  取得wifi名，需要真机
 *
 *  @return wifi名
 */
- (NSString *)getWifiName;

/**
 * 获取 IDFA
 */
- (NSString *)getIdfa;


/**
 * 获取 IDFV
 */
- (NSString *)getIdfv;

/**
 * 获取分辨率
 */
- (NSString *)getResolution;

/**
 * 获取UUID，去掉连接符号
 */
- (NSString *)getUUIDWithoutSymbol;

/**
 * 获取移动厂商
 */
- (NSString *)getCarrierName;

/**
 * 获取IP地址
 */
- (NSString *)getIPAddress;

/**
 * 当前WIFI是否开启
 */
-(BOOL) isWiFiOpened;

/**
 * 获取是否IPAD设备
 */
-(NSString *)getIsIpad;

/**
 获取设备唯一号
 */
- (NSString *)getDeviceId;

- (NSString *)getUUID;

/** ******************************************** 网络状态部分 ************************************************** */


/**
 有网YES, 无网:NO
 */
- (BOOL)isNetwork;

/**
 手机网络:YES, 反之:NO
 */
- (BOOL)isWWANNetwork;

/**
 WiFi网络:YES, 反之:NO
 */
- (BOOL)isWiFiNetwork;

/** 网络状态的Block*/
typedef void(^HttpStatusBlock)(HttpStatusType status);

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
- (void)networkStatusWithBlock:(HttpStatusBlock)networkStatus;



@end
