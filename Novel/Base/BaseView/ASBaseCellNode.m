//
//  ASBaseCellNode.m
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import "ASBaseCellNode.h"

@implementation ASBaseCellNode

- (instancetype)initWithModel:(id)model {
    if (self = [super init]) {
        self.model = model;
        [self setupNodes];
    }
    return self;
}

- (void)setupNodes {
    
    
}

- (void)dealloc {
    NSLog(@"%@ 释放了",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
