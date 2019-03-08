//
//  UIControl+Tool.h
//  xx
//
//  Created by xth on 2017/6/15.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Tool)

/** 事件点击的间隔 */
@property (nonatomic, assign) NSTimeInterval eventInterval;


@property (nonatomic, assign) BOOL ignoreEvent;

@end
