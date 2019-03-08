//
//  KPageViewController.h
//  Novel
//
//  Created by th on 2017/3/5.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KPageViewController;

@protocol KPageViewControllerDelegate <NSObject>

@optional


/**
 *  切换是否完成
 *
 *  @param coverController   coverController
 *  @param currentController 当前正在显示的控制器
 *  @param isFinish          切换是否成功
 */
- (void)coverController:(KPageViewController * _Nonnull)coverController currentController:(UIViewController * _Nullable)currentController finish:(BOOL)isFinish;

/**
 *  获取上一个控制器
 *
 *  @param coverController   coverController
 *  @param currentController 当前正在显示的控制器
 *
 *  @return 返回当前显示控制器的上一个控制器
 */
- (UIViewController * _Nullable)coverController:(KPageViewController * _Nonnull)coverController getAboveControllerWithCurrentController:(UIViewController * _Nullable)currentController;

/**
 *  获取下一个控制器
 *
 *  @param coverController   coverController
 *  @param currentController 当前正在显示的控制器
 *
 *  @return 返回当前显示控制器的下一个控制器
 */
- (UIViewController * _Nullable)coverController:(KPageViewController * _Nonnull)coverController getBelowControllerWithCurrentController:(UIViewController * _Nullable)currentController;


/**
 单击中间部分，作为呼出和隐藏菜单
 */
- (void)KPageViewControllerTapWithMenu;

@end

@interface KPageViewController : UIViewController

/**
 *  代理
 */
@property (nonatomic,weak,nullable) id<KPageViewControllerDelegate> delegate;

/**
 *  手势启用状态 default:YES
 */
@property (nonatomic,assign) BOOL gestureRecognizerEnabled;

/**
 *  当前手势操作是否带动画效果 default: YES
 */
@property (nonatomic,assign) BOOL openAnimate;

/**
 *  正在动画 default:NO
 */
@property (nonatomic,assign) BOOL isAnimateChange;

/**
 *  当前控制器
 */
@property (nonatomic,strong,readonly,nullable) UIViewController *currentController;

/**
 *  手动设置显示控制器 无动画
 *
 *  @param controller 设置显示的控制器
 */
- (void)setController:(UIViewController * _Nonnull)controller;

/**
 *  手动设置显示控制器
 *
 *  @param controller 设置显示的控制器
 *  @param animated   是否需要动画
 *  @param isAbove    动画是否从上面显示 YES   从下面显示 NO
 */
- (void)setController:(UIViewController * _Nonnull)controller animated:(BOOL)animated isAbove:(BOOL)isAbove;

@end
