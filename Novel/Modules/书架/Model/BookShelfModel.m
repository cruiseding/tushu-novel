//
//  BookShelfModel.m
//  Novel
//
//  Created by th on 2017/3/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BookShelfModel.h"

@implementation BookShelfModel

/**
 拼接的id，eg：5816b415b06d1d32157790b1,5816b415b06d1d32157790b1
 */
+ (NSString *)componentsJoineWithArrID:(NSArray *)array {
    
    if (!IsEmpty(array)) {
        NSMutableArray *temps = @[].mutableCopy;
        for (BookShelfModel *model in array) {
            [temps addObject:model.id];
        }
        return [temps componentsJoinedByString:@","];
    } else {
        return @"";
    }
}

@end
