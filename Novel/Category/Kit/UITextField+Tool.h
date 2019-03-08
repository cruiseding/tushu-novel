//
//  UITextField+Tool.h
//  xx
//
//  Created by th on 2017/5/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Tool)


/**
 设置UITextField左边视图的图片

 @param imageName 图片名称
 */
- (void)setLeftViewAtImageName:(NSString *)imageName;

/**
 UITextField 文字距离左边的距离

 @param space 距离
 */
- (void)addLeftSpace:(float)space;

/**
 *  placeholder字体颜色
 *
 *  @param color 颜色
 */
- (void)setPlaceholderColor:(UIColor *)color;

/**
 *  placeholder字体大小
 *
 *  @param font 字体
 */
- (void)setPlaceholderFont:(UIFont *)font;

@end
