//
//  SQLiteTool.h
//  Novel
//
//  Created by th on 2017/3/5.
//  Copyright © 2017年 th. All rights reserved.
//
/*
 sqlite没有mysql那么多字段，
 text 对应 NSString
 blob 对应 NSData
 integer 对应 NSNumber
 real 对应 一个浮点值
 NULL 表示没有值，SQLite具有对NULL的完全支持
 参考http://www.runoob.com/sqlite/sqlite-data-types.html
 */

//存储章节
#define kChaptersPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Chapters.sqlite"]

//存储书架
#define kShelfPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BookShelf.sqlite"]

#import <Foundation/Foundation.h>
#import "BookShelfModel.h"

@interface ResultModel : NSObject

@property (nonatomic, copy) NSString *title;

/** 小说内容 */
@property (nonatomic, copy) NSString *body;

@end


@interface SQLiteTool : NSObject

/**
 存储章节，直接用小说title's id 作为表名,，bool值返回结果
 */
+ (BOOL)saveWithTitle:(NSString *)title body:(NSString *)body tableName:(NSString *)tableName;

/**
 查询章节，以章节的标题作为查询条件，传入要查询的表名
 */
+ (void)getChapterTitle:(NSString *)title tableName:(NSString *)tableTitle success:(void(^)(ResultModel *resultModel))success failure:(void(^)())failure;


/**
 删除表
 */
+ (BOOL)deleteTableName:(NSString *)tableName indatabasePath:(NSString *)databasePath;



/**
 添加书架,直接用小说title's id 作为表名,包含id,summaryId,coverURL,title, lastChapter, updated，status, chapter，page，status使用0和1，用来判断有章节更新了是否点击进入阅读界面，作为更新图片是否隐藏的依据
 */
+ (BOOL)addShelfWithModel:(BookShelfModel *)model;


/**
 查询书架所有表数据，返回model数组
 */
+ (NSMutableArray *)getBooksShelf;

/**
 查询书架表数据，返回model
 */
+ (BookShelfModel *)getBookWithTableName:(NSString *)tableName;


/**
 修改书架字段，传入NSDictionary类型：@{@"name":@"jack",@"age":@"23"}，key和value
 */
+ (void)updateWithTableName:(NSString *)tableName dict:(NSDictionary *)dict;

/**
 查询小说表是否存在 即是否已经加入书架
 */
+ (BOOL)isTableOK:(NSString *)tableName;


@end


