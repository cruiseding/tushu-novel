//
//  UIButton+EnlargeTouchArea.h
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

/**
 *  设置相应区域的扩大值
 *
 *  @param top    顶部扩大值
 *  @param right  左边扩大值
 *  @param bottom 底部扩大值
 *  @param left   右边扩大值
 */
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
