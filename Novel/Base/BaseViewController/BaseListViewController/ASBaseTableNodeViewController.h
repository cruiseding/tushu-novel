//
//  ASBaseTableNodeViewController.h
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseListViewController.h"

@interface ASBaseTableNodeViewController : BaseListViewController <ASTableDelegate, ASTableDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) ASTableNode *tableNode;

/** 配置cellNode */
@property (nonatomic, strong) id cellClass;

/**
 初始化tableNode，默认在init方法初始化了，样式默认UITableViewStylePlain，需要定制可以重写init方法
 - (instancetype)init {
 if (self) {
 //重写
 }
 return self;
 }
 @param style <#style description#>
 */
- (void)initTableNodeStyle:(UITableViewStyle)style;


@end
