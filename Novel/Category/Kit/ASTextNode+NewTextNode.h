//
//  ASTextNode+NewTextNode.h
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASTextNode (NewTextNode)

+ (ASTextNode *)newTextNodeTile:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor maxnumberLine:(NSUInteger)maxnumberLine lineSpace:(CGFloat)lineSpace;

@end
