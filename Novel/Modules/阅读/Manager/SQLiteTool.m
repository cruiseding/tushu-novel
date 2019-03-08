//
//  SQLiteTool.m
//  Novel
//
//  Created by th on 2017/3/5.
//  Copyright © 2017年 th. All rights reserved.
//

#import "SQLiteTool.h"

@implementation ResultModel


@end

@interface SQLiteTool()

@end

@implementation SQLiteTool

/**
 存储章节，直接用小说title‘s id 作为表名，bool值返回结果
 */
+ (BOOL)saveWithTitle:(NSString *)title body:(NSString *)body tableName:(NSString *)tableName {
    
    __block BOOL res = NO;
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:kChaptersPath];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        //开启事务，要么全部成功，要么全部失败，确保数据始终处于正确和谐的状态
        [db beginTransaction];
        
        //title唯一
        res = [db executeUpdate:NSStringFormat(@"create table `%@` (pk integer primary key autoincrement, title text UNIQUE, body text)",tableName)];
        
        res = [db executeUpdate:NSStringFormat(@"insert into `%@`(title, body) values('%@', '%@')",tableName, title, body)];
        
        [db commit];
        
        if (res) {
            NSLog(@"%@章节保存成功",title);
        } else {
            NSLog(@"%@章节保存失败",title);
        }
    }];
    
    [dbQueue close];

    return res;
}
/**
 查询章节，以章节的标题作为查询条件，传入要查询的表名
 */
+ (void)getChapterTitle:(NSString *)title tableName:(NSString *)tableName success:(void(^)(ResultModel *resultModel))success failure:(void(^)())failure {
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:kChaptersPath];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:NSStringFormat(@"select * from `%@` where title like '%@%@%@'",tableName,@"%",title,@"%")];
        
        ResultModel *model = [ResultModel new];
        while ([rs next]) {
            model.title = [rs stringForColumn:@"title"];
            model.body = [rs stringForColumn:@"body"];
        }
        
        if (model.title && model.body) {
            success (model);
            NSLog(@"查询成功--%@",model.title);
        } else {
            NSLog(@"查询失败--%@",model.title);
            failure ();
        }

    }];
    
    [dbQueue close];
}

/**
 删除表
 */
+ (BOOL)deleteTableName:(NSString *)tableName indatabasePath:(NSString *)databasePath {
    
    __block BOOL res = NO;
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        //开启事务，要么全部成功，要么全部失败，确保数据始终处于正确和谐的状态
        [db beginTransaction];
        
        res = [db executeUpdate:NSStringFormat(@"drop table `%@`",tableName)];
        
        [db commit];
        
        if (res) {
            NSLog(@"%@表删除成功",tableName);
        } else {
            NSLog(@"%@表删除失败",tableName);
        }
    }];
    
    [dbQueue close];
    
    return res;
}

/**
 添加书架,直接用小说title's id 作为表名,包含id, summaryId,coverURL,title, lastChapter, updated，status, chapter，page，status使用0和1，用来判断有章节更新了是否点击进入阅读界面，作为更新图片是否隐藏的依据
 */
+ (BOOL)addShelfWithModel:(BookShelfModel *)model {
    
    __block BOOL res = NO;
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:kShelfPath];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        //开启事务，要么全部成功，要么全部失败，确保数据始终处于正确和谐的状态
        [db beginTransaction];
        
        //id设置唯一约束UNIQUE
        res = [db executeUpdate:NSStringFormat(@"create table `%@` (pk integer primary key autoincrement, id text UNIQUE, summaryId text, coverURL text, title text, lastChapter text, updated text, status text, chapter text, page text)",model.id)];
        
        res = [db executeUpdate:NSStringFormat(@"insert into `%@`(id, summaryId, coverURL, title, lastChapter, updated, status, chapter, page) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",model.id, model.id, model.summaryId, model.coverURL, model.title, model.lastChapter, model.updated, model.status, model.chapter, model.page)];
        
        [db commit];
        
        if (res) {
            NSLog(@"书架保存成功");
        } else {
            NSLog(@"书架保存失败");
        }
    }];
    
    [dbQueue close];
    
    return res;
}
/**
 查询书架所有表数据，返回model数组
 */

