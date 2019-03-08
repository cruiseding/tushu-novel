//
//  XXHighLightButton.m
//  Novel
//
//  Created by app on 2018/1/17.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXHighLightButton.h"

@interface XXHighLightButton()


@end

@implementation XXHighLightButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = self.highlightedColor ? self.highlightedColor : [UIColor colorWithWhite:0.97 alpha:1];
        
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.backgroundColor = nil;
        });
    }
}

- (void)setHighlightedColor:(UIColor *)highlightedColor {
    _highlightedColor = highlightedColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
