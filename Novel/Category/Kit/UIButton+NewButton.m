
//
//  UIButton+NewButton.m
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import "UIButton+NewButton.h"

@implementation UIButton (NewButton)

+ (UIButton *)newButtonTitle:(NSString *)title font:(CGFloat)fontSize normarlColor:(UIColor *)normalColor {
    
    UIButton *button = [[UIButton alloc] init];
    
    if (title.length > 0) {
        [button setTitle:title forState:0];
    }
    
    if (normalColor) {
        [button setTitleColor:normalColor forState:0];
    }
    
    button.titleLabel.font = fontSize(fontSize);
    
    return button;
}

@end
