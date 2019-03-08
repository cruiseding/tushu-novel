//
//  UIView+NewLine.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "UIView+NewLine.h"

@implementation UIView (NewLine)


+ (UIView *)newLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = klineColor;
    return line;
}

@end
