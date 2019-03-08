//
//  YYLabel+Tool.h
//  xx
//
//  Created by th on 2017/4/23.
//  Copyright © 2017年 th. All rights reserved.
//

#import <YYKit/YYKit.h>

@interface YYLabel (Tool)

/**
 创建一个使用textLayout布局的label

 @return yyLabel
 */
+ (YYLabel *_Nullable)newYYLabel;

/**
 返回一个已经计算好frame的YYLabel
 
 @param frame frame
 @param font 字体大小
 @param color 字体颜色
 @return YYLabel
 */
+ (YYLabel *_Nonnull)labelWithFrame:(CGRect)frame textFont:(CGFloat)font textColor:(UIColor *_Nullable)color;


/**
 返回一个数组，元素为label每行的文字
 
 @param label 传入label
 @return 数组
 */
+ (nullable NSArray *)getLinesArrayOfStringInLabel:(nonnull YYLabel *)label;

@end
