//
//  XXSummaryVC.h
//  Novel
//
//  Created by app on 2018/1/25.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseTableViewController.h"

@interface XXSummaryVC : BaseTableViewController

/** 返回源id */
@property (nonatomic, copy) void(^selectedSummaryBlock)(NSString *_id);

@end
