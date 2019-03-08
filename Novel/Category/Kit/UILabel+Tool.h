//
//  UILabel+Tool.h
//  xx
//
//  Created by th on 2017/4/23.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Tool)

+ (UILabel *)newLabel:(NSString *)text andTextColor:(UIColor *)color andFontSize:(CGFloat)size;

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
