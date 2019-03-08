//
//  BookChapterModel.m
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BookChapterModel.h"

@interface BookChapterModel()

@property (nonatomic, strong) NSMutableAttributedString *attributedString;

@end

@implementation BookChapterModel

/** 换行\t制表符，缩进 */
- (NSString *)adjustParagraphFormat:(NSString *)string {
    if (!string) {
        return nil;
    }
    string = [@"\t" stringByAppendingString:string];
//    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n　　"];
    return string;
}

#pragma mark - 画出某章节某页的范围
- (void)pagingWithBounds:(CGRect)bounds WithFont:(UIFont *)font {
    
    self.pageDatas = @[].mutableCopy;
    
    if (!self.body) {
        self.body = @"内容出错，请跳过本章!";
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.body];
    attr.font = font;
    attr.color = kblackColor;
    
    // 设置label的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:xxAdaWidth(9)];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.body length])];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attr);
    
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    
    CFRange range = CFRangeMake(0, 0);
    
    NSUInteger rangeOffset = 0;
    
    do {
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, NULL);
        
        range = CTFrameGetVisibleStringRange(frame);
        
        rangeOffset += range.length;
        
        //range.location
        [self.pageDatas addObject:@(range.location)];
        
        if (frame) {
            CFRelease(frame);
        }
    } while (range.location + range.length < attr.length);
    
    if (path) {
        CFRelease(path);
    }
    
    if (frameSetter) {
        CFRelease(frameSetter);
    }
    
    self.pageCount = self.pageDatas.count;
    
    self.attributedString = attr;
}

#pragma mark - 获取某章节某一页的内容
- (NSAttributedString *)getStringWithpage:(NSInteger)page {
    if (page < self.pageDatas.count) {
        
        NSUInteger loc = [self.pageDatas[page] integerValue];
        
        NSUInteger len = 0;
        
        if (page == self.pageDatas.count - 1) {
            len = self.attributedString.length - loc;
        } else {
            len = [self.pageDatas[page + 1] integerValue] - loc;
        }
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:[self.attributedString attributedSubstringFromRange:NSMakeRange(loc, len)]];
        
        if (kReadingManager.bgColor == 5) {
            text.color = kwhiteColor;
        } else {
            text.color = kblackColor;
        }
        
        //        return [_content substringWithRange:NSMakeRange(loc, len)];
        return text;
    }
    
    return [[NSAttributedString alloc] init];
}

@end



@implementation BookSettingModel


@end
