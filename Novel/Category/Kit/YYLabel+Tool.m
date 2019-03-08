//
//  YYLabel+Tool.m
//  xx
//
//  Created by th on 2017/4/23.
//  Copyright © 2017年 th. All rights reserved.
//

#import "YYLabel+Tool.h"

@implementation YYLabel (Tool)

+ (YYLabel *)newYYLabel {
    
    YYLabel *label = [YYLabel new];
    label.ignoreCommonProperties = YES;
    label.displaysAsynchronously = YES;
    label.fadeOnHighlight = NO;
    label.fadeOnAsynchronouslyDisplay = NO;
    
    return label;
}

+ (YYLabel *_Nonnull)labelWithFrame:(CGRect)frame textFont:(CGFloat)font textColor:(UIColor *_Nullable)color {
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:frame];
    
    label.font = fontSize(font);
    
    label.displaysAsynchronously = YES;
    //    label.ignoreCommonProperties = YES;这里不能为yes,因为这里不用textLayout布局
    label.fadeOnHighlight = NO;
    label.fadeOnAsynchronouslyDisplay = NO;
    
    
    if (!color) {
        label.textColor = kblackColor;
    } else {
        label.textColor = color;
    }
    
    return label;
}

#pragma mark - 计算label中的行数和 每一行的内容
+ (NSArray *)getLinesArrayOfStringInLabel:(YYLabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

@end