+ (NSMutableArray *)getBooksShelf {
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:kShelfPath];
    
    //新建model数组
    NSMutableArray *modelArray = @[].mutableCopy;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        //查询一个数据库中的所有的表
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM sqlite_master WHERE type = 'table';"];
        
        while ([resultSet next]) {
            //取得所有的表
            NSString *tableName = [resultSet stringForColumn:@"name"];
            
            //不要SQLite的sqlite_sequence表
            if (![tableName isEqualToString:@"sqlite_sequence"]) {
                FMResultSet *result = [db executeQuery:NSStringFormat(@"SELECT * FROM `%@`",tableName)];
                
                //id,coverURL,title, lastChapter, updated, chapter，page
                while ([result next]) {
                    BookShelfModel *model = [BookShelfModel new];
                    model.id = [result stringForColumn:@"id"];
                    model.summaryId = [result stringForColumn:@"summaryId"];
                    model.title = [result stringForColumn:@"title"];
                    model.coverURL = [result stringForColumn:@"coverURL"];
                    model.lastChapter = [result stringForColumn:@"lastChapter"];
                    model.updated = [result stringForColumn:@"updated"];
                    model.status = [result stringForColumn:@"status"];
                    model.chapter = [result stringForColumn:@"chapter"];
                    model.page = [result stringForColumn:@"page"];
                    [modelArray addObject:model];
                }
            }
        };
    }];
    
    [dbQueue close];
    
    return modelArray;
}

/**
 查询书架表数据，返回model
 */
+ (BookShelfModel *)getBookWithTableName:(NSString *)tableName {
    
    BookShelfModel *model = [BookShelfModel new];
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:kShelfPath];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:NSStringFormat(@"SELECT * FROM `%@`",tableName)];
        while ([result next]) {
            
            model.id = [result stringForColumn:@"id"];
            model.summaryId = [result stringForColumn:@"summaryId"];
            model.title = [result stringForColumn:@"title"];
            model.coverURL = [result stringForColumn:@"coverURL"];
            model.lastChapter = [result stringForColumn:@"lastChapter"];
            model.updated = [result stringForColumn:@"updated"];
            model.status = [result stringForColumn:@"status"];
            model.chapter = [result stringForColumn:@"chapter"];
            model.page = [result stringForColumn:@"page"];
        }
        
    }];
    
    [dbQueue close];
    
    return model;
}

/**
 修改书架字段，传入NSDictionary类型：@{@"name":@"jack",@"age":@"23"}，key和value
 */
+ (void)updateWithTableName:(NSString *)tableName dict:(NSDictionary *)dict; {
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:kShelfPath];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        //开启事务，要么全部成功，要么全部失败，确保数据始终处于正确和谐的状态
        [db beginTransaction];
        
        //修改书架的信息
        for (NSString *key in dict) {
            
            [db executeUpdate:NSStringFormat(@"update `%@` set %@ = '%@'",tableName, key, dict[key])];
            
        }
        
        [db commit];
        
    }];
    
    [dbQueue close];
}

/**
 查询小说表是否存在
 */
+ (BOOL)isTableOK:(NSString *)tableName {
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:kShelfPath];
    
    __block BOOL res = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:NSStringFormat(@"select count(*) as 'count' from sqlite_master where type ='table' and name = '%@'",tableName)];
        
        while ([rs next]) {
            
            NSInteger count = [rs intForColumn:@"count"];
            
            if (0 == count) {
                res = NO;
            } else {
                res = YES;
            }
        }
    }];
    
    [dbQueue close];
    
    return res;
}

@end
