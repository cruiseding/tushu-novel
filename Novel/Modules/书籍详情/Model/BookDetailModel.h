//
//  BookDetailModel.h
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseModel.h"

@interface BookDetailModel : BaseModel

- (NSString *)getBookWordCount;

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *creater;

@property (nonatomic, copy) NSString *longIntro;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *cat;

@property (nonatomic, copy) NSString *majorCate;

@property (nonatomic, copy) NSString *minorCate;

@property (nonatomic, assign) BOOL _le;

@property (nonatomic, assign) BOOL allowMonthly;

@property (nonatomic, assign) BOOL allowVoucher;

@property (nonatomic, assign) BOOL allowBeanVoucher;

@property (nonatomic, assign) BOOL hasCp;

@property (nonatomic, assign) NSInteger postCount;

@property (nonatomic, assign) NSInteger latelyFollower;

@property (nonatomic, assign) NSInteger latelyFollowerBase;

@property (nonatomic, assign) NSInteger followerCount;

@property (nonatomic, assign) NSInteger wordCount;

@property (nonatomic, assign) NSInteger serializeWordCount;

@property (nonatomic, assign) NSInteger minRetentionRatio;

@property (nonatomic, copy) NSString *retentionRatio;

@property (nonatomic, strong) NSString *updated;

/** 是否连载中，yes-未完结，no-完结 */
@property (nonatomic, assign) BOOL isSerial;

@property (nonatomic, assign) NSInteger chaptersCount;

@property (nonatomic, copy) NSString *lastChapter;

@property (nonatomic, strong) NSArray *gender;

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, assign) BOOL donate;

@property (nonatomic, copy) NSString *copyright;

@end
