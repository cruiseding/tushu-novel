//
//  NSAttributedString+Attri.h
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Attri)

+ (NSAttributedString *_Nullable)attributedStringWithString:(NSString *_Nullable)string fontSize:(CGFloat)size color:(nullable UIColor *)color lineSpace:(CGFloat)lineSpace;

@end
