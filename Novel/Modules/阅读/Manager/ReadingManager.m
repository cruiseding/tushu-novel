//
//  ReadingManager.m
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import "ReadingManager.h"

@interface ReadingManager()


@end

@implementation ReadingManager

+ (instancetype)shareReadingManager {
    
    static ReadingManager *readM = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        readM = [[self alloc] init];
        
        if (![BookSettingModel decodeModelWithKey:[BookSettingModel className]]) {
            
            //没有存档
            BookSettingModel *model = [[BookSettingModel alloc] init];
            
            model.font = 20;
            model.bgColor = 0;
            model.isLandspace = NO;
            
            readM.font = 20;
            readM.bgColor = 0;
            
            [BookSettingModel encodeModel:model key:[BookSettingModel className]];
            
        } else {
            //已经存档了设置
            BookSettingModel *model = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
            
            readM.font = model.font;
            readM.bgColor = model.bgColor;
        }
    });
    
    return readM;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        //code
        
    }
    
    return self;
}
- (void)clear {
    self.chapter = 0;
    self.page = 0;
    self.chapters = nil;
    self.title = nil;
    self.summaryId = nil;
    self.isSave = NO;
}

- (void)requestSummaryCompletion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    XXSummaryApi *api = [[XXSummaryApi alloc] initWithParameter:nil url:URL_summary(self.bookId)];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSArray *arr = [NSArray modelArrayWithClass:[SummaryModel class] json:request.responseObject];
        
        NSMutableArray *summarys = @[].mutableCopy;
        
        for (SummaryModel *model in arr) {
            //去掉追书的vip源，你懂得
            if (!model.starting) {
                [summarys addObject:model];
            }
        }
        
        if (summarys.count > 0) {
            self.summaryId = ((SummaryModel *)summarys[0])._id;
            [SQLiteTool updateWithTableName:self.bookId dict:@{@"summaryId": self.summaryId}];
        }
        
        completion();
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure([request.error localizedDescription]);
    }];
}

- (void)requestChaptersCompletion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    XXChaptersApi *api = [[XXChaptersApi alloc] initWithParameter:nil url:URL_chapters(self.summaryId)];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSArray *arr = [NSArray modelArrayWithClass:[BookChapterModel class] json:request.responseObject[@"chapters"]];
        
        self.chapters = arr;
        
        completion();
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure([request.error localizedDescription]);
    }];
    
}

- (void)requestContentWithChapter:(NSUInteger)chapter ispreChapter:(BOOL)ispreChapter Completion:(void(^)())completion failure:(void(^)(NSString *error))failure {
    
    if (self.chapters.count == 0) {
        failure(@"目录为空！");
        return;
    }
    
    BookChapterModel *model = self.chapters[chapter];
    
    NSString *linkString = model.link;
    
    XXBookContentApi *api = [[XXBookContentApi alloc] initWithParameter:nil url:URL_bookContent(linkString)];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        model.body = [model adjustParagraphFormat:request.responseObject[@"chapter"][@"body"]];
        
        //存储章节
//        [SQLiteTool saveWithTitle:model.title body:model.body tableName:self.bookId];
        
        [model pagingWithBounds:kReadingFrame WithFont:fontSize(self.font)];
        
        if (ispreChapter) {
            self.page = model.pageCount - 1.0;
        }
        
        completion();
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure([request.error localizedDescription]);
    }];
}

- (void)allowLandscapeRight:(BOOL)allowLandscape {
    
//    kAppDelegate.disagreeRotation = !allowLandscape;
    
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    
    if (allowLandscape) {
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    } else {
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

@end
