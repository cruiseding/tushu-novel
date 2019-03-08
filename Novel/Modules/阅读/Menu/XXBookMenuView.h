//
//  XXBookMenuView.h
//  Novel
//
//  Created by app on 2018/1/19.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseView.h"
#import "XXBookSettingView.h"

typedef NS_ENUM(NSUInteger, kBookMenuType) {
    kBookMenuType_source = 0, //换源头
    kBookMenuType_close = 1, //关闭
    kBookMenuType_day = 2, //白天或者黑夜
    kBookMenuType_feedBack = 3, //反馈
    kBookMenuType_directory = 4, //目录
    kBookMenuType_down = 5, //下载
    kBookMenuType_setting = 6, //设置
};

@interface XXBookMenuView : BaseView

@property (nonatomic, strong) RACSubject *delegate;

/** 设置 */
@property (nonatomic, strong, readonly) XXBookSettingView *settingView;

/**
 弹出或者隐藏menu
 
 @param duration 动画时间
 @param completion 完成回调
 */
- (void)showMenuWithDuration:(CGFloat)duration completion:(void(^)())completion;

/**
 显示小说标题和链接
 
 @param title <#title description#>
 @param link <#link description#>
 */
- (void)showTitle:(NSString *)title bookLink:(NSString *)link;


/**
 显示或者隐藏设置view
 */
- (void)showOrHiddenSettingView;


/**
 白天和黑夜的切换
 */
- (void)changeDayAndNight;

@end
