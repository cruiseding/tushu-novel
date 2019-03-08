//
//  BookDetailModel.m
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BookDetailModel.h"

@implementation BookDetailModel

- (NSString *)getBookWordCount {
    NSString *unit = nil;
    double number = 0;
    if (self.wordCount > 10000) {
        number = self.wordCount / 10000;
        unit = @"万";
    } else if (self.wordCount > 1000) {
        number = self.wordCount / 1000;
        unit = @"万";
    } else {
        number = self.wordCount;
        unit = @"";
    }
    return [NSString stringWithFormat:@"%.f %@字",number,unit];
}

@end
