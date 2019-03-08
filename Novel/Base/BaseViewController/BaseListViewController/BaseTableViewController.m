//
//  BaseTableViewController.m
//  Novel
//
//  Created by app on 2017/12/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableViewCell.h"

@interface BaseTableViewController ()

@property (nonatomic, strong) Class cellClass;

@end

@implementation BaseTableViewController

- (instancetype)init {
    if (self = [super init]) {
        [self initTableViewStyle:UITableViewStylePlain];
    }
    return self;
}

- (void)initTableViewStyle:(UITableViewStyle)style {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.delaysContentTouches = NO;
    _tableView.canCancelContentTouches = YES;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Remove touch delay (since iOS 8)
    UIView *wrapView = _tableView.subviews.firstObject;
    // UITableViewWrapperView
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            // UIScrollViewDelayedTouchesBeganGestureRecognizer
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                gesture.enabled = NO;
                break;
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setupEstimatedRowHeight:(CGFloat)height registerCell:(Class)cellClass {
    _tableView.estimatedRowHeight = height;
    self.cellClass = cellClass;
    [_tableView registerClass:self.cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)configListView {
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)configListDownpullRefresh {
    xxWeakify(self)
    _tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        weakself.page = self.initialPage;
        [weakself.tableView.mj_footer resetNoMoreData];
        [weakself requestDataWithShowLoading:NO];
    }];
}

- (void)configListOnpullRefresh {
    xxWeakify(self)
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        [weakself requestDataWithShowLoading:NO];
    }];
    
}

- (void)endRefresh {
    [HUD hide];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)showEmpty:(NSString *)emptyError {
    [HUD hide];
    self.emptyError = emptyError;
    if (self.page == self.initialPage) {
        if (!IsEmpty(self.datas) && emptyError.length > 0) {
            //不为空
            self.tableView.mj_footer.hidden = NO;
            [HUD showMessage:emptyError inView:self.view];
            return;
        }
        
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView reloadEmptyDataSet];
        self.tableView.mj_footer.hidden = YES;
        
    } else {
        [HUD showMessage:emptyError inView:self.view];
        self.tableView.mj_footer.hidden = NO;
    }
}

- (void)requestDataWithShowLoading:(BOOL)show {
    [super requestDataWithShowLoading:show];
    
    if (self.page == self.initialPage) {
        self.tableView.mj_footer.hidden = YES;
    }
    
    xxWeakify(self)
    
    [self requestDataWithOffset:self.page success:^(NSArray *dataArr) {
        
        [weakself endRefresh];
        
        if (weakself.tableView.isEmptyDataSetVisible) {
            weakself.tableView.emptyDataSetSource = nil;
            weakself.tableView.emptyDataSetDelegate = nil;
            [weakself.tableView reloadEmptyDataSet];
        }
        
        if (weakself.page == weakself.initialPage && IsEmpty(dataArr)) {
            //没有数据的时候
            [weakself showEmpty:@"暂时没有可用数据"];
            return;
            
        } else if (weakself.page > weakself.initialPage && IsEmpty(dataArr)) {
            //加载没有更多数据的时候
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
            
        } else if (weakself.page == weakself.initialPage && !IsEmpty(dataArr)) {
            //第一次加载数据
            [weakself.datas removeAllObjects];
            [weakself.datas addObjectsFromArray:dataArr];
            [weakself.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakself.tableView.mj_footer.hidden = NO;
            });
            return;
            
        } else if (weakself.page > weakself.initialPage && !IsEmpty(dataArr)) {
            //上拉刷新
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            
            int row = weakself.datas.count > 0 ? (int)weakself.datas.count : 0;
            
            [weakself.datas addObjectsFromArray:dataArr];
            
            for (; row < weakself.datas.count; row++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            }
            
            [weakself.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            
            weakself.tableView.mj_footer.hidden = NO;
            
            return;
        }
        
    } failure:^(NSString *msg) {
        [weakself endRefresh];
        [weakself showEmpty:msg];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.cellClass isSubclassOfClass:[BaseTableViewCell class]]) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cellClass)];
        [cell configWithModel:self.datas[indexPath.row]];
        [self configCellSubViewsCallback:cell indexPath:indexPath];
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.cellClass isSubclassOfClass:[BaseTableViewCell class]]) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(self.cellClass) cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell configWithModel:self.datas[indexPath.row]];
        }];
    }
    return 0;
}


#pragma mark - DZNEmptyDataSetSource

//空白页占位图
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_ic"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (self.emptyError.length == 0) {
        self.emptyError = @"网络请求出错啦~";
    } else if (!kIsNetwork) {
        self.emptyError = @"当前网络异常~";
    }
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:fontSize(16),
                                 NSForegroundColorAttributeName:knormalColor
                                 };
    return [[NSAttributedString alloc] initWithString:self.emptyError attributes:attributes];
}

// 返回可以点击的按钮 上面带文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    UIImage *refreshImage = [UIImage imageNamed:@"blankRefresh"];
    
    NSMutableAttributedString *textTest = [[NSMutableAttributedString alloc] initWithString:@" 点击页面刷新"];
    textTest.font = fontSize(12);
    
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(100, 100)];
    container.maximumNumberOfRows = 1;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:textTest];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    attachment.bounds = CGRectMake(0, -(layout.textBoundingSize.height - refreshImage.height) * 0.5, refreshImage.width, refreshImage.height);
    attachment.image = refreshImage;
    
    NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *strMatt = [[NSMutableAttributedString alloc] initWithString:@" 点击页面刷新"];
    strMatt.font = fontSize(12);
    strMatt.color = klightGrayColor;
    
    [strMatt insertAttributedString:strAtt atIndex:0];
    
    return strMatt;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self requestDataWithShowLoading:YES];
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
