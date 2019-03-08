//
//  BooksListModel.h
//  Novel
//
//  Created by th on 2017/2/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseModel.h"

@interface BooksListModel : BaseModel

/** BooksListItemModel的数组 */
@property (nonatomic, strong) NSArray *books;

@property (nonatomic, copy) NSString *_id;

/** 更新日期 */
@property (nonatomic, copy) NSString *updated;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *__v;

@property (nonatomic, copy) NSString *monthRank;

@property (nonatomic, copy) NSString *totalRank;

@property (nonatomic, assign) BOOL isSub;

@property (nonatomic, assign) BOOL collapse;

@property (nonatomic, assign) BOOL new;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *priority;

@property (nonatomic, copy) NSString *created;

@property (nonatomic, copy) NSString *id;

@end



@interface BooksListItemModel: BaseModel;

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *shortIntro;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *site;

/** 类型 */
@property (nonatomic, copy) NSString *cat;

@property (nonatomic, copy) NSString *banned;

/** 追书人数 */
@property (nonatomic, copy) NSString *latelyFollower;

@property (nonatomic, copy) NSString *latelyFollowerBase;

@property (nonatomic, copy) NSString *minRetentionRatio;

/** 百分比 读者留存 */
@property (nonatomic, copy) NSString *retentionRatio;

@end





