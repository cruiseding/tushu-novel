//
//  XXBaseBookReadingVC.m
//  Novel
//
//  Created by app on 2018/1/20.
//  Copyright © 2018年 th. All rights reserved.
//

#define kShowMenuDuration 0.3f

#import "XXBookReadingVC.h"
#import "KPageViewController.h"
#import "XXBookContentVC.h"
#import "XXBookMenuView.h"
#import "XXDirectoryVC.h"
#import "XXSummaryVC.h"

@interface XXBookReadingVC () <KPageViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) KPageViewController *pageViewController;

@property (nonatomic, strong) XXBookMenuView *menuView;

/** 判断是否是下一章，否即上一章 */
@property (nonatomic, assign) BOOL ispreChapter;

/** 是否显示状态栏 */
@property (nonatomic, assign) BOOL hiddenStatusBar;

/** 是否更换源 */
@property (nonatomic, assign) BOOL isReplaceSummary;

@end

@implementation XXBookReadingVC

- (instancetype)initWithBookId:(NSString *)bookId bookTitle:(NSString *)bookTitle summaryId:(NSString *)summaryId {
    if (self = [super init]) {
        
        [kReadingManager clear];
        kReadingManager.bookId = bookId;
        kReadingManager.title = bookTitle;
        kReadingManager.summaryId = summaryId;
        
        if ([SQLiteTool isTableOK:bookId]) {
            //查询是否已经加入书架
            BookShelfModel *book = [SQLiteTool getBookWithTableName:bookId];
            kReadingManager.chapter = [book.chapter integerValue];
            kReadingManager.page = [book.page integerValue];
        }
    }
    return self;
}

#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden {
    return _hiddenStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
//- (NSUInteger)supportedInterfaceOrientations
//#else
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//#endif
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    BookSettingModel *setMd = [BaseModel decodeModelWithKey:NSStringFromClass([BookSettingModel class])];
//    if (setMd.isLandspace) {
//        [kReadingManager allowLandscapeRight:YES];
//    }
    
//    [UIViewController attemptRotationToDeviceOrientation];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self requestDataWithShowLoading:YES];
}

- (void)setupViews {
    
    [self.view addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
}


#pragma mark - 开始进来处理下网络或者缓存
- (void)requestDataWithShowLoading:(BOOL)show {
    if (show) {
        [HUD showProgress:nil inView:self.view];
    }
    
    xxWeakify(self)
    [self requestSummaryWithComplete:^{
        
        [weakself requestChaptersWithComplete:^{
            
            [weakself requestContentWithComplete:^{
                [HUD hide];
                
                //初始化显示控制器
                [weakself.pageViewController setController:[weakself updateWithChapter:kReadingManager.chapter]];
            }];
        }];
    }];
}

#pragma mark - 请求源头列表
- (void)requestSummaryWithComplete:(void(^)())complete {
    
    xxWeakify(self)
    
    if (kReadingManager.summaryId.length > 0) {
        
        complete();
        
    } else {
        //如果没有加入书架的就会没有源id 需要请求一遍拿到源id,然后请求目录数组->再请求第一章
        [kReadingManager requestSummaryCompletion:^{
            
            //请求完成
            if (kReadingManager.summaryId.length == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"⚠️" message:@"当前书籍没有源更新!" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    
                    [weakself dismissViewControllerAnimated:YES completion:nil];
                    
                }]];
                
                [weakself presentViewController:alert animated:YES completion:^{
                    [HUD hide];
                }];
            } else {
                //有源id
                complete();
            }
            
        } failure:^(NSString *error) {
            [HUD hide];
            [HUD showError:error inview:weakself.view];
        }];
    }
    
}

#pragma mark - 请求小数目录数组
- (void)requestChaptersWithComplete:(void(^)())complete {
    
    xxWeakify(self)
    
    [kReadingManager requestChaptersCompletion:^{
        
        if (weakself.isReplaceSummary) {
            //已经更换了源ID 弹出目录让用户选择
            if (kReadingManager.chapter > kReadingManager.chapters.count - 1) {
                //如果上次读的章节数大于当前源的总章节数
                kReadingManager.chapter = kReadingManager.chapters.count - 1;
            }
            weakself.isReplaceSummary = NO;
            
            //保存下进度
            [SQLiteTool updateWithTableName:kReadingManager.bookId dict:@{@"chapter": @(kReadingManager.chapter), @"page": @(kReadingManager.page), @"summaryId": kReadingManager.summaryId}];
            
            [weakself showDirectoryVCWithIsReplaceSummary:YES];
            
        } else {
            complete();
        }
        
    } failure:^(NSString *error) {
        [HUD hide];
        [HUD showError:error inview:weakself.view];
    }];
}

