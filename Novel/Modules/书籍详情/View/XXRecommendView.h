//
//  XXRecommendView.h
//  Novel
//
//  Created by app on 2018/1/16.
//  Copyright © 2018年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXRecommendCell.h"

@interface XXRecommendView : UIView

- (void)configDatas:(NSArray *)datas;

@property (nonatomic, strong) RACSubject *delegate;

@end
