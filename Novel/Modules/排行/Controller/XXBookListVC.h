//
//  XXBookListVC.h
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "ASBaseTableNodeViewController.h"

typedef NS_ENUM(NSInteger, kBookListType) {
    kBookListType_rank, //排行版
    kBookListType_recommend,//书籍详情里的推荐更多
    kBookListType_search,//搜索
};

@interface XXBookListVC : ASBaseTableNodeViewController

@property (nonatomic, assign) kBookListType booklist_type;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) NSArray *books;

@property (nonatomic, copy) NSString *search;

@end
