//
//  BaseViewController.m
//  Novel
//
//  Created by xth on 2017/7/15.
//  Copyright © 2017年 th. All rights reserved.
//

#pragma mark - UIViewController

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

/*
 在info.plist文件中 View controller-based status bar appearance
 -> YES，则控制器对状态栏设置的优先级高于application
 -> NO，则以application为准，控制器设置状态栏-(UIStatusBarStyle)preferredStatusBarStyle - (BOOL)prefersStatusBarHidden 是无效的的根本不会被调用
 */

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ 释放了",NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //更新视图信息。
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //执行行为，比如运行动画效果。
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //是否需要横屏
//    self.bl_shouldAutoLandscape = YES;
    
    //UIBarStyleDefault 默认黑色
    //UIBarStyleBlack 白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = KbackgroundColor;
    
    [self addBackItem];
    
    [self setupViews];
    
    [self setupLayout];
    
    [self onLoadDataByRequest];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationChange:)
                                                name:UIDeviceOrientationDidChangeNotification object:nil];
}

//创建UI
-(void)setupViews {
    
}

//UI布局
-(void)setupLayout {
    
}

- (void)onLoadDataByRequest {
    
}

- (void)requestDataWithShowLoading:(BOOL)show {
    if (show) {
        [HUD showProgressCircleNoValue:nil inView:self.view];
    }
}

//设备方向改变的处理
- (void)handleDeviceOrientationChange:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置");
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            
            break;
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
        default:
            NSLog(@"无法辨识");
            break;
    }
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
