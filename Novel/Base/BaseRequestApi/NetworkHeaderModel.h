//
//  NetworkHeaderModel.h
//  Novel
//
//  Created by xth on 2018/1/11.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHeaderModel : NSObject

/** 用户ID */
@property (nonatomic, copy) NSString *userid;

/** 设备号 */
@property (nonatomic, copy) NSString *imei;

/** 0未知,1安卓,2IOS */
@property (nonatomic, assign) NSInteger  os_type;

/** 当前APP版本 */
@property (nonatomic, copy) NSString *version;

/** 来源渠道 苹果使用：@"App Store" */
@property (nonatomic, copy) NSString *channel;

/** 客户端唯一标示，后台用来判断是否更换设备 */
@property (nonatomic, copy) NSString *clientId;

/** 内部维护的应用版本 随版本递增 */
@property (nonatomic, copy) NSString *versioncode;

/** 手机型号 */
@property (nonatomic, copy) NSString *mobile_model;

/** 手机品牌 */
@property (nonatomic, copy) NSString *mobile_brand;

/** 用户登录后分配的登录Token */
@property (nonatomic, copy) NSString *token;

@end
