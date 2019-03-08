//
//  BaseTableViewController.h
//  Novel
//
//  Created by app on 2017/12/20.
//  Copyright © 2017年 th. All rights reserved.
//  

#import "BaseListViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface BaseTableViewController : BaseListViewController <UITableViewDelegate, UITableViewDataSource ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

/**
 初始化tableView，默认在init方法初始化了，样式默认UITableViewStylePlain，需要定制可以重写init方法
 - (instancetype)init {
    if (self) {
    //重写
    }
    return self;
 }

 @param style <#style description#>
 */
- (void)initTableViewStyle:(UITableViewStyle)style;


/**
 配置tableview的估算行高和注册的cell

 @param height 估算行高
 @param cellClass 注册cell class
 */
- (void)setupEstimatedRowHeight:(CGFloat)height registerCell:(Class)cellClass;

@end
