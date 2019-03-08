//
//  DirectoryViewController.h
//  Novel
//
//  Created by th on 2017/3/1.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseTableViewController.h"

@interface XXDirectoryVC : BaseTableViewController

- (instancetype)initWithIsReplaceSummary:(BOOL)isReplaceSummary;

@property (nonatomic, copy) void(^selectChapter)(NSInteger chapter);

- (void)scrollToCurrentRow;

@end
