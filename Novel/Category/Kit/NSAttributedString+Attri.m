//
//  NSAttributedString+Attri.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "NSAttributedString+Attri.h"

@implementation NSAttributedString (Attri)

+ (NSAttributedString *)attributedStringWithString:(NSString *)string fontSize:(CGFloat)size color:(nullable UIColor *)color lineSpace:(CGFloat)lineSpace {
    
    if (string == nil) {
        return nil;
    }
    
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:string];
    attributes.font = fontSize(size);
    attributes.color = color ? color : [UIColor blackColor];
    attributes.lineSpacing = lineSpace ? lineSpace : 2;
    
    return attributes;
}

@end
