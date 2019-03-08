//
//  XXBookContentVC.m
//  Novel
//
//  Created by app on 2018/1/25.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookContentVC.h"
#import "BatteryView.h"

@interface XXBookContentVC ()

@property (nonatomic, strong) YYLabel *contentLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) BatteryView *batteryView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation XXBookContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //背景颜色的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBgColorWithNotifiction:) name:kNotificationWithChangeBg object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayAndNightBg:) name:kNotificationDayAndNightBg object:nil];
}

- (void)changeBgColorWithNotifiction:(NSNotification *)sender {
    NSUInteger index = [[sender userInfo][kNotificationWithChangeBg] integerValue];
    [self changeBgColorWithIndex:index];
}

- (void)dayAndNightBg:(NSNotification *)sender {
    NSUInteger index = [[sender userInfo][kNotificationDayAndNightBg] integerValue];
    [self changeBgColorWithIndex:index];
}


#pragma mark - 改变背景颜色
/** 0-白色 1-黄色 2-淡绿色 3-淡黄色 4-淡紫色 */
- (void)changeBgColorWithIndex:(NSUInteger)index {
    NSArray *imgs = @[@"day_mode_bg", @"yellow_mode_bg", @"green_mode_bg", @"sheepskin_mode_bg", @"pink_mode_bg", @"coffee_mode_bg"];
    
    UIImage *bgImage = [UIImage imageNamed:imgs[index]];
    self.view.layer.contents = (__bridge id _Nullable)(bgImage.CGImage);
    
    [self changeOtherColor:index];
    self.batteryView.backgroundColor = [bgImage mostColor];
    [self.batteryView setNeedsDisplay];
}

- (void)changeOtherColor:(NSUInteger)index {
    if (kReadingManager.bgColor == 5) {
        NSMutableAttributedString *text = (NSMutableAttributedString *)self.contentLabel.attributedText;
        text.color = kwhiteColor;
        
        self.contentLabel.attributedText = text;
        self.titleLabel.textColor = kwhiteColor;
        self.timeLabel.textColor = kwhiteColor;
        self.pageLabel.textColor = kwhiteColor;
    } else {
        NSMutableAttributedString *text = (NSMutableAttributedString *)self.contentLabel.attributedText;
        text.color = kblackColor;
        
        self.contentLabel.attributedText = text;
        self.titleLabel.textColor = knormalColor;
        self.timeLabel.textColor = knormalColor;
        self.pageLabel.textColor = knormalColor;
    }
}


#pragma mark - get/set

- (void)setBookModel:(BookChapterModel *)bookModel {
    _bookModel = bookModel;
    
    self.titleLabel.text = bookModel.title;
}

- (void)setPage:(NSUInteger)page {
    _page = page;
    
    self.contentLabel.attributedText = [_bookModel getStringWithpage:page];
    
    self.timeLabel.text = [[DateTools shareDate] getTimeString];
    
    self.pageLabel.text = [NSString stringWithFormat:@"%zd/%zd", page+1, _bookModel.pageCount];
    
    [self changeBgColorWithIndex:kReadingManager.bgColor];
    
    [self changeOtherColor:kReadingManager.bgColor];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFontSize:13];
        [self.view addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.mas_equalTo(self.view.mas_left).offset(kReadSpaceX);
            make.right.mas_equalTo(self.view.mas_right).offset(-kReadSpaceX);
            make.height.mas_equalTo(kReadingTopH);
        }];
    }
    return _titleLabel;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [_contentLabel setTextVerticalAlignment:YYTextVerticalAlignmentTop];//居上对齐
        [self.view addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.left.mas_equalTo(self.view.mas_left).offset(kReadSpaceX);
            make.right.mas_equalTo(self.view.mas_right).offset(-kReadSpaceX);
            make.bottom.mas_equalTo(self.bottomView.mas_top);
        }];
    }
    return _contentLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self.view addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.mas_equalTo(kReadingBottomH);
        }];
    }
    return _bottomView;
}

- (BatteryView *)batteryView {
    if (!_batteryView) {
        
        _batteryView = [[BatteryView alloc] init];
        _batteryView.fillColor = [UIColor colorWithRed:0.35 green:0.31 blue:0.22 alpha:1.00];
        [self.bottomView addSubview:_batteryView];
        
        [_batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottomView);
            make.left.mas_equalTo(self.bottomView.mas_left).offset(kReadSpaceX);
            make.size.mas_equalTo(CGSizeMake(xxAdaWidth(25), xxAdaWidth(10)));
        }];
    }
    return _batteryView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFontSize:12];
        [self.bottomView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.batteryView);
            make.left.mas_equalTo(self.batteryView.mas_right).offset(xxAdaWidth(8));
        }];
        
    }
    return _timeLabel;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFontSize:12];
        _pageLabel.textAlignment = NSTextAlignmentRight;
        [self.bottomView addSubview:_pageLabel];
        
        [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.batteryView);
            make.left.mas_equalTo(self.timeLabel.mas_right).offset(kCellX);
            make.right.mas_equalTo(self.bottomView.mas_right).offset(-kReadSpaceX);
        }];
    }
    return _pageLabel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
