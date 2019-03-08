//
//  XXMainViewController.m
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXMainViewController.h"
#import "XXBookShelfVC.h"
#import "XXRankingVC.h"
#import "XXSearchVC.h"

@interface XXMainViewController ()

@end

@implementation XXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.preloadPolicy = WMPageControllerPreloadPolicyNever;
    self.showOnNavigationBar = YES;
    
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 20;
    self.titleColorNormal = UIColorHex(#ffffff);
    self.titleColorSelected = UIColorHex(#ffffff);
    self.progressColor = UIColorHex(#808080);
    
    self.automaticallyCalculatesItemWidths = YES;
    
    self.itemMargin = xxAdaWidth(30);
    
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    
    [self addBackItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToRankingVC) name:@"goToRankingVC" object:nil];
}

- (void)goToRankingVC {
    
    self.selectIndex = 1;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 15;
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return @"书库";
        case 1: return @"热门";
        case 2: return @"货架";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    switch (index % 3) {
        case 0: return [[XXSearchVC alloc] init];
        case 1: return [[XXRankingVC alloc] init];
        case 2: return [[XXBookShelfVC alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, self.view.width, NavigationBar_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, 0, self.view.width, self.view.height);
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
