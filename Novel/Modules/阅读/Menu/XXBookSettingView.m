//
//  XXBookSettingView.m
//  Novel
//
//  Created by app on 2018/1/22.
//  Copyright © 2018年 th. All rights reserved.
//

#define kItemW xxAdaWidth(44)

#import "XXBookSettingView.h"

@interface XXBookSettingView()

@property (nonatomic, strong) UIButton *smallButton;

@property (nonatomic, strong) UIButton *bigButton;

@property (nonatomic, strong) NSMutableArray *colorSubViews;

@property (nonatomic, strong) UIButton *colorSeletedButton;

//@property (nonatomic, strong) UIButton *landspaceButton;

@end

@implementation XXBookSettingView

- (void)setupViews {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
}

- (void)setupLayout {
    
    UIImage *sImage = UIImageWithName(@"setting_font_smaller_normal");
    UIImage *bImage = UIImageWithName(@"setting_font_bigger");
    
    UIButton *smallButton = [[UIButton alloc] init];
    [smallButton setImage:sImage forState:UIControlStateNormal];
    [self addSubview:smallButton];
    
    UIButton *bigButton = [[UIButton alloc] init];
    [bigButton setImage:bImage forState:UIControlStateNormal];
    [self addSubview:bigButton];
    
//    _landspaceButton = [UIButton newButtonTitle:@"" font:15 normarlColor:kwhiteColor];
//    _landspaceButton.layer.cornerRadius = xxAdaWidth(5);
//    _landspaceButton.layer.borderColor = klineColor.CGColor;
//    _landspaceButton.layer.borderWidth = klineHeight;
//    [self addSubview:_landspaceButton];
//
//
//    BookSettingModel *setMd = [BookSettingModel decodeModelWithKey:NSStringFromClass([BookSettingModel class])];
//
//    if (setMd.isLandspace) {
//        [_landspaceButton setTitle:@"竖屏" forState:0];
//    } else {
//        [_landspaceButton setTitle:@"横屏" forState:0];
//    }
    
    CGFloat fontBtnSpaceX = xxAdaWidth(20);
    CGFloat centerSpace = (sImage.size.width/2 + fontBtnSpaceX/2);
    
    [smallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(kCellX);
        make.centerX.mas_equalTo(self).offset(-centerSpace);
        make.size.mas_equalTo(sImage.size);
    }];
    
    [bigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(smallButton);
        make.left.mas_equalTo(smallButton.mas_right).offset(fontBtnSpaceX);
        make.size.equalTo(smallButton);
    }];
    
    [smallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(smallButton.mas_bottom).offset(kCellX);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(sImage.size);
    }];
    
    xxWeakify(self)
    [[smallButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (weakself.changeSmallerFontBlock) {
            weakself.changeSmallerFontBlock();
        }
    }];
    
    [[bigButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (weakself.changeBiggerFontBlock) {
            weakself.changeBiggerFontBlock();
        }
    }];
    
//    [[_landspaceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        if (weakself.landspaceBlock) {
//            weakself.landspaceBlock();
//        }
//    }];
    
    _colorSubViews = [[NSMutableArray alloc] init];
    
    NSArray *colors = @[UIColorHex(#D9D9D9), UIColorHex(#B4AE99), UIColorHex(#B7E1B9), UIColorHex(#F9E7C0), UIColorHex(#FFCDE0)];
    
    CGFloat itemSpace = (xxScreenWidth - colors.count * kItemW) / (colors.count + 1);
    
    MAS_VIEW *prev;
    for (int i = 0; i < colors.count; i++) {
        
        UIButton *colorButton = [[UIButton alloc] init];
        colorButton.tag = i;
        colorButton.backgroundColor = colors[i];
        colorButton.layer.masksToBounds = YES;
        [colorButton setImage:UIImageWithName(@"setting_theme_selected") forState:UIControlStateSelected];
        [self addSubview:colorButton];
        
        [colorButton addTarget:self action:@selector(seletedColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [colorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kItemW, kItemW));
            make.left.equalTo(prev ? prev.mas_right : self.mas_left).offset(itemSpace);
            make.top.mas_equalTo(smallButton.mas_bottom).offset(kCellX);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-kCellX);
        }];
        colorButton.layer.cornerRadius = kItemW/2;
        
        prev = colorButton;
        
        if (kReadingManager.bgColor == i) {
            [self seletedColor:colorButton];
        }
        
        [_colorSubViews addObject:colorButton];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemSpace = (xxScreenWidth - _colorSubViews.count * kItemW) / (_colorSubViews.count + 1);
    
    MAS_VIEW *prev;
    for (int i = 0; i < _colorSubViews.count; i++) {
        
        UIButton *colorButton = _colorSubViews[i];
        
        [colorButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(prev ? prev.mas_right : self.mas_left).offset(itemSpace);
        }];
        
        prev = colorButton;
    }
}


- (void)seletedColor:(UIButton *)sender {
    
    if (sender.selected) return;
    
    sender.selected = YES;
    
    _colorSeletedButton.selected = NO;
    
    _colorSeletedButton = sender;
    
    kReadingManager.bgColor = sender.tag;
    
    //查询设置model
    BookSettingModel *model = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
    model.bgColor = sender.tag;
    [BookSettingModel encodeModel:model key:[BookSettingModel className]];
    
    //发送通知到内容页面改变背景颜色
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithChangeBg object:nil userInfo:@{kNotificationWithChangeBg:NSStringFormat(@"%ld", (long)sender.tag)}];
}

- (void)refreshColorSeleted:(NSUInteger)index {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDayAndNightBg object:nil userInfo:@{kNotificationDayAndNightBg: NSStringFormat(@"%ld", index)}];
    
    if (index == 5) {
        //黑夜
        [_colorSeletedButton setSelected:NO];
        
        //存储
        BookSettingModel *model = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
        model.bgColor = index;
        [BookSettingModel encodeModel:model key:[BookSettingModel className]];
        
    } else {
        UIButton *seletedButton = _colorSubViews[index];
        [self seletedColor:seletedButton];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
