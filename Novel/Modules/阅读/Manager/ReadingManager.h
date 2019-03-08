//
//  ReadingManager.h
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookChapterModel.h"
#import "SummaryModel.h"
#import "XXChaptersApi.h"
#import "XXSummaryApi.h"
#import "XXBookContentApi.h"

#define kReadingManager [ReadingManager shareReadingManager]

@interface ReadingManager : NSObject

/** 初始化单例 */
+ (instancetype)shareReadingManager;

/** 目录数组 */
@property (nonatomic, strong) NSArray *chapters;

/** 小说title */
@property (nonatomic, copy) NSString *title;

/** 书籍id */
@property (nonatomic, copy) NSString *bookId;

/** 源id */
@property (nonatomic, copy) NSString *summaryId;

/** 记录当前第n章 */
@property (nonatomic, assign) NSUInteger chapter;

/** 记录在当前章节中读到第n页 */
@property (nonatomic, assign) NSUInteger page;

/** 小说字体大小 */
@property (nonatomic, assign) NSUInteger font;

/** 0-白色 1-黄色 2-淡绿色 3-淡黄色 4-淡紫色 5-黑色 */
@property (nonatomic, assign) NSUInteger bgColor;

/** 在applicationDidEnterBackground程序退出时判断是否需要存储 */
@property (nonatomic, assign) BOOL isSave;

/** 预下载n章 */
@property (nonatomic, assign) NSUInteger downlownNumber;

- (void)clear;

/**
 请求源数组

 @param completion <#completion description#>
 @param failure <#failure description#>
 */
- (void)requestSummaryCompletion:(void(^)())completion failure:(void(^)(NSString *error))failure;


/**
 请求目录

 @param completion <#completion description#>
 @param failure <#failure description#>
 */
- (void)requestChaptersCompletion:(void(^)())completion failure:(void(^)(NSString *error))failure;


/**
 请求小说内容

 @param chapter 第几章
 @param ispreChapter 是否为上一章
 @param completion <#completion description#>
 @param failure <#failure description#>
 */
- (void)requestContentWithChapter:(NSUInteger)chapter ispreChapter:(BOOL)ispreChapter Completion:(void(^)())completion failure:(void(^)(NSString *error))failure;


/**
 是否允许进入横屏

 @param allowLandscape <#allowLandscape description#>
 */
//- (void)allowLandscapeRight:(BOOL)allowLandscape;

@end
