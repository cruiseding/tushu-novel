//
//  UIViewController+Nav.m
//  Novel
//
//  Created by app on 2018/1/17.
//  Copyright © 2018年 th. All rights reserved.
//

#import "UIViewController+Nav.h"

@implementation UIViewController (Nav)

- (void)addBackItem {
    
    [self.navigationController.navigationBar setBackIndicatorImage:[[UIImage imageNamed:@"backTo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"backTo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)go2Back {
    if (self.navigationController) {
        if ([self.navigationController viewControllers].count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
