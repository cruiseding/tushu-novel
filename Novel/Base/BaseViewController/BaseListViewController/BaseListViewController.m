//
//  BaseListViewController.m
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseListViewController.h"

@interface BaseListViewController ()

@end

@implementation BaseListViewController

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _initialPage = 1;
    _page = _initialPage;
    
    [self configListView];
    
    [self configListDownpullRefresh];
    
    [self configListOnpullRefresh];
}

- (void)configListView {
    
}

- (void)configListDownpullRefresh {
    
}

- (void)configListOnpullRefresh {
    
}

- (void)configCellSubViewsCallback:(id)cell
                         indexPath:(NSIndexPath *)indexPath {
    
}

- (void)requestDataWithOffset:(NSInteger)page
                      success:(void (^)(NSArray *dataArr))success
                      failure:(void (^)(NSString *msg))failure {
    
}

- (void)endRefresh {
    
}


- (void)showEmpty:(NSString *)emptyError {
    
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
