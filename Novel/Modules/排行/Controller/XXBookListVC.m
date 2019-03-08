//
//  XXBookListVC.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookListVC.h"
#import "XXRandingApi.h"
#import "XXRecommendApi.h"
#import "XXSearchApi.h"
#import "BooksListModel.h"
#import "XXBookListCellNode.h"
#import "XXBookDetailVC.h"

@interface XXBookListVC ()

@end

@implementation XXBookListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cellClass = [XXBookListCellNode class];
    
    [self requestDataWithShowLoading:YES];
}

- (void)configListOnpullRefresh {

}

- (void)configListDownpullRefresh {
    
}

- (void)requestDataWithOffset:(NSInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    
    switch (_booklist_type) {
            case kBookListType_rank: {
                
                XXRandingApi *api = [[XXRandingApi alloc] initWithParameter:nil url:URL_ranking(_id)];
                
                [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    BooksListModel *model = [BooksListModel modelWithDictionary:request.responseObject[@"ranking"]];
                    
                    success(model.books);
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    failure([request.error localizedDescription]);
                }];
                
            }
            break;
            
            case kBookListType_recommend: {
                
                XXRecommendApi *api = [[XXRecommendApi alloc] initWithParameter:nil url:URL_recommend(_id)];
                
                [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    BooksListModel *model = [BooksListModel modelWithDictionary:request.responseObject];
                    success(model.books);
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    failure([request.error localizedDescription]);
                }];
                
            }
            break;
            
            case kBookListType_search: {
                
                XXSearchApi *api = [[XXSearchApi alloc] initWithParameter:nil url:URL_search(_search)];
                
                [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    BooksListModel *model = [BooksListModel modelWithDictionary:request.responseObject];
                    success(model.books);
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    failure([request.error localizedDescription]);
                }];
                
            }
            break;
            
        default:
            break;
    }
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
    
    BooksListItemModel *model = self.datas[indexPath.row];
    
    XXBookDetailVC *vc = [[XXBookDetailVC alloc] init];
    
    vc.title = model.title;
    vc.id = model._id;
    
    NSLog(@"---%@",model._id);
    
    [self.navigationController pushViewController:vc animated:YES];
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
