//
//  xxBaseSctrollView.m
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseScrollView.h"

@interface BaseScrollView()

@property (nonatomic, copy) NSString *emptyError;

@end

@implementation BaseScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.alwaysBounceVertical = YES;
        self.showsVerticalScrollIndicator = NO;
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            //必须要约束宽度
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height).priorityLow();
        }];
        
        [self setupViews];
        
        [self setupLayout];
        
        [self configEvent];
    }
    return self;
}

- (void)setupViews {
    
}

- (void)setupLayout {
    
}

- (void)configEvent {
    
}

- (void)configWithModel:(id)model {
    
}

- (void)removeEmpty {
    if (self.isEmptyDataSetVisible) {
        self.emptyDataSetSource = nil;
        self.emptyDataSetDelegate = nil;
        [self reloadEmptyDataSet];
    }
}

- (void)showEmptyError:(NSString *)error {
    self.emptyError = error;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    [self reloadEmptyDataSet];
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
    if (_refreshDelegate) {
        [_refreshDelegate sendNext:nil];
    }
}

- (void)dealloc {
    if (_refreshDelegate) {
        [_refreshDelegate sendCompleted];
    }
    NSLog(@"%@ 释放了",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
