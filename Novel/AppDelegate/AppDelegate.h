//
//  AppDelegate.h
//  Novel
//
//  Created by th on 2017/1/31.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 当状态栏消失后STATUS_BAR_HEIGHT = 0 */
@property (nonatomic, assign) CGFloat statusBarHeight;

//@property (nonatomic,assign)BOOL allowRotation;

@end

