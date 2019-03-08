//
//  NSDictionary+Tools.m
//  Novel
//
//  Created by th on 2017/3/14.
//  Copyright © 2017年 th. All rights reserved.
//

#import "NSDictionary+Tools.h"
#import <objc/runtime.h>

@implementation NSDictionary (Tools)

- (NSString *)stringForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    return @"";
}


@end
