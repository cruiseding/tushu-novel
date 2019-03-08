//
//  XXBookMenuView.m
//  Novel
//
//  Created by app on 2018/1/19.
//  Copyright © 2018年 th. All rights reserved.
//

#define kLeftX xxAdaWidth(15.f)
#define kTopHeight (kAppDelegate.statusBarHeight + NavigationBar_HEIGHT + xxAdaWidth(25))
#define kBottomHeight xxAdaWidth(55)

#import "XXBookMenuView.h"

@interface XXBookMenuView()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *linkLabel;

@property (nonatomic, strong) UIButton *dayButton;

@end

@implementation XXBookMenuView


- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.01];
        
        [self setupTop];
        [self setupBottom];
        [self setupSettingView];
        [self configTap];
    }
    return self;
}


- (void)setupTop {
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.00];
    [self addSubview:_topView];
    
    UIButton *replaceBtn = [UIButton newButtonTitle:@"换源" font:15 normarlColor:kwhiteColor];
    [_topView addSubview:replaceBtn];
    
    _titleLabel = [UILabel newLabel:@"" andTextColor:kwhiteColor andFontSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"sm_exit"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"sm_exit_selected"] forState:UIControlStateSelected];
    [_topView addSubview:closeBtn];
    
    _linkLabel = [UILabel newLabel:@"" andTextColor:kgrayColor andFontSize:12];
    _linkLabel.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.16 alpha:1.00];
    _linkLabel.numberOfLines = 1;
    _linkLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_linkLabel];
    
    //约束
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(-kTopHeight);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(kTopHeight);
    }];
    
    [replaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_top).offset(kAppDelegate.statusBarHeight);
        make.left.mas_equalTo(_topView.mas_left).offset(kLeftX);
        make.size.mas_equalTo(CGSizeMake(NavigationBar_HEIGHT, NavigationBar_HEIGHT));
    }];
    [replaceBtn setEnlargeEdgeWithTop:0 right:kLeftX bottom:0 left:kLeftX];
    
    //replaceBtn抗拉伸
    //    [replaceBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(replaceBtn);
        make.left.mas_equalTo(replaceBtn.mas_right).offset(kLeftX);
        make.right.mas_equalTo(closeBtn.mas_left).offset(-kLeftX);
        make.height.mas_equalTo(NavigationBar_HEIGHT);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(replaceBtn);
        make.right.mas_equalTo(_topView.mas_right).offset(-kLeftX);
        make.size.mas_equalTo(CGSizeMake(NavigationBar_HEIGHT, NavigationBar_HEIGHT));
    }];
    [closeBtn setEnlargeEdgeWithTop:0 right:kLeftX bottom:0 left:kLeftX];
    
    [_linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(replaceBtn.mas_bottom);
        make.bottom.mas_equalTo(_topView.mas_bottom);
        make.left.right.mas_equalTo(_topView);
    }];
    
    xxWeakify(self)
    [[replaceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (weakself.delegate) {
            [weakself.delegate sendNext: [NSNumber numberWithInteger:kBookMenuType_source]];
        }
    }];
    
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (weakself.delegate) {
            [weakself.delegate sendNext: [NSNumber numberWithInteger:kBookMenuType_close]];
        }
    }];
}

- (void)setupBottom {
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:1.00];
    [self addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(kBottomHeight);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kBottomHeight);
    }];
    
    NSArray *images = @[@"night_mode", @"feedback", @"directory", @"preview_btn", @"reading_setting"];
    
    NSArray *titles = @[@"夜间", @"反馈", @"目录", @"缓存", @"设置"];
    
    NSArray *types = @[[NSNumber numberWithInteger:kBookMenuType_day], [NSNumber numberWithInteger:kBookMenuType_feedBack], [NSNumber numberWithInteger:kBookMenuType_directory], [NSNumber numberWithInteger:kBookMenuType_down], [NSNumber numberWithInteger:kBookMenuType_setting]];
    
    UIView *tempView = nil;
    
    xxWeakify(self)
    for (int i = 0; i < images.count; i++) {
        
        XXHighLightButton *button = [[XXHighLightButton alloc] init];
        button.highlightedColor = UIColorHexAlpha(#666666, 0.6);
        button.titleLabel.font = fontSize(13);
        [button setTitleColor:kwhiteColor forState:0];
        [button setTitle:titles[i] forState:0];
        [button setImage:[UIImage imageNamed:images[i]] forState:0];
        [button setImagePosition:kImagePosition_top spacing:xxAdaWidth(2)];
        
        [_bottomView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_bottomView);
            make.left.mas_equalTo(tempView ? tempView.mas_right : _bottomView);
            make.width.mas_equalTo(_bottomView.mas_width).dividedBy(images.count);
        }];
        
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (weakself.delegate) {
                [weakself.delegate sendNext:types[i]];
            }
        }];
        
        tempView = button;
        
        if (i == 0) {
            _dayButton = button;
            
            if (kReadingManager.bgColor != 5) {
                [button setImage:UIImageWithName(@"day_mode") forState:0];
                [button setTitle:@"白天" forState:UIControlStateNormal];
            }
        }
    }
}

- (void)changeDayAndNight {
    
    if (kReadingManager.bgColor != 5) {
        
        [_dayButton setImage:[UIImage imageNamed:@"night_mode"] forState:0];
        [_dayButton setTitle:@"夜间" forState:UIControlStateNormal];
        
        kReadingManager.bgColor = 5;
        
    } else {
        
        [_dayButton setImage:[UIImage imageNamed:@"day_mode"] forState:0];
        [_dayButton setTitle:@"白天" forState:UIControlStateNormal];
        
        kReadingManager.bgColor = 0;
    }
    
    [_settingView refreshColorSeleted:kReadingManager.bgColor];
}

- (void)setupSettingView {
    
    _settingView = [[XXBookSettingView alloc] init];
    _settingView.hidden = YES;
    [self addSubview:_settingView];
    
    [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(_bottomView.mas_top);
    }];
}

- (void)configTap {
    
    //添加一个单击事件，遮挡住self的弹出和隐藏的单击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
    }];
    
    [_topView addGestureRecognizer:tap];
    
    [_bottomView addGestureRecognizer:[tap deepCopy]];
    
    [_settingView addGestureRecognizer:[tap deepCopy]];
}

- (void)showMenuWithDuration:(CGFloat)duration completion:(void(^)())completion {
    
    if (!_settingView.hidden) {
        _settingView.hidden = YES;
    }
    
    [self layoutIfNeeded]; // <---- 注意
    
    CGFloat topOffset = 0.0;
    CGFloat bottomOffset = 0.0;
    duration = duration < 0 ? 0.2 : duration;
    
    BOOL hidden = NO;
    
    if (self.hidden) {
        //如果隐藏的 那需要弹出来
        hidden = NO;
        self.hidden = hidden;
    } else {
        hidden = YES;
        topOffset = -kTopHeight;
        bottomOffset = kBottomHeight;
    }
    
    [UIView animateWithDuration:duration animations:^{
        
        [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(topOffset);
        }];
        
        [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(bottomOffset);
        }];
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (hidden) self.hidden = hidden;
        if (completion) completion();;
    }];
}

- (void)showTitle:(NSString *)title bookLink:(NSString *)link {
    
    _titleLabel.text = title;
    _linkLabel.text = link;
}


- (void)showOrHiddenSettingView {
    
    _settingView.hidden = !_settingView.hidden;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
