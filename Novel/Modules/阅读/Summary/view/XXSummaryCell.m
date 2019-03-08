//
//  XXSummaryCell.m
//  Novel
//
//  Created by app on 2018/1/25.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXSummaryCell.h"
#import "SummaryModel.h"

@interface XXSummaryCell()

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UIButton *iconView;

@property (nonatomic, strong) UIImageView *rightView;

@property (nonatomic, strong) UILabel *sourceLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *chapterLabel;

@property (nonatomic, strong) UILabel *currentLabel;

@property (nonatomic, strong) UIView *line;

@end

@implementation XXSummaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupViews {
    
    _container = [[UIView alloc] init];
    [self.contentView addSubview:_container];
    
    _iconView = [[UIButton alloc] init];
    _iconView.backgroundColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.00];
    _iconView.titleLabel.font = fontSize(14);
    [_container addSubview:_iconView];
    
    _sourceLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFontSize:14];
    [_container addSubview:_sourceLabel];
    
    _timeLabel = [UILabel newLabel:@"" andTextColor:klightGrayColor andFontSize:12];
    [_container addSubview:_timeLabel];
    
    _chapterLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFontSize:12];
    [_container addSubview:_chapterLabel];
    
    _currentLabel = [UILabel newLabel:@"" andTextColor:kgrayColor andFontSize:12];
    [_container addSubview:_currentLabel];
    
    _rightView = [[UIImageView alloc] initWithImage:UIImageWithName(@"cell_arrow_day")];
    [self.contentView addSubview:_rightView];
    
    _line = [UIView newLine];
    [self.contentView addSubview:_line];
}


- (void)setupLayout {
    
    CGFloat topY = xxAdaWidth(20);
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kCellX);
        make.right.mas_equalTo(_rightView.mas_left).offset(-kCellX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(topY);
        make.bottom.mas_equalTo(_chapterLabel.mas_bottom);
    }];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_container);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kCellX);
        make.size.mas_equalTo(_rightView.image.size);
    }];
    
    CGSize iconSize = UIImageWithName(@"mode_juhe").size;
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_container);
        make.left.mas_equalTo(_container.mas_left);
        make.size.mas_equalTo(iconSize);
    }];
    _iconView.layer.cornerRadius = iconSize.width/2;
    
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_container);
        make.left.mas_equalTo(_iconView.mas_right).offset(xxAdaWidth(10));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sourceLabel);
        make.left.mas_equalTo(_sourceLabel.mas_right).offset(xxAdaWidth(4)).priorityHigh();
        make.right.mas_equalTo(_currentLabel.mas_left).offset(-xxAdaWidth(5)).priorityLow();
    }];
    
    [_chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_sourceLabel.mas_bottom).offset(xxAdaWidth(8));
        make.left.equalTo(_sourceLabel);
        make.right.mas_equalTo(_currentLabel.mas_left).offset(-xxAdaWidth(5)).priorityLow();
    }];
    
    [_currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(_container);
        make.right.equalTo(_container.mas_right).priorityHigh();
    }];
    
    [_currentLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                     forAxis:UILayoutConstraintAxisHorizontal];
    
    //压缩
    [_sourceLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
    [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired/*尽量显示完整*/ forAxis:UILayoutConstraintAxisHorizontal];
    
    [_chapterLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel/*宽度不够时，可以被压缩*/ forAxis:UILayoutConstraintAxisHorizontal];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kCellX);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kCellX);
        make.height.mas_equalTo(klineHeight);
        make.top.mas_equalTo(_container.mas_bottom).offset(topY);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}


- (void)configWithModel:(id)model {
    
    if ([model isKindOfClass:[SummaryModel class]]) {
        
        SummaryModel *md = model;
        
        [_iconView setTitle:[md.source substringToIndex:1] forState:UIControlStateNormal];
        
        _sourceLabel.text = md.source;
        
        _timeLabel.text = [[DateTools shareDate] getUpdateStringWith:[DateTools dateFromString:md.updated dateformatter:kCustomDateFormat]];
        
        _chapterLabel.text = md.lastChapter;
        
        if (md.isSelect) {
            _currentLabel.text = @"当前选择";
        } else {
            _currentLabel.text = @"";
        }
    }
}







@end
