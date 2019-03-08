//
//  XXBookListMainVC.m
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookListMainVC.h"

@interface XXBookListMainVC ()

@end

@implementation XXBookListMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //关闭预加载
    self.preloadPolicy = WMPageControllerPreloadPolicyNever;
    
    self.titleSizeNormal = 14;
    self.titleSizeSelected = 16;
    self.titleColorNormal = knormalColor;
    self.titleColorSelected = knormalColor;
    self.menuItemWidth = self.view.width / 3;
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    
    [self addBackItem];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return @"周榜";
        case 1: return @"月榜";
        case 2: return @"总榜";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    XXBookListVC *vc = [[XXBookListVC alloc] init];
    vc.booklist_type = _booklist_type;
    
    switch (index % 3) {
        case 0:
            vc.title = @"周榜";
            vc.id = _id;
            break;
            
        case 1:
            vc.title = @"月榜";
            vc.id = _monthRank;
            break;
            
        case 2:
            vc.title = @"总榜";
            vc.id = _totalRank;
            break;
            
        default:
            break;
    }
    
    return vc;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = UIColorHex(#ecf0f6);
    return CGRectMake(0, 0, self.view.width, xxAdaWidth(40));
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.width, self.view.height - originY);
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
