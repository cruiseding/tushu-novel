//
//  XXDirectoryCell.m
//  Novel
//
//  Created by app on 2018/1/19.
//  Copyright © 2018年 th. All rights reserved.
//

#define kLeftX xxAdaWidth(20)

#import "XXDirectoryCell.h"

@interface XXDirectoryCell()

@property (nonatomic, strong) UIImageView *preView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) UIView *line;

@end

@implementation XXDirectoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setupViews {
    //设置选中背景颜色
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00];
    
    _preView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"directory_not_previewed"]];
    [self.contentView addSubview:_preView];

    _titleLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFontSize:12];
    [self.contentView addSubview:_titleLabel];
    
    _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_day"]];
    [self.contentView addSubview:_arrowView];
    
    _line = [UIView newLine];
    [self.contentView addSubview:_line];
}

- (void)setupLayout {
    
    CGFloat topInset = xxAdaWidth(15);
    
    [_preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(topInset);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kLeftX);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_preView);
        make.left.mas_equalTo(_preView.mas_right).offset(xxAdaWidth(10));
        make.right.mas_lessThanOrEqualTo(_arrowView.mas_left).offset(-topInset);
    }];
    
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_preView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kLeftX);
    }];
    
    //宽度不够时，可以被压缩
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.right.equalTo(_arrowView);
        make.height.mas_equalTo(klineHeight);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)configTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath {
    
    _preView.image = [UIImage imageNamed:@"directory_not_previewed"];
    
    _titleLabel.text = title;
    
    if ([ReadingManager shareReadingManager].chapter == indexPath.row) {
        _preView.image = [UIImage imageNamed:@"bookDirectory_selected"];
    }
}


@end
