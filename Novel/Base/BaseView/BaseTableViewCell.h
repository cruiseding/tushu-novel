//
//  BaseTableViewCell.h
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell
    
- (void)setupViews;

- (void)setupLayout;

- (void)configWithModel:(id)model;

@end
