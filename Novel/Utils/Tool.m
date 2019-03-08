//
//  Tool.m
//  xx
//
//  Created by th on 2017/4/22.
//  Copyright © 2017年 th. All rights reserved.
//

#import "Tool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <net/if.h>
#import "KeyChainManager.h"
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

@implementation Tool

+ (instancetype)shareInstance {
    
    static Tool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Tool alloc] init];
    });
    return instance;
}

/* 
 区别
 
 CFBundleShortVersionString对应Xcode里项目的Version
 CFBundleVersion 对应Xcode里项目的Build 这个版本是内部自己团队使用的一个版本号，一般不对外公开。
 
 */
- (BOOL)isNewVersion {
    
    //1、 取出沙盒中存储的上次使用软件的版本号
    NSString *key = @"CFBundleShortVersionString";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 2、获得当前软件的版本号
    NSString *currentVersion = kApplication.appVersion;
    
    // 3、判断版本号
    if ([currentVersion isEqualToString:lastVersion]) {
        // 旧版本
        return NO;
    } else {
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        
        return YES;
    }
}

- (void)getCachesFileSize:(void (^)(NSString *size))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        NSString *folderPath = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"];
        
        NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        NSFileManager* manager = [NSFileManager defaultManager];
        NSString *sizeStr = @"0M";
        if (![manager fileExistsAtPath:folderPath]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(sizeStr);
            });
        } else {
            NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
            
            NSString* fileName;
            
            long long folderSize = 0;
            
            while ((fileName = [childFilesEnumerator nextObject]) != nil){
                NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
                folderSize += [kTool fileSizeAtPath:fileAbsolutePath];
            }
            
            float sizeM = folderSize/(1024.0*1024.0);
            
            if (sizeM < 1) {
                
                int size = (int)1024 * sizeM;
                
                sizeStr = [NSString stringWithFormat:@"%d k",size];
            } else {
                
                sizeStr = [NSString stringWithFormat:@"%@ M",[NSString changeFloat:[NSString stringWithFormat:@"%.2f", sizeM]]];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(sizeStr);
            });
        }
    });
    
}

//单个文件的大小
- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)removeCache:(void (^)(BOOL flag))completion {
    dispatch_async(
       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
       , ^{
           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
           for (NSString *p in files) {
               NSError *error;
               NSString *path = [cachPath stringByAppendingPathComponent:p];
               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
               }
           }
           dispatch_async(dispatch_get_main_queue(), ^{
               completion(YES);
           });
       });
}

- (NSString *)writeToDocumentsWithDataSource:(id)dataSource FileName:(NSString *)fileName {
    
    //得到完整的文件名
    NSString *filename = [[Tool shareInstance] getPathWithKey:fileName ofType:@".plist"];
    // 写入本地
    if ([dataSource isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)dataSource;
        [array writeToFile:filename atomically:YES];
        return filename;
    }
    if ([dataSource isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)dataSource;
        [dict writeToFile:filename atomically:YES];
        
        return filename;
    }
    
    return @"";
}

- (NSArray *)readArrayFromDocumentWithFileName:(NSString *)fileName {
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    return [NSArray arrayWithContentsOfFile:[[Tool shareInstance] getPathWithKey:fileName ofType:@".plist"]];
}

- (NSDictionary *)readDictFromDocumentWithFileName:(NSString *)fileName {
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    //统一使用沙盒Library目录下的Private Documents文件夹
    return [NSDictionary dictionaryWithContentsOfFile:[[Tool shareInstance] getPathWithKey:fileName ofType:@".plist"]];
}

- (NSString *)getPathWithKey:(NSString *)key ofType:(NSString *)type {
    
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    docsdir = [docsdir stringByAppendingPathComponent:@"Private Documents"];
    NSLog(@"%@",docsdir);
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path = @"";
    if (type.length > 0) {
        path = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.%@", NSStringFromClass([self class]),key, type]];
    } else {
        path = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]),key]];
    }
    
    return path;
}

- (NSString *)getWifiName {
    
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}

