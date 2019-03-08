//
//  BookShelfModel.h
//  Novel
//
//  Created by th on 2017/3/6.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseModel.h"

#define KBooksPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bookShelf.plist"]

@interface BookShelfModel : BaseModel

#pragma mark - 书架的model

/** book's id */
@property (nonatomic, copy) NSString *id;

/** 源id */
@property (nonatomic, copy) NSString *summaryId;

@property (nonatomic, copy) NSString *coverURL;

/** 小说标题 */
@property (nonatomic, copy) NSString *title;

/** status=0 -->NO 不显示  status=1 -->YES 显示 */
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *chapter;

@property (nonatomic, copy) NSString *page;


#pragma mark - 下面是更新的model

//@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *referenceSource;

@property (nonatomic, copy) NSString *updated;

@property (nonatomic, copy) NSString *lastChapter;

@property (nonatomic, assign) NSInteger chaptersCount;


/**
 拼接的id，eg：5816b415b06d1d32157790b1,5816b415b06d1d32157790b1
 */
+ (NSString *)componentsJoineWithArrID:(NSArray *)array;

@end
