//
//  ASTextNode+NewTextNode.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "ASTextNode+NewTextNode.h"

@implementation ASTextNode (NewTextNode)

+ (ASTextNode *)newTextNodeTile:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor maxnumberLine:(NSUInteger)maxnumberLine lineSpace:(CGFloat)lineSpace {
    
    ASTextNode *textNode = [[ASTextNode alloc] init];
    
    textNode.maximumNumberOfLines = maxnumberLine;
    textNode.truncationMode = NSLineBreakByTruncatingTail;
    textNode.placeholderColor = ASDisplayNodeDefaultPlaceholderColor();
    
    textNode.attributedText = [NSAttributedString attributedStringWithString:title fontSize:font color:textColor lineSpace:lineSpace];
    
    return textNode;
}

@end
