//
//  NetworkHeaderModel.m
//  Novel
//
//  Created by xth on 2018/1/11.
//  Copyright © 2018年 th. All rights reserved.
//

#import "NetworkHeaderModel.h"

@implementation NetworkHeaderModel

- (instancetype)init {
    if (self = [super init]) {
        self.userid = @"888888";
        self.imei = [kTool getDeviceId];
        self.os_type = 2;
        self.version = kApplication.appVersion;
        self.channel = @"App Store";
        self.clientId = self.imei;
        self.versioncode = kApplication.appBuildVersion;
        self.mobile_model = [UIDevice currentDevice].machineModelName;
        self.mobile_brand = [UIDevice currentDevice].machineModel;
    }
    return self;
}

@end