/**
 UUID是Universally Unique Identifier的缩写，中文意思是通用唯一识别码。它是让分布式系统中的所有元素，都能有唯一的辨识资讯，而不需要透过中央控制端来做辨识资讯的指定。这样，每个人都可以建立不与其它人冲突的 UUID。在此情况下，就不需考虑数据库建立时的名称重复问题。苹果公司建议使用UUID为应用生成唯一标识字符串。每次生成都会改变
 */
- (NSString *)getUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

/**
 iOS7及之后的系统，是没有办法获取一个类似UDID这样的能保证设备唯一的标志符的;
 钥匙串的访问需要Security.framework。钥匙串的API都比较恶心，这里推荐使用SAMKeyChain， https://github.com/soffes/SAMKeychain
 当然这也是有弊端的，比如刷机、恢复出厂设置这类会重置手机信息的，都会清空钥匙串信息，我们保存的UUID也就跟着清除了，不过苹果各种限制，我们能做到这种底部，已经很不错了！！！
 */
- (NSString *)getDeviceId {
    NSString *uuid = [YYKeychain getPasswordForService:@" " account:@"uuid"];
    
    if (uuid.length > 0) {
        //得到
//        NSLog(@"得到UUID：%@", uuid);
        
    } else {
        //没有得到
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        uuid = currentDeviceUUID.UUIDString;
        uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
        uuid = [uuid lowercaseString];
        
        if ([YYKeychain setPassword:uuid forService:@" " account:@"uuid"]) {
//            NSLog(@"UUID:%@ 保存成功", uuid);
        } else {
//            NSLog(@"UUID：%@保存失败", uuid);
        }
    }
    return uuid;
}

/** ******************************************** 网络状态部分 ************************************************** */

#pragma mark - 有网YES, 无网:NO
- (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

#pragma mark - 手机网络:YES, 反之:NO
- (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

#pragma mark - WiFi网络:YES, 反之:NO
- (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

- (NSString *)getIdfa {
    NSString *idfa = [KeyChainManager keyChainReadData:keyChainIDFA];
    if(idfa == nil) {
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [KeyChainManager keyChainSaveData:idfa withIdentifier:keyChainIDFA];
    }
    return idfa;
}

- (NSString *)getIdfv {
    NSString *idfv = [KeyChainManager keyChainReadData:keyChainIDFV];
    if(idfv == nil) {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChainManager keyChainSaveData:idfv withIdentifier:keyChainIDFV];
    }
    return idfv;
}

- (NSString *)getResolution {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat screenY = xxScreenHeight * scale;
    CGFloat screenX = xxScreenWidth * scale;
    return [NSString stringWithFormat:@"%fx%f", screenX, screenY];
}

- (NSString *)getUUIDWithoutSymbol{
    NSString *uuid = [KeyChainManager keyChainReadData:keyChainUUID];
    if(uuid == nil) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
        uuid = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [KeyChainManager keyChainSaveData:uuid withIdentifier:keyChainUUID];
        CFRelease(uuidRef);
        CFRelease(strRef);
    }
    return uuid;
}

- (NSString *)getCarrierName {
    //获取本机运营商名称
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobile = nil;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        NSLog(@"没有SIM卡");
        mobile = @"无运营商";
    } else {
        mobile = [carrier carrierName];
    }
    return mobile;
}

// 获取设备IP地址
- (NSString *)getIPAddress {
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    NSMutableArray *ips = [NSMutableArray array];
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ],*cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len;){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET)
                continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
                *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
                continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0)
                continue;
            NSString *ip = [NSString stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    for (int i=0; i < ips.count; i++)    {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@", ips.lastObject];
        }
    }
    return deviceIP;
}

-(BOOL) isWiFiOpened {
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        for(struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ){
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}


-(NSString *)getIsIpad {
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return @"NO";
    } else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return @"NO";
    } else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return @"YES";
    }
    return @"NO";
}

#pragma mark - 开始监听网络
- (void)networkStatusWithBlock:(HttpStatusBlock)networkStatus {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        });
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(HttpStatusUnknown) : nil;
                    NSLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(HttpStatusNotReachable) : nil;
                    NSLog(@"亲的网络不太稳定哦！");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(HttpStatusReachableViaWWAN) : nil;
                    NSLog(@"手机自带网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(HttpStatusReachableViaWiFi) : nil;
                    NSLog(@"WIFI");
                    break;
            }
        }];
    });
}

@end
