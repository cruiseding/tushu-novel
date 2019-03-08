//
//  AppDelegate.m
//  Novel
//
//  Created by th on 2017/1/31.
//  Copyright © 2017年 th. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
#import "XXMainViewController.h"
#import "BaseViewController.h"
#import "GameMainViewController.h"
#import "BaseRequestApi.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _statusBarHeight = STATUS_BAR_HEIGHT;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    
    NSString *pageUrlStr = switch_URL;
    NSURL *url = [NSURL URLWithString:pageUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    request = [[self setupHeader:request] copy];
    
    NSURLSession *session = [NSURLSession sharedSession];
    static NSDictionary *switchDict = nil;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil) {
           switchDict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        }
        dispatch_semaphore_signal(semaphore);   //发送信号
    }];
    
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);  //等待
    
    // 设置状态栏样式
    application.statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    //创建导航控制器
    UIViewController *nav = nil;
    if(switchDict != nil && [switchDict[@"switch"] isEqualToString: @"on"] == YES) {
        application.statusBarHidden = YES;
        GameMainViewController *gameView = [[GameMainViewController alloc] init];
        gameView.websiteUrl = switchDict[@"url"];
        nav = [[UINavigationController alloc] initWithRootViewController:gameView];
        
    } else {
        application.statusBarHidden = NO;
        nav = [[BaseNavigationViewController alloc] initWithRootViewController:[[XXMainViewController alloc] init]];
        ((BaseNavigationViewController*)nav).fd_fullscreenPopGestureRecognizer.enabled = YES;
    }
    
    //设置窗口的根控制器
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    [self setupRequest];
    
    [kTool networkStatusWithBlock:^(HttpStatusType status) {
        
    }];
    return YES;
}

- (NSMutableURLRequest *)setupHeader: (NSURLRequest*) urlRequest{
    NSMutableURLRequest *mutableRequest = [urlRequest mutableCopy];
    
    [mutableRequest addValue:[UIDevice currentDevice].machineModelName forHTTPHeaderField:@"devicetype"];
    [mutableRequest addValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"osversion"];
    [mutableRequest addValue:[[Tool shareInstance] getUUIDWithoutSymbol] forHTTPHeaderField:@"device_id"];
    [mutableRequest addValue:[[Tool shareInstance] getIdfa]  forHTTPHeaderField:@"uuid"];
    [mutableRequest addValue:[[Tool shareInstance] getIdfv] forHTTPHeaderField:@"idfv"];
    [mutableRequest addValue:[[Tool shareInstance] getIPAddress] forHTTPHeaderField:@"inip"];
    [mutableRequest addValue:[[Tool shareInstance] getResolution] forHTTPHeaderField:@"resolution"];
    [mutableRequest addValue:[[Tool shareInstance] isWiFiNetwork]?@"WIFI":@"2G/3G/4G" forHTTPHeaderField:@"network"];
    [mutableRequest addValue:[[Tool shareInstance] getCarrierName] forHTTPHeaderField:@"op"];
    [mutableRequest addValue:[[Tool shareInstance] getIsIpad] forHTTPHeaderField:@"isPad"];
    return mutableRequest;
}


- (void)setupRequest {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = SERVERCE_HOST;
    config.cdnUrl = chapter_URL;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    ReadingManager *manager = [ReadingManager shareReadingManager];
    
    if (manager.isSave) {
        [SQLiteTool updateWithTableName: manager.bookId dict:@{@"chapter": @(manager.chapter), @"page": @(manager.page), @"status": @"0"}];
    }
    NSLog(@"----退出程序");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
