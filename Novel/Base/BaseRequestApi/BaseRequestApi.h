//
//  BaseRequestApi.h
//  Novel
//
//  Created by xth on 2018/1/10.
//  Copyright © 2018年 th. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface BaseRequestApi : YTKRequest

- (instancetype)initWithParameter:(NSDictionary *)parameter url:(NSString *)url;

@end
