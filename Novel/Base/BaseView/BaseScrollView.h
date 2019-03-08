//
//  xxBaseSctrollView.h
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface BaseScrollView : TPKeyboardAvoidingScrollView <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *contentView;

- (void)setupViews;

- (void)setupLayout;

- (void)configEvent;

- (void)configWithModel:(id)model;

/**
 显示空视图

 @param error <#error description#>
 */
- (void)showEmptyError:(NSString *)error;

/**
 移除空视图
 */
- (void)removeEmpty;

/** 重新点击空视图发出信号 */
@property (nonatomic, strong) RACSubject *refreshDelegate;

@end
