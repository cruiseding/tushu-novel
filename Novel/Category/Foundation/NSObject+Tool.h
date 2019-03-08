//
//  NSObject+Tool.h
//  xx
//
//  Created by xth on 2017/6/29.
//  Copyright © 2017年 th. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tool)

/**
 *  模型转字典
 *
 *  @return 字典
 */
- (NSDictionary *_Nullable)dictionaryFromModel;

/**
 *  带model的数组或字典转字典
 *
 *  @param object 带model的数组或字典转
 *
 *  @return 字典
 */
- (id _Nullable )idFromObject:(nonnull id)object;

@end
