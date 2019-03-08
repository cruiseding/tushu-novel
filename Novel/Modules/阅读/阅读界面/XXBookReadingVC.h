//
//  XXBaseBookReadingVC.h
//  Novel
//
//  Created by app on 2018/1/20.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseViewController.h"

@interface XXBookReadingVC : BaseViewController

- (instancetype)initWithBookId:(NSString *)bookId bookTitle:(NSString *)bookTitle summaryId:(NSString *)summaryId;

/** present动画完成 */
@property (nonatomic, assign) BOOL presentComplete;

@end
