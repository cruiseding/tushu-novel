//
//  UITextField+Tool.m
//  xx
//
//  Created by th on 2017/5/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "UITextField+Tool.h"

@implementation UITextField (Tool)


- (void)setLeftViewAtImageName:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    float x = 0;
    float y = 0;
    float height = image.size.height;
    float width = image.size.width + 20.0;
    UIImageView *leftView = [[UIImageView alloc]initWithImage:image];
    leftView.frame = CGRectMake(x, y, width, height);
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
}


- (void)addLeftSpace:(float)space {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, space, self.height)];
    self.leftView = view;
    
    self.leftViewMode = UITextFieldViewModeAlways;
}


- (void)setPlaceholderColor:(UIColor *)color {
    if (color) {
        
        [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    }
}

- (void)setPlaceholderFont:(UIFont *)font {
    if (font) {
        
        [self setValue:font forKeyPath:@"_placeholderLabel.font"];
        
    }
}


@end