#pragma mark - 请求小说内容
- (void)requestContentWithComplete:(void(^)())complete {
    
    xxWeakify(self)
    
    [kReadingManager requestContentWithChapter:kReadingManager.chapter ispreChapter:weakself.ispreChapter Completion:^{
        complete();
    } failure:^(NSString *error) {
        [HUD hide];
        [HUD showError:error inview:weakself.view];
    }];
}

#pragma mark - KPageViewControllerDelegate
- (void)KPageViewControllerTapWithMenu {
    
    [self showMenu];
}

#pragma mark - 切换结果
- (void)coverController:(KPageViewController * _Nonnull)coverController currentController:(UIViewController * _Nullable)currentController finish:(BOOL)isFinish {
    
    if (!isFinish) {//切换失败
        
    }
}

#pragma mark - 返回上一个控制器
- (UIViewController *)coverController:(KPageViewController *)coverController getAboveControllerWithCurrentController:(UIViewController *)currentController {
    
    if ( kReadingManager.chapter == 0 && kReadingManager.page == 0) {
        [HUD showMsgWithoutView:@"已经是第一页了!"];
        return nil;
    }
    
    XXBookContentVC *vc = (XXBookContentVC *)currentController;
    
    if (vc.page > 0) {
        
        kReadingManager.page--;
        
    } else {
        
        kReadingManager.chapter--;
        
        _ispreChapter = YES;
    }
    return [self updateWithChapter:vc.chapter];
}


#pragma mark - 返回下一个控制器
- (UIViewController *)coverController:(KPageViewController *)coverController getBelowControllerWithCurrentController:(UIViewController *)currentController {
    
    if (kReadingManager.page == [kReadingManager.chapters.lastObject pageCount] - 1 && kReadingManager.chapter == kReadingManager.chapters.count - 1) {
        [HUD showMsgWithoutView:@"已经是最后一页了!"];
        return nil;
    }
    
    XXBookContentVC *vc = (XXBookContentVC *)currentController;
    
    if (vc.page >= [kReadingManager.chapters[vc.chapter] pageCount] - 1) {
        
        kReadingManager.page = 0;
        
        kReadingManager.chapter++;
        
        _ispreChapter = NO;
        
    } else {
        kReadingManager.page++;
    }
    
    return [self updateWithChapter:vc.chapter];
}



- (XXBookContentVC *)updateWithChapter:(NSInteger)chapter {
    
    // 创建一个新的控制器类，并且分配给相应的数据
    XXBookContentVC *contentVC = [[XXBookContentVC alloc] init];
    
    void(^parameterBlock)() = ^{
        
        contentVC.bookModel = kReadingManager.chapters[kReadingManager.chapter];
        
        contentVC.chapter = kReadingManager.chapter;
        
        contentVC.page = kReadingManager.page;
        
        [HUD hide];
    };
    
    if (chapter != kReadingManager.chapter) {
        
        [HUD showProgress:nil inView:self.view];
        
        [self requestContentWithComplete:^{
            [HUD hide];
            parameterBlock();
        }];
        
    } else {
        parameterBlock();
    }
    
    return contentVC;
}


#pragma mark - 处理菜单的单击事件
- (void)configMenuTap {
    
    xxWeakify(self)
    
    self.menuView.delegate = [RACSubject subject];
    
    [self.menuView.delegate subscribeNext:^(id  _Nullable x) {
        
        NSUInteger type = [x integerValue];
        
        switch (type) {
            case kBookMenuType_source: {
                //换源
                XXSummaryVC *vc = [[XXSummaryVC alloc] init];
                [weakself presentViewController:vc animated:YES completion:nil];
                
                vc.selectedSummaryBlock = ^(NSString *_id) {
                    weakself.isReplaceSummary = YES;
                    kReadingManager.summaryId = _id;
                    
                    [weakself requestDataWithShowLoading:YES];
                };
            }
                
                break;
            case kBookMenuType_close: {
                //关闭
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                
                //保存进度，chapter，page，status=0 -->NO 不显示  status=1 -->YES 显示
                [SQLiteTool updateWithTableName:kReadingManager.bookId dict:@{@"chapter": @(kReadingManager.chapter), @"page": @(kReadingManager.page), @"status": @"0"}];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBookShelf" object:nil];
                
                [kReadingManager clear];
                
                [weakself go2Back];
            }
                
                break;
            case kBookMenuType_day: {
                //白天黑夜切换
                [weakself.menuView changeDayAndNight];
            }
                
                break;
            case kBookMenuType_feedBack: {
                //意见反馈
                
            }
                
                break;
            case kBookMenuType_directory: {
                //目录
                [weakself showDirectoryVCWithIsReplaceSummary:NO];
            }
                
                break;
            case kBookMenuType_down: {
                //下载
                
            }
                
                break;
            case kBookMenuType_setting: {
                //设置
                [weakself.menuView showOrHiddenSettingView];
            }
                
                break;
                
            default:
                break;
        }
    }];
    
    
    self.menuView.settingView.changeSmallerFontBlock = ^{
        //字体缩小
        NSUInteger font = kReadingManager.font - 1;
        [weakself changeWithFont:font];
    };
    
    self.menuView.settingView.changeBiggerFontBlock = ^{
        //字体放大
        NSUInteger font = kReadingManager.font + 1;
        [weakself changeWithFont:font];
    };
    
//    self.menuView.settingView.landspaceBlock = ^{
//        [weakself landscape];
//    };
}

