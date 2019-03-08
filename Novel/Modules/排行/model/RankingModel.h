//
//  RankingModel.h
//  Novel
//
//  Created by th on 2017/2/2.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseModel.h"
@class RankingDeModel;

@interface RankingModel : BaseModel

/** 女生排行榜 */
@property (nonatomic, strong) NSArray<RankingDeModel *> *female;

/** 男生排行榜 */
@property (nonatomic, strong) NSArray<RankingDeModel *> *male;

@property (nonatomic, strong) NSArray <RankingDeModel *> *epub;

@end

@interface RankingDeModel : BaseModel;

/** 排行榜(周榜)id */
@property (nonatomic, copy) NSString *_id;

/** 排行榜title */
@property (nonatomic, copy) NSString *title;

/** 排行榜的封面 */
@property (nonatomic, copy) NSString *cover;

/** 是否折叠 */
@property (nonatomic, assign) BOOL collapse;

/** 月榜id */
@property (nonatomic, copy) NSString *monthRank;

/** 总榜id */
@property (nonatomic, copy) NSString *totalRank;

/** 是否--别人家的排行榜 */
@property (nonatomic, assign) BOOL isMoreItem;

/** 添加model */
+ (instancetype)modelWithTitle:(NSString *)title;

@end
