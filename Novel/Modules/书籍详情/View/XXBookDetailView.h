//
//  XXBookDetailView.h
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseScrollView.h"
#import "XXRecommendView.h"

typedef NS_ENUM(NSUInteger, kBookDetailType) {
    kBookDetailType_read = 0, //点击了阅读
    kBookDetailType_recommendMore = 1, //点击了更多
};

@interface XXBookDetailView : BaseScrollView

- (void)configRecommendDatas:(NSArray *)datas;

/** 点击回调 */
@property (nonatomic, strong) RACSubject *didClickDelegate;

@end
