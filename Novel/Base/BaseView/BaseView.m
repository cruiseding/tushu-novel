//
//  BaseView.m
//  Novel
//
//  Created by app on 2018/1/19.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
        [self setupLayout];
        [self configEvent];
    }
    return self;
}

- (void)setupViews {
    
}

- (void)setupLayout {
    
}

- (void)configEvent {
    
}

- (void)configWithModel:(id)model {
    
}

- (void)dealloc {
    NSLog(@"%@ 释放了",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
