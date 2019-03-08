//
//  BaseRequestApi.m
//  Novel
//
//  Created by xth on 2018/1/10.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseRequestApi.h"
#import "NetworkHeaderModel.h"

@interface BaseRequestApi()

@property (nonatomic, strong) NSDictionary *parameter;

@property (nonatomic, strong) NSString *url;

@end

@implementation BaseRequestApi

- (void)dealloc {
    [self stop];
    NSLog(@"%@ 释放了",NSStringFromClass([self class]));
}

- (instancetype)initWithParameter:(NSDictionary *)parameter url:(NSString *)url {
    if (self = [super init]) {
        _parameter = parameter;
        _url = url;
    }
    return self;
}

#pragma mark - 请求失败
- (void)requestFailedFilter {
    
}

#pragma mark - 请求成功
- (void)requestCompleteFilter {
    
}

#pragma mark - 设置超时
- (NSTimeInterval)requestTimeoutInterval {
    return 30;
}

#pragma mark - 定义返回数据格式
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

#pragma mark - 默认请求方式
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

#pragma mark - 设置post参数
- (id)requestArgument {
    if (_parameter) {
        return _parameter;
    }
    return [self modelToJSONObject];
}

#pragma mark - 设置URL 只需要指定除去域名剩余的网址信息，因为域名信息在 YTKNetworkConfig 中已经设置过了。如果地址不同，需要设置完整地址
- (NSString *)requestUrl {
    if (_url.length > 0) {
        return _url;
    }
    return @"/";
}


#pragma mark - 自定义一个头部内容

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    
    //可以自定义一个APPjson信息放在每个请求头中
    //NSString *headerString = [[[NetworkHeaderModel alloc] init] modelToJSONString];
    return @{@"User-Agent": NSStringFormat(@"YouShaQi/2.26.31 (iPhone; iOS %@; Scale/2.00)",
               [[UIDevice currentDevice] systemVersion]),
             @"X-User-Agent": @"",
             @"X-Device-Id": [kTool getUUID],
             @"Connection": @"keep-alive"
    };
}


#pragma mark - 如果是加密方式传输，自定义request
/*
- (NSURLRequest *)buildCustomUrlRequest {

}
 */

@end
