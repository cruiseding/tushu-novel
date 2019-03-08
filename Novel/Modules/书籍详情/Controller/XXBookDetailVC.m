//
//  XXBookDetailVC.m
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookDetailVC.h"
#import "XXBookDetailApi.h"
#import "BookDetailModel.h"
#import "XXBookDetailView.h"
#import "XXRecommendApi.h"
#import "XXBookReadingVC.h"
#import "XXBookListVC.h"

@interface XXBookDetailVC ()

@property (nonatomic, strong) XXBookDetailView *container;

@property (nonatomic, strong) BookDetailModel *model;

@property (nonatomic, strong) NSArray *recommends;

@end

@implementation XXBookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestDataWithShowLoading:YES];
    
    [self configEvent];
}

- (void)setupViews {
    
    _container = [[XXBookDetailView alloc] init];
    [self.view addSubview:_container];
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _container.refreshDelegate = [RACSubject subject];
    
    xxWeakify(self)
    [_container.refreshDelegate subscribeNext:^(id  _Nullable x) {
        [weakself requestDataWithShowLoading:YES];
    }];
}

- (void)configEvent {
    
    _container.didClickDelegate = [RACSubject subject];
    
    [_container.didClickDelegate subscribeNext:^(id  _Nullable x) {
        
        if ([x isKindOfClass:[NSNumber class]]) {
            
            NSUInteger type = [x integerValue];
            
            switch (type) {
                case kBookDetailType_read: {
                    //开始阅读
                    XXBookReadingVC *vc = nil;

                    if ([SQLiteTool isTableOK:self.model._id]) {
                        //已加入书架
                        BookShelfModel *model = [SQLiteTool getBookWithTableName:kShelfPath];
                        vc = [[XXBookReadingVC alloc] initWithBookId:self.model._id bookTitle:self.model.title summaryId:model.summaryId];
                    } else {
                        vc = [[XXBookReadingVC alloc] initWithBookId:self.model._id bookTitle:self.model.title summaryId:@""];
                    }
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];;

                    [self.navigationController presentViewController:nav animated:YES completion:^{
                        vc.presentComplete = YES;
                    }];
                }
                    
                    break;
                case kBookDetailType_recommendMore: {
                    XXBookListVC *vc = [[XXBookListVC alloc] init];
                    vc.title = @"你可能感兴趣";
                    vc.id = _id;
                    vc.booklist_type = kBookListType_recommend;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    
                    break;
                    
                default:
                    break;
            }
            
        } else if ([x isKindOfClass:[BooksListItemModel class]]) {
            
            BooksListItemModel *book = x;
            
            XXBookDetailVC *vc = [[XXBookDetailVC alloc] init];
            vc.title = book.title;
            vc.id = book._id;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

- (void)requestDataWithShowLoading:(BOOL)show {
    [super requestDataWithShowLoading:show];
    
    xxWeakify(self)
    
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        XXBookDetailApi *api = [[XXBookDetailApi alloc] initWithParameter:nil url:URL_bookDetail(weakself.id)];
        
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            weakself.model = [BookDetailModel modelWithDictionary:request.responseObject];
            
            [subscriber sendCompleted];
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [subscriber sendError:request.error];
        }];
        
        return nil;
    }] then:^RACSignal * _Nonnull{
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            XXRecommendApi *api = [[XXRecommendApi alloc] initWithParameter:nil url:URL_recommend(_id)];
            
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                BooksListModel *model = [BooksListModel modelWithDictionary:request.responseObject];
                
                weakself.recommends = model.books;
                
                [subscriber sendCompleted];
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [subscriber sendError:request.error];
            }];
            
            return nil;
        }];
    }] subscribeError:^(NSError * _Nullable error) {
        [HUD hide];
        [weakself.container showEmptyError:[error localizedDescription]];
    } completed:^{
        [HUD hide];
        [weakself.container configWithModel:weakself.model];
        [weakself.container configRecommendDatas:weakself.recommends];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