#pragma mark - 弹出目录
- (void)showDirectoryVCWithIsReplaceSummary:(BOOL)isReplaceSummary {
    
    XXDirectoryVC *directoryVC = [[XXDirectoryVC alloc] initWithIsReplaceSummary:isReplaceSummary];
    
    [self presentViewController:directoryVC animated:YES completion:^{
        [directoryVC scrollToCurrentRow];
    }];
    
    //选择章节
    xxWeakify(self)
    directoryVC.selectChapter = ^(NSInteger chapter) {
        
        [weakself showMenu];
        
        [kReadingManager requestContentWithChapter:chapter ispreChapter:weakself.ispreChapter Completion:^{
            [HUD hide];
            kReadingManager.chapter = chapter;
            kReadingManager.page = 0;
            
            [weakself.pageViewController setController:[weakself updateWithChapter:kReadingManager.chapter]];
            
        } failure:^(NSString *error) {
            [HUD hide];
        }];
    };
}

#pragma mark - 改变内容字体大小
- (void)changeWithFont:(NSUInteger)font {
    
    if (font < 5) return;
    
    BookSettingModel *md = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
    md.font = font;
    kReadingManager.font = md.font;
    [BookSettingModel encodeModel:md key:[BookSettingModel className]];
    
    BookChapterModel *bookModel = kReadingManager.chapters[kReadingManager.chapter];
    
    [bookModel pagingWithBounds:kReadingFrame WithFont:fontSize(kReadingManager.font)];
    
    //跳转回该章的第一页
    if (kReadingManager.page < bookModel.pageCount) {
        kReadingManager.page = 0;
    }
    [self.pageViewController setController:[self updateWithChapter:kReadingManager.chapter]];
}

#pragma mark - 弹出或隐藏菜单
- (void)showMenu {
    
    if (!self.menuView.hidden) {
        //如果没有隐藏，代表已经弹出来了，那么执行的是隐藏操作
        self.hiddenStatusBar = YES;
    } else {
        self.hiddenStatusBar = NO;
    }
    
    [self.menuView showMenuWithDuration:kShowMenuDuration completion:nil];
    
    [self.menuView showTitle:kReadingManager.title bookLink:((BookChapterModel *)kReadingManager.chapters[kReadingManager.chapter]).link];
}

#pragma mark - get/set

- (void)setPresentComplete:(BOOL)presentComplete {
    _presentComplete = presentComplete;
    if (_presentComplete) {
        self.hiddenStatusBar = YES;
    }
}

//控制状态栏的显示和隐藏
- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar {
    _hiddenStatusBar = hiddenStatusBar;
    [UIView animateWithDuration:kShowMenuDuration animations:^{
        //给状态栏的隐藏和显示加动画
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

//pageViewController
- (KPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [KPageViewController new];
        _pageViewController.delegate = self;
        
        NSArray *imgs = @[@"day_mode_bg", @"yellow_mode_bg", @"green_mode_bg", @"sheepskin_mode_bg", @"pink_mode_bg", @"coffee_mode_bg"];
        
        UIImage *bgImage = [UIImage imageNamed:imgs[kReadingManager.bgColor]];
        
        _pageViewController.view.layer.contents = (__bridge id _Nullable)(bgImage.CGImage);
        // 可以设置无动画
        //    coverVC.openAnimate = NO;
    }
    return _pageViewController;
}

//菜单
- (XXBookMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[XXBookMenuView alloc] init];
        [self.view addSubview:_menuView];
        
        //第一次进来要隐藏
        _menuView.hidden = YES;
        
        [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_menuView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            //来到这里表示menu已经是弹出来的
            [self showMenu];
        }]];
        
        [self configMenuTap];
    }
    return _menuView;
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
