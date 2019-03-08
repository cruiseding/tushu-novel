
//
//  XXRankingVC.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXRankingVC.h"
#import "XXRandingApi.h"
#import "XXRankingCell.h"
#import "RankingModel.h"
#import "XXBookListMainVC.h"

@interface XXRankingVC ()

/** 组 */
@property (nonatomic, strong) NSMutableArray *groups;

/** 男生☞别人家的排行榜 */
@property (nonatomic, strong) NSMutableArray *maleMoreArr;

/** 女生☞别人家的排行榜 */
@property (nonatomic, strong) NSMutableArray *femaleMoreArr;

/** 是否已经展开 */
@property (nonatomic, assign) BOOL is_maleShow;

/** 是否已经展开 */
@property (nonatomic, assign) BOOL is_femaleShow;


@end

@implementation XXRankingVC

- (instancetype)init {
    if (self) {
        [self initTableViewStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _groups = [[NSMutableArray alloc] init];
    _maleMoreArr = [[NSMutableArray alloc] init];
    _femaleMoreArr = [[NSMutableArray alloc] init];
    
    [self setupEstimatedRowHeight:xxAdaWidth(54) registerCell:[XXRankingCell class]];
    
    [self requestDataWithShowLoading:YES];
}


- (void)configListOnpullRefresh {
    
}


- (void)requestDataWithOffset:(NSInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    
    XXRandingApi *api = [[XXRandingApi alloc] initWithParameter:@{@"timestamp": [DateTools getTimeInterval],@"platform": @"ios"} url:URL_ranking_gender];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        self.is_maleShow = NO;
        self.is_femaleShow = NO;
        
        [self.maleMoreArr removeAllObjects];
        [self.femaleMoreArr removeAllObjects];
        [self.groups removeAllObjects];
        
        NSMutableArray *maleArr = [[NSMutableArray alloc] init];
        NSMutableArray *femaleArr = [[NSMutableArray alloc] init];
        NSMutableArray *epubArr = [[NSMutableArray alloc] init];
        
        RankingModel *model = [RankingModel modelWithDictionary:request.responseObject];
        
        for (RankingDeModel *m in model.male) {
            if (!m.collapse) {
                m.cover = [NSString stringWithFormat:@"%@%@",statics_URL,m.cover];
                [maleArr addObject:m];
            } else {
                m.cover = nil;
                [self.maleMoreArr addObject:m];
            }
        }
        
        for (RankingDeModel *m in model.female) {
            if (!m.collapse) {
                m.cover = [NSString stringWithFormat:@"%@%@",statics_URL,m.cover];
                [femaleArr addObject:m];
            } else {
                m.cover = nil;
                [self.femaleMoreArr addObject:m];
            }
        }
        
        for (RankingDeModel *m in model.epub) {
            if (!m.collapse) {
                m.cover = [NSString stringWithFormat:@"%@%@",statics_URL,m.cover];
                [epubArr addObject:m];
            }
        }
        
        [maleArr addObject:[RankingDeModel modelWithTitle:@"别人家的排行榜"]];
        [femaleArr addObject:[RankingDeModel modelWithTitle:@"别人家的排行榜"]];
        
        [self.groups addObject:maleArr];
        [self.groups addObject:femaleArr];
        [self.groups addObject:epubArr];
        
        [self endRefresh];
        [self.tableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure([request.error localizedDescription]);
    }];
}


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_groups[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XXRankingCell class])];
    
    [cell configWithModel:_groups[indexPath.section][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([XXRankingCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell configWithModel:_groups[indexPath.section][indexPath.row]];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(kCellX, 0, kScreenWidth - kCellX, 44)];
    
    label.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.00];
    
    label.font = fontSize(12);
    
    if (section == 0) {
        label.text = @"男生";
    } else if (section == 1) {
        label.text = @"女生";
    } else {
        label.text = @"其他";
    }
    
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return xxAdaWidth(44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return MINFLOAT;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RankingDeModel *model = _groups[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (model.isMoreItem) {
            
            NSInteger count = ((NSArray *)_groups[indexPath.section]).count;
            
            if (indexPath.section == 0 && _is_maleShow == NO) {
                
                _is_maleShow = YES;
                
                [self updateTableViewWithDatasCount:count arrayForMore:_maleMoreArr indexPath:indexPath tableViewOperationType:kRankingOperation_insert];
                
            } else if (indexPath.section == 0 && _is_maleShow == YES) {
                
                _is_maleShow = NO;
                
                [self updateTableViewWithDatasCount:count arrayForMore:_maleMoreArr indexPath:indexPath tableViewOperationType:kRankingOperation_delete];
                
            } else if (indexPath.section == 1 && _is_femaleShow == NO) {
                
                _is_femaleShow = YES;
                
                [self updateTableViewWithDatasCount:count arrayForMore:_femaleMoreArr indexPath:indexPath tableViewOperationType:kRankingOperation_insert];
                
            } else if (indexPath.section == 1 && _is_femaleShow == YES) {
                _is_femaleShow = NO;
                
                [self updateTableViewWithDatasCount:count arrayForMore:_femaleMoreArr indexPath:indexPath tableViewOperationType:kRankingOperation_delete];
            }
        } else {
            
            if (!model.collapse) {
                XXBookListMainVC *vc = [[XXBookListMainVC alloc] init];
                
                vc.title = model.title;
                vc.id = model._id;
                vc.monthRank = model.monthRank;
                vc.totalRank = model.totalRank;
                vc.booklist_type = kBookListType_rank;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                XXBookListVC *vc = [[XXBookListVC alloc] init];
                vc.title = model.title;
                vc.id = model._id;
                vc.booklist_type = kBookListType_rank;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
        XXBookListVC *vc = [[XXBookListVC alloc] init];
        vc.title = model.title;
        vc.id = model._id;
        vc.booklist_type = kBookListType_rank;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)updateTableViewWithDatasCount:(NSInteger)count arrayForMore:(NSArray *)moreArray indexPath:(NSIndexPath *)indexPath tableViewOperationType:(kRankingOperation)type {
    
    switch (type) {
        case kRankingOperation_insert:
        {
            [_groups[indexPath.section] addObjectsFromArray:moreArray];
            
            NSMutableArray *array = @[].mutableCopy;
            
            for (int i = 0; i < moreArray.count; i ++) {
                [array addObject:[NSIndexPath indexPathForRow:count + i inSection:indexPath.section]];
            }
            
            [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        case kRankingOperation_delete:
        {
            [_groups[indexPath.section] removeObjectsInArray:moreArray];
            
            NSMutableArray *array = @[].mutableCopy;
            
            for (int i = (int)(count - moreArray.count); i < count ; i ++) {
                
                [array addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            }
            
            [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        default:
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
