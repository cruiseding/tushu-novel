//
//  BaseNavigationViewController.m
//  Novel
//
//  Created by xth on 2017/7/15.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "XXBookReadingVC.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

+ (void)initialize {
    //导航栏
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"mainNavgationBg"] forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    // 设置标题样式
    [bar setTitleTextAttributes:attr];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置导航栏上面的item 的 字体属性
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    
    // 设置返回按钮的图片或者标题的颜色
    bar.tintColor = [UIColor whiteColor];
}

/**
 *  重写这个方法，能拦截所有的Push操作
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
