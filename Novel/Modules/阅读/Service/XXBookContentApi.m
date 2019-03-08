//
//  XXBookContentApi.m
//  Novel
//
//  Created by app on 2018/1/20.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookContentApi.h"

@implementation XXBookContentApi

- (BOOL)useCDN {
    return YES;
}

- (id)jsonValidator {
    return @{@"chapter": [NSObject class]};
}

@end
