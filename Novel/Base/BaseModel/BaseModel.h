//
//  BaseModel.h
//  TeamRight
//
//  Created by xth on 2016/11/24.
//  Copyright © 2016年 TeamRight. All rights reserved.
//
#import "NSString+Tools.h"
#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<YYModel>

/**
 *  将一个模型归档
 *
 *  @param model 模型 如model== nil 即将原来保存的删除
 *  @param key   key
 *
 *  @return 是否归档成功
 */
+ (BOOL)encodeModel:(id)model key:(NSString *)key;

/**
 *  根据关键字解归档某个模型
 *
 *  @param key 关键字
 *
 *  @return 模型
 */
+ (id)decodeModelWithKey:(NSString *)key;


/**
 *  把一个数组的模型归档
 *
 *  @param array 如 array == nil 即将原来保存的删除
 *  @param key   key
 *
 *  @return 是否归档成功
 */
+ (BOOL)encodeModelArray:(NSArray *)array key:(NSString *)key;

/**
 *  解归档一个数组的模型
 *
 *  @return 模型数组
 */
+ (NSMutableArray *)dcodeModelArrayWithKey:(NSString *)key;


@end
