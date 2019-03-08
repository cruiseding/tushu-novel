//
//  XXBookListMainVC.h
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import <WMPageController/WMPageController.h>
#import "XXBookListVC.h"

@interface XXBookListMainVC : WMPageController

/** 榜id */
@property (nonatomic, copy) NSString *id;
/** 月榜id */
@property (nonatomic, copy) NSString *monthRank;
/** 总榜id */
@property (nonatomic, copy) NSString *totalRank;

@property (nonatomic, assign) kBookListType booklist_type;

@end
