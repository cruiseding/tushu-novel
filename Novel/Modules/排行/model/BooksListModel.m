//
//  BooksListModel.m
//  Novel
//
//  Created by th on 2017/2/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BooksListModel.h"

@implementation BooksListModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"books":[BooksListItemModel class],
             };
}

@end

@implementation BooksListItemModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"books":[BooksListItemModel class],
             };
}

@end
