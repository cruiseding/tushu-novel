//
//  xxBookShelfVC.m
//  Novel
//
//  Created by xth on 2018/1/10.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookShelfVC.h"
#import "XXBookShelfCell.h"
#import "XXUpdateChapterApi.h"
#import "XXBookReadingVC.h"

@interface XXBookShelfVC ()

@end

@implementation XXBookShelfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.bl_shouldAutoLandscape = YES;
    
    [self setupEstimatedRowHeight:xxAdaWidth(65) registerCell:[XXBookShelfCell class]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSelf:) name:@"reloadBookShelf" object:nil];
}

#pragma mark - 接收通知，刷新界面
- (void)reloadSelf:(NSNotification *)sender {
    self.datas = [SQLiteTool getBooksShelf];
    [self.tableView reloadData];
}

- (void)configListDownpullRefresh {
    self.datas = [SQLiteTool getBooksShelf];
    
    xxWeakify(self)
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        weakself.page = self.initialPage;
        [weakself requestDataWithShowLoading:NO];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)configListOnpullRefresh {

}

- (void)requestDataWithOffset:(NSInteger)page success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    
    XXUpdateChapterApi *api = [[XXUpdateChapterApi alloc] initWithParameter:@{@"view": @"updated", @"id": [BookShelfModel componentsJoineWithArrID:self.datas]} url:URL_bookShelf_update];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSArray *updates = [NSArray modelArrayWithClass:[BookShelfModel class] json:request.responseString];
        
        for (int i = 0; i < updates.count; i++) {
            
            BookShelfModel *m1 = self.datas[i];
            BookShelfModel *m2 = updates[i];
            
            //status=0 -->NO 不显示  status=1 -->YES 显示
            if (![m1.lastChapter isEqualToString:m2.lastChapter]) {
                //有更新
                m1.updated = m2.updated;
                m1.lastChapter = m2.lastChapter;
                m1.status = @"1";
                [SQLiteTool updateWithTableName:m1.id dict:@{@"lastChapter":m2.lastChapter, @"updated":m1.updated, @"status":@"1"}];
            }
        }
        
        [self.tableView reloadData];
        [self endRefresh];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self showEmpty:@"书架空空如也"];
        [self endRefresh];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookShelfModel *model = self.datas[indexPath.row];

    XXBookReadingVC *vc = [[XXBookReadingVC alloc] initWithBookId:model.id bookTitle:model.title summaryId:model.summaryId];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];;

    [self.navigationController presentViewController:nav animated:YES completion:^{
        vc.presentComplete = YES;
    }];
}


- (void)configCellSubViewsCallback:(XXBookShelfCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    xxWeakify(self)
    cell.cellLongPress = ^(UILongPressGestureRecognizer *longPress) {
        switch (longPress.state) {
            case UIGestureRecognizerStateBegan: //开始
            {
                BookShelfModel *model = self.datas[indexPath.row];
                
                CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:model.title message:@"删除所选书籍及缓存文件？" ];
                
                CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                    NSLog(@"点击了 %@ 按钮",action.title);
                }];
                
                CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                    NSLog(@"点击了 %@ 按钮",action.title);
                    if ([SQLiteTool deleteTableName:model.id indatabasePath:kShelfPath]) {
                        
                        //删除缓存的章节
                        [SQLiteTool deleteTableName:model.id indatabasePath:kChaptersPath];
                        
                        weakself.datas = [SQLiteTool getBooksShelf];
                        
                        [weakself.tableView reloadData];
                        
                        if (IsEmpty(self.datas)) {
                            [weakself showEmpty:@"书架空空如也"];
                        }
                        
                        NSLog(@"%@--删除成功",model.title);
                        
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"删除失败"];
                    }
                    
                }];
                
                [alertVC addAction:cancel];
                [alertVC addAction:sure];
                
                [self presentViewController:alertVC animated:NO completion:nil];
            }
                
                break;
            case UIGestureRecognizerStateChanged: //移动
                
                break;
            case UIGestureRecognizerStateEnded: //结束
                
                break;
                
            default:
                break;
        }
    };
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToRankingVC" object:nil];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    UIImage *refreshImage = [UIImage imageNamed:@"blankRefresh"];
    
    NSMutableAttributedString *textTest = [[NSMutableAttributedString alloc] initWithString:@" 您还没有添加书籍，点击添加哦"];
    textTest.font = fontSize(12);
    
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(100, 100)];
    container.maximumNumberOfRows = 1;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:textTest];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    attachment.bounds = CGRectMake(0, -(layout.textBoundingSize.height - refreshImage.height) * 0.5, refreshImage.width, refreshImage.height);
    attachment.image = refreshImage;
    
    NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *strMatt = [[NSMutableAttributedString alloc] initWithString:@" 您还没有添加书籍，点击添加哦"];
    strMatt.font = fontSize(12);
    strMatt.color = klightGrayColor;
    
    [strMatt insertAttributedString:strAtt atIndex:0];
    
    return strMatt;
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
