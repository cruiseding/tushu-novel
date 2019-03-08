//
//  XXSummaryVC.m
//  Novel
//
//  Created by app on 2018/1/25.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXSummaryVC.h"
#import "XXSummaryCell.h"

@interface XXSummaryVC ()

@end

@implementation XXSummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupEstimatedRowHeight:50 registerCell:[XXSummaryCell class]];
    
    [self requestDataWithShowLoading:YES];
}

- (void)configListView {
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.00];
    [self.view addSubview:navView];
    
    UILabel *titleLabel = [UILabel newLabel:@"选择来源" andTextColor:kwhiteColor andFontSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"sm_exit"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"sm_exit_selected"] forState:UIControlStateSelected];
    [navView addSubview:closeBtn];
    
    xxWeakify(self)
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself go2Back];
    }];
    
    //约束
    
    CGFloat navHeight = kAppDelegate.statusBarHeight + NavigationBar_HEIGHT;
    CGFloat leftX = xxAdaWidth(15.f);
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(navHeight);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_top).offset(kAppDelegate.statusBarHeight);
        make.right.mas_equalTo(navView.mas_right).offset(-leftX);
        make.size.mas_equalTo(CGSizeMake(NavigationBar_HEIGHT, NavigationBar_HEIGHT));
    }];
    [closeBtn setEnlargeEdgeWithTop:0 right:leftX bottom:0 left:leftX];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeBtn);
        make.centerX.equalTo(navView);
    }];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)configListOnpullRefresh {
    
}

- (void)configListDownpullRefresh {
    
}

- (void)requestDataWithOffset:(NSInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    
    XXSummaryApi *api = [[XXSummaryApi alloc] initWithParameter:nil url:URL_summary(kReadingManager.bookId)];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSArray *response = [NSArray modelArrayWithClass:[SummaryModel class] json:request.responseObject];
        
        NSMutableArray *datas = @[].mutableCopy;
        
        BOOL isFirst = YES;
        
        for (SummaryModel *model in response) {
            //去掉追书的vip源，你懂得
            if (!model.starting) {
                
                if (kReadingManager.summaryId.length > 0 && [model._id isEqualToString:kReadingManager.summaryId]) {
                    model.isSelect = YES;
                    isFirst = NO;
                }
                
                [datas addObject:model];
            }
        }
        
        if (isFirst && datas.count > 0) {
            SummaryModel *model = [datas firstObject];
            model.isSelect = YES;
        }
        
        success(datas);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure([request.error localizedDescription]);
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SummaryModel *model = self.datas[indexPath.row];
    
    if (model.isSelect) {
        [HUD showMsgWithoutView:@"请选择其他源哦！"];
    } else {
        if (_selectedSummaryBlock) {
            _selectedSummaryBlock(model._id);
        }
        [self go2Back];
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
