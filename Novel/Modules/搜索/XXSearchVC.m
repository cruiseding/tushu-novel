//
//  XXSearchVC.m
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXSearchVC.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import "XXBookListVC.h"

@interface XXSearchVC () <UISearchBarDelegate, TTGTextTagCollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, strong) UIView *infillingView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) TTGTextTagCollectionView *tagsView;

@property (nonatomic, strong) NSMutableArray *colors;

@end

@implementation XXSearchVC

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = @[].mutableCopy;
        [_tags addObjectsFromArray:@[@"圣墟",@"雪鹰领主",@"辰东",@"我吃西红柿",@"唐家三少",@"天蚕土豆",@"耳根",@"烟雨江南",@"梦入神机",@"骷髅精灵",@"完美世界",@"大主宰",@"斗破苍穹",@"斗罗大陆",@"如果蜗牛有爱情",@"极品家丁",@"择天记",@"神墓",@"遮天",@"太古神王",@"帝霸",@"校花的贴身高手",@"武动乾坤"]];
    }
    return _tags;
}

- (NSMutableArray *)colors {
    if (!_colors) {
        _colors = [[NSMutableArray alloc] init];
        
        NSArray *temps = @[kcolorWithRGB(146, 197, 238), kcolorWithRGB(192, 104, 208), kcolorWithRGB(245, 188, 120), kcolorWithRGB(145, 206, 213), kcolorWithRGB(103, 204, 183), kcolorWithRGB(231, 143, 143)];
        
        for (int i = 0; i < 5; i++) {
            [_colors addObjectsFromArray:temps];
        }
    }
    return _colors;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = kwhiteColor;
    [self.view addSubview:_topView];
    
    _infillingView = [[UIView alloc] init];
    _infillingView.backgroundColor = kwhiteColor;
    [self.view addSubview:_infillingView];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.barTintColor = kwhiteColor;
    _searchBar.placeholder = @"请输入书名或作者名";
    _searchBar.barStyle = UISearchBarStyleProminent;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kgrayColor,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [_topView addSubview:_searchBar];
    
    UILabel *everyLabel = [[UILabel alloc] init];
    everyLabel.font = fontSize(13);
    everyLabel.text = @"大家都在搜";
    [_topView addSubview:everyLabel];
    
    UIButton *refreshButton = [UIButton newButtonTitle:@"换一批" font:13 normarlColor:kgrayColor];
    [refreshButton setImage:UIImageWithName(@"search_refresh") forState:0];
    [refreshButton setImagePosition:kImagePosition_left spacing:3];
    [refreshButton addTarget:self action:@selector(configTag) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:refreshButton];
    
    _tagsView = [[TTGTextTagCollectionView alloc] init];
    _tagsView.delegate = self;
    [self configTag];
    [_topView addSubview:_tagsView];
    
    //布局
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(_tagsView.mas_bottom).offset(kCellX);
    }];
    
    [_infillingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_top);
        make.left.right.equalTo(_topView);
        make.height.mas_equalTo(xxAdaWidth(10));
    }];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_infillingView.mas_bottom);
        make.left.right.equalTo(_infillingView);
        make.height.mas_equalTo(xxAdaWidth(40));
    }];
    
    [everyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_searchBar.mas_bottom).offset(kCellX);
        make.left.mas_equalTo(_topView.mas_left).offset(kCellX);
    }];
    
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(everyLabel);
        make.right.mas_equalTo(_topView.mas_right).offset(-kCellX);
    }];
    [refreshButton setEnlargeEdgeWithTop:kCellX right:kCellX bottom:kCellX left:kCellX];
    
    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(everyLabel.mas_bottom).offset(xxAdaWidth(20));
        make.left.mas_equalTo(_topView.mas_left).offset(kCellX);
        make.right.mas_equalTo(_topView.mas_right).offset(-kCellX);
    }];
}

- (void)configTag {
    
    TTGTextTagConfig *textConfig = [[TTGTextTagConfig alloc] init];
    textConfig.tagTextFont = fontSize(14);
    textConfig.tagTextColor = kwhiteColor;
    textConfig.tagCornerRadius = xxAdaWidth(5);
    textConfig.tagSelectedCornerRadius = xxAdaWidth(5);
    textConfig.tagBorderWidth = 0;
    textConfig.tagSelectedBorderWidth = 0;
    textConfig.tagShadowColor = kclearColor;
    
    textConfig.tagExtraSpace = CGSizeMake(xxAdaWidth(15), xxAdaWidth(10));
    
    _tagsView.defaultConfig = textConfig;
    
    //外边距
    _tagsView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //间距
    _tagsView.horizontalSpacing = xxAdaWidth(15);
    
    _tagsView.verticalSpacing = xxAdaHeight(10);
    
    _tagsView.alignment = TTGTagCollectionAlignmentLeft;
    _tagsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSUInteger location = 0;
    NSUInteger length = 1;
    
    NSArray *tags = [self tagArray];
    
    //移除所有的标签
    [_tagsView removeAllTags];
    
    for (int i = 0; i < tags.count; i++) {
        textConfig.tagBackgroundColor = self.colors[i];
        textConfig.tagSelectedBackgroundColor = self.colors[i];
        
        [_tagsView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[textConfig copy]];
        location += length;
    }
}

//获取一个随机整数，范围在[from,to]，包括from，包括to
- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

//获取要随机一个数组
- (NSArray *)tagArray {
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    while (randomSet.count < [self getRandomNumber:3 to:10]) {
        int r = arc4random() % [self.tags count];
        [randomSet addObject:[self.tags objectAtIndex:r]];
    }
    return [randomSet allObjects];
}

#pragma mark - UISearchBarDelegate
//开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchBar setShowsCancelButton:YES];
        for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *cancelBtn = (UIButton *)view;
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }];
}

//结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

//搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar endEditing:YES];
    if (_searchBar.text.length > 0) {
        [self searchWithText:_searchBar.text];
    }
}

- (void)searchWithText:(NSString *)text {
    XXBookListVC *vc = [XXBookListVC new];
    vc.title = text;
    vc.search = text;
    vc.booklist_type = kBookListType_search;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchBar setShowsCancelButton:NO];
        [self.searchBar endEditing:YES];
    }];
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    [self searchWithText:tagText];
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
