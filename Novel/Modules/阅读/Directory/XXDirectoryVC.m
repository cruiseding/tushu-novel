//
//  DirectoryViewController.m
//  Novel
//
//  Created by th on 2017/3/1.
//  Copyright © 2017年 th. All rights reserved.
//

#import "XXDirectoryVC.h"
#import "XXDirectoryCell.h"

@interface XXDirectoryVC ()

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;

/** 设置一开始就跳转到底部 */
@property (nonatomic, assign) BOOL isBottom;

@property (nonatomic, assign) BOOL isReplaceSummary;

@end

@implementation XXDirectoryVC

- (instancetype)initWithIsReplaceSummary:(BOOL)isReplaceSummary {
    if (self = [super init]) {
        _isReplaceSummary = isReplaceSummary;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isBottom = YES;
    [_rightButton setTitle:@"到底部" forState:UIControlStateNormal];
    
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:[XXDirectoryCell class] forCellReuseIdentifier:NSStringFromClass([XXDirectoryCell class])];
}

- (void)configListOnpullRefresh {
    
}

- (void)configListDownpullRefresh {
    
}

- (void)configListView {
    
    [self.view addSubview:self.tableView];
    
    CGFloat topHeight = NavigationBar_HEIGHT + kAppDelegate.statusBarHeight;
    CGFloat bottomHeight = xxAdaWidth(44);
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.00];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.00];
    [self.view addSubview:_bottomView];
    
    //到底/定部按钮
    _rightButton = [UIButton newButtonTitle:@"" font:14 normarlColor:kwhiteColor];
    [_rightButton addTarget:self action:@selector(scrollToTopOrBottom) forControlEvents:UIControlEventTouchDown];
    [_topView addSubview:_rightButton];
    
    //标题
    UILabel *titleLabel = [UILabel newLabel:kReadingManager.title andTextColor:kwhiteColor andFontSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:titleLabel];
    
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setImage:[UIImage imageNamed:@"directory_close"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"directory_close_pressed"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:cancelButton];
    
    //约束
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(topHeight);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(bottomHeight);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_top).offset(kAppDelegate.statusBarHeight);
        make.right.mas_equalTo(_topView.mas_right).offset(-kCellX);
        make.size.mas_equalTo(CGSizeMake(NavigationBar_HEIGHT, NavigationBar_HEIGHT));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightButton);
        make.left.mas_equalTo(_topView.mas_left).offset(kCellX*2 + NavigationBar_HEIGHT);
        make.right.mas_equalTo(_rightButton.mas_left).offset(-kCellX);
        make.height.mas_equalTo(NavigationBar_HEIGHT);
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bottomView);
        make.height.mas_equalTo(_bottomView.mas_height);
        make.width.mas_equalTo(_bottomView.mas_height);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(_bottomView.mas_top);
    }];
}


- (void)scrollToTopOrBottom {
    
    if (_isBottom) {
        [_rightButton setTitle:@"到顶部" forState:UIControlStateNormal];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:kReadingManager.chapters.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        _isBottom = NO;
    } else {
        [_rightButton setTitle:@"到底部" forState:UIControlStateNormal];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        _isBottom = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([XXDirectoryCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell configTitle:((BookChapterModel *)kReadingManager.chapters[indexPath.row]).title indexPath:indexPath];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kReadingManager.chapters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XXDirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XXDirectoryCell class])];
    [cell configTitle:((BookChapterModel *)kReadingManager.chapters[indexPath.row]).title indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectChapter) {
        _selectChapter (indexPath.row);
    }
    
    [self cancelAction];
}

- (void)scrollToCurrentRow {
    
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:kReadingManager.chapter inSection:0];;
    [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)cancelAction {
    
    if (_isReplaceSummary) {
        //换了源
        if (_selectChapter) {
            _selectChapter (kReadingManager.chapter);
        }
    }
    [self go2Back];
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
