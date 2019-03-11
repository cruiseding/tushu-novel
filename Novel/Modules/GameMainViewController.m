//
//  GameMainViewController.m
//  Novel
//
//  Created by mac on 2019/3/6.
//  Copyright © 2019年 th. All rights reserved.
//

#import "GameMainViewController.h"

@interface GameMainViewController() <WKNavigationDelegate>

@end

@implementation GameMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self allocWebView];
    [self.view addSubview:_webView];
    
    self.canRotate = YES;
    self.isLandscape = YES;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self loadWebSite];
}

- (void)deviceOrientationDidChange {
    if (_canRotate) {
        if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait && !_isLandscape) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
            [self orientationChange:NO];
            //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
        } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft &&_isLandscape) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
            [self orientationChange:YES];
        }
    }
}

- (void)orientationChange:(BOOL)landscapeRight {
    _canRotate = NO;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    if (landscapeRight) {
        [UIView animateWithDuration:0.2f animations:^{
            self.webView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.webView.bounds = CGRectMake(0, 0, height, width);
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.webView.transform = CGAffineTransformMakeRotation(0);
            self.webView.bounds = CGRectMake(0, 0, width, height);
        }];
    }
}

- (void)registCrossScreen {
    self.canRotate = YES;
    self.isLandscape = YES;
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//退出时显示
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //隐藏=YES,显示=NO; Animation:动画效果
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WKWebView *)allocWebView   {
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        [_webView setUserInteractionEnabled:YES];
        _webView.scrollView.bounces = NO;
        [_webView setOpaque:YES];
        self.webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)loadWebSite {
    if(_websiteUrl == nil || [_websiteUrl isEqualToString:@""]) {
        _websiteUrl = @"http://www.baidu.com";
    }
    NSURL *url = [NSURL URLWithString:_websiteUrl];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
}

#pragma mark - Delegate
#pragma mark - WKNavigation Delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request        = navigationAction.request;
    NSString     *scheme         = [request.URL scheme];
    // decode for all URL to avoid url contains some special character so that it wasn't load.
    NSString     *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"Current URL is %@",absoluteString);
    
    static NSString *endPayRedirectURL = nil;
    // Judge is whether to jump to other app.
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        if ([scheme isEqualToString:@"weixin"]) {
            // The var endPayRedirectURL was our saved origin url's redirect address. We need to load it when we return from wechat client.
            if (endPayRedirectURL) {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:endPayRedirectURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10]];
            }
        }
        
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:request.URL];
        if (canOpen) {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
