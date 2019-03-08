//
//  BaseListViewController.h
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseListViewController : BaseViewController

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;

/** 分页 */
@property (nonatomic, assign) int page;

/** 初始页 一般0或者1 */
@property (nonatomic, assign) int initialPage;

/**
 配置list控件 位置
 */
- (void)configListView;

/**
 配置list控件 下拉刷新
 */
- (void)configListDownpullRefresh;

/**
 配置list控件 上拉刷新
 */
- (void)configListOnpullRefresh;

/**
 当cell里的子控件需要些block回调时重载该方法
 
 @param cell <#cell description#>
 @param indexPath <#indexPath description#>
 */
- (void)configCellSubViewsCallback:(id)cell
                         indexPath:(NSIndexPath *)indexPath;


/**
 必须重写该方法，请求列表数据
 
 @param page <#page description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)requestDataWithOffset:(NSInteger)page
                      success:(void (^)(NSArray *dataArr))success
                      failure:(void (^)(NSString *msg))failure;

/**
 停止刷新和隐藏loading
 */
- (void)endRefresh;

/**
 显示空视图
 
 @param emptyError <#emptyError description#>
 */
- (void)showEmpty:(NSString *)emptyError;

@end
