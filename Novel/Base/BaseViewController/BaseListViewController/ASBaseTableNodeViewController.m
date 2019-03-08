//
//  ASBaseTableNodeViewController.m
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import "ASBaseTableNodeViewController.h"
#import "ASBaseCellNode.h"

@interface ASBaseTableNodeViewController ()

@end

@implementation ASBaseTableNodeViewController

- (instancetype)init {
    if (self = [super initWithNode:[[ASDisplayNode alloc] init]]) {
        [self initTableNodeStyle:UITableViewStylePlain];
    }
    return self;
}

- (void)initTableNodeStyle:(UITableViewStyle)style {
    _tableNode = [[ASTableNode alloc] initWithStyle:style];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    _tableNode.view.showsVerticalScrollIndicator = NO;
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableNode.view.estimatedRowHeight = 0;
    
    [self.node addSubnode:_tableNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setCellClass:(id)cellClass {
    _cellClass = cellClass;
}

- (void)configListView {
    [_tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)configListDownpullRefresh {
    xxWeakify(self)
    _tableNode.view.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        weakself.page = weakself.initialPage;
        [weakself.tableNode.view.mj_footer resetNoMoreData];
        [weakself requestDataWithShowLoading:NO];
    }];
}

- (void)configListOnpullRefresh {
    xxWeakify(self)
    self.tableNode.view.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;
        [weakself requestDataWithShowLoading:NO];
    }];
}


- (void)endRefresh {
    [HUD hide];
    [_tableNode.view.mj_header endRefreshing];
    [_tableNode.view.mj_footer endRefreshing];
}

- (void)showEmpty:(NSString *)emptyError {
    [HUD hide];
    if (self.page == self.initialPage) {
        if (!IsEmpty(self.datas) && emptyError.length > 0) {
            //不为空
            _tableNode.view.mj_footer.hidden = NO;
            [HUD showMessage:emptyError inView:self.view];
            return;
        }
        self.emptyError = emptyError;
        _tableNode.view.emptyDataSetSource = self;
        _tableNode.view.emptyDataSetDelegate = self;
        [_tableNode.view reloadEmptyDataSet];
        _tableNode.view.mj_footer.hidden = YES;
        
    } else {
        [HUD showMessage:emptyError inView:self.view];
        _tableNode.view.mj_footer.hidden = NO;
    }
}

- (void)requestDataWithShowLoading:(BOOL)show {
    [super requestDataWithShowLoading:show];
    
    if (self.page == self.initialPage) {
        self.tableNode.view.mj_footer.hidden = YES;
    }
    
    xxWeakify(self)
    [self requestDataWithOffset:self.page success:^(NSArray *dataArr) {
        
        [weakself endRefresh];
        
        if (weakself.tableNode.view.isEmptyDataSetVisible) {
            weakself.tableNode.view.emptyDataSetSource = nil;
            weakself.tableNode.view.emptyDataSetDelegate = nil;
            [weakself.tableNode.view reloadEmptyDataSet];
        }
        
        if (weakself.page == weakself.initialPage && IsEmpty(dataArr)) {
            //没有数据的时候
            [weakself showEmpty:@"暂时没有可用数据"];
            return;
            
        } else if (weakself.page > weakself.initialPage && IsEmpty(dataArr)) {
            //加载没有更多数据的时候
            [weakself.tableNode.view.mj_footer endRefreshingWithNoMoreData];
            return;
            
        } else if (weakself.page == weakself.initialPage && !IsEmpty(dataArr)) {
            //第一次加载数据
            [weakself.datas removeAllObjects];
            [weakself.datas addObjectsFromArray:dataArr];
            [weakself.tableNode reloadDataWithCompletion:^{
                weakself.tableNode.view.mj_footer.hidden = NO;
            }];
            
            return;
            
        } else if (weakself.page > weakself.initialPage && !IsEmpty(dataArr)) {
            //上拉刷新
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            
            int row = weakself.datas.count > 0 ? (int)weakself.datas.count : 0;
            
            [weakself.datas addObjectsFromArray:dataArr];
            
            for (; row < weakself.datas.count; row++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            }
            
            [weakself.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            
            return;
        }
        
    } failure:^(NSString *msg) {
        [weakself endRefresh];
        [weakself showEmpty:msg];
    }];
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        NSCAssert(self.cellClass, @"请配置cellNode");
        ASBaseCellNode *cellNode = [[[self.cellClass class] alloc] initWithModel:self.datas[indexPath.row]];
        [self configCellSubViewsCallback:cellNode indexPath:indexPath];
        return cellNode;
    };
    return cellNodeBlock;
}

#pragma mark -- DZNEmptyDataSetSource

// 向上偏移量为表头视图高度/2
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -self.tableNode.view.tableHeaderView.frame.size.height/2.0f;
}

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
