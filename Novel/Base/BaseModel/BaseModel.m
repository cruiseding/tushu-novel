//
//  BaseModel.m
//  TeamRight
//
//  Created by xth on 2016/11/24.
//  Copyright © 2016年 TeamRight. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)dealloc {
//    NSLog(@"%@ 这个类被强暴了",NSStringFromClass([self class]));
    
}

+ (BOOL)encodeModel:(id)model key:(NSString *)key {
    
    NSString *path = [[self class] getPathWithKey:key];
    return [NSKeyedArchiver archiveRootObject:model toFile:path];
}

+ (id)decodeModelWithKey:(NSString *)key {
    NSString *path = [[self class] getPathWithKey:key];
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return model;
}

+ (BOOL)encodeModelArray:(NSArray *)array key:(NSString *)key {
    
    NSString *path = [[self class] getPathWithKey:[NSString stringWithFormat:@"array%@",key]];
    return [NSKeyedArchiver archiveRootObject:array toFile:path];
}

+ (NSMutableArray *)dcodeModelArrayWithKey:(NSString *)key {
    NSString *path = [[self class] getPathWithKey:[NSString stringWithFormat:@"array%@",key]];
    id models = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObjectsFromArray:models];
    return array;
}

+ (NSString *)getPathWithKey:(NSString *)key {
    NSString *documentPath = [NSString documentFolder];
    NSString *path = [NSString stringWithFormat:@"%@/%@%@.data",documentPath,NSStringFromClass([self class]),key];
    return path;
}

YYModelSynthCoderAndHash
@end
