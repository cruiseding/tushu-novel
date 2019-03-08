//
//  SummaryModel.h
//  Novel
//
//  Created by th on 2017/3/9.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseModel.h"

@interface SummaryModel : BaseModel

/** 源id */
@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *lastChapter;

@property (nonatomic, assign) BOOL isCharge;

/** 章节总数 */
@property (nonatomic, assign) NSInteger chaptersCount;

@property (nonatomic, copy) NSString *updated;

/** 开始，true为追书vip源,false为其他源 */
@property (nonatomic, assign) BOOL starting;

@property (nonatomic, copy) NSString *host;

/** 当前选择 */
@property (nonatomic, assign) BOOL isSelect;

@end
