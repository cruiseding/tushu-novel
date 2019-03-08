//
//  BaseViewController.h
//  Novel
//
//  Created by xth on 2017/7/15.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BackButtonHandler.h"

/**
 *  根视图控制器类，一切普通视图控制器都继承此类。
 */
@interface BaseViewController : ASViewController


//- (BOOL)navigationShouldPopOnBackButton 可以拦截系统的返回事件

/**
 创建UI
 */
- (void)setupViews;

/**
 UI布局
 */
- (void)setupLayout;

/**
 开始网络请求
 */
- (void)onLoadDataByRequest;


/**
 开始网络请求

 @param show 是否显示加载菊花
 */
- (void)requestDataWithShowLoading:(BOOL)show;


@property (nonatomic, copy) NSString *emptyError;

@end
