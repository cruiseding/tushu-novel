//
//  BookChapterModel.h
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseModel.h"

/** 目录model和小说内容的model合并在一起 */

@interface BookChapterModel : BaseModel

@property (nonatomic, strong) NSArray *chapters;

/** 章节标题 */
@property (nonatomic, copy) NSString *title;

/** 章节链接 */
@property (nonatomic, copy) NSString *link;

@property (nonatomic, assign) BOOL unreadble;

/** 章节内容 */
@property (nonatomic, copy) NSString *body;

@property (nonatomic, strong) NSMutableArray *pageDatas;

/** 一章总页数 */
@property (nonatomic, assign) NSInteger pageCount;


/** 换行\t制表符，缩进 */
- (NSString *)adjustParagraphFormat:(NSString *)string;

/** 画出某章节某页的范围 */
- (void)pagingWithBounds:(CGRect)bounds WithFont:(UIFont *)font;

/** 获取某章节某一页的内容 */
- (NSAttributedString *)getStringWithpage:(NSInteger)page;

@end


@interface BookSettingModel : BaseModel

@property (nonatomic, assign) NSUInteger font;

/** 0-白色 1-黄色 2-淡绿色 3-淡黄色 4-淡紫色 5-黑色 */
@property (nonatomic, assign) NSUInteger bgColor;

/** 是否横屏 */
@property (nonatomic, assign) BOOL isLandspace;

@end





