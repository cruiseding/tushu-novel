//
//  YYTextLayout+Tool.h
//  xx
//
//  Created by th on 2017/5/15.
//  Copyright © 2017年 th. All rights reserved.
//

#import <YYKit/YYKit.h>

@interface YYTextLayout (Tool)

/**
  返回YYTextLayout

 @param title 文字
 @param font 字体大小
 @param color 字体颜色
 @param maxSize 最大size
 @param maximumNumberOfRows 显示行数
 @param lineSpace 行间距
 @return YYTextLayout
 */
+ (nonnull YYTextLayout *)layoutWithTitle:(nonnull NSString *)title textFont:(nonnull UIFont *)font textColor:(nonnull UIColor *)color maxSize:(CGSize)maxSize maximumNumberOfRows:(NSUInteger)maximumNumberOfRows lineSpace:(CGFloat)lineSpace;


/** 返回YYTextLayout,可以设定指定范围颜色 */
+ (nonnull YYTextLayout *)layoutWithTitle:(nonnull NSString *)title textFont:(nonnull UIFont *)font textColor:(nonnull UIColor *)color maxSize:(CGSize)maxSize maximumNumberOfRows:(NSUInteger)maximumNumberOfRows lineSpace:(CGFloat)lineSpace range:(NSRange)range rangeColor:(UIColor *_Nullable)rangeColor;

@end
