//
//  RankingModel.m
//  Novel
//
//  Created by th on 2017/2/2.
//  Copyright © 2017年 th. All rights reserved.
//

#import "RankingModel.h"

@implementation RankingModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"male": [RankingDeModel class],
             @"female": [RankingDeModel class],
             @"epub": [RankingDeModel class]
             };
}

@end

@implementation RankingDeModel

+ (instancetype)modelWithTitle:(NSString *)title {
    RankingDeModel *model = [RankingDeModel new];
    model.title = title;
    model.collapse = false;
    model.isMoreItem = YES;
    return model;
}

@end
