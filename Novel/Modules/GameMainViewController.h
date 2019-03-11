//
//  GameMainViewController.h
//  Novel
//
//  Created by mac on 2019/3/6.
//  Copyright © 2019年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface GameMainViewController : BaseViewController

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSString *websiteUrl;

@property (nonatomic, assign) BOOL canRotate;

@property (nonatomic, assign) BOOL isLandscape;

@end
