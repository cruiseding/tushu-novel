//
//  XXRankingCell.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXRankingCell.h"
#import "RankingModel.h"

@interface XXRankingCell()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation XXRankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupViews {
    
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    
    _titleLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFontSize:14];
    [self.contentView addSubview:_titleLabel];
    
    _bottomLine = [UIView newLine];
    [self.contentView addSubview:_bottomLine];
}

- (void)setupLayout {
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(xxAdaWidth(10));
        make.left.mas_equalTo(self.contentView.mas_left).offset(kCellX);
        make.size.mas_equalTo(CGSizeMake(xxAdaWidth(30.0f), xxAdaWidth(30.0f)));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).offset(xxAdaWidth(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-xxAdaWidth(10));
        make.centerY.equalTo(_iconView);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.top.mas_equalTo(_iconView.mas_bottom).offset(xxAdaWidth(10));
        make.left.equalTo(_iconView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(klineHeight);
    }];
}

- (void)configWithModel:(id)model {
    if ([model isKindOfClass:[RankingDeModel class]]) {
        
        RankingDeModel *md = model;
        
        if (md.cover && !md.collapse) {
            [_iconView pin_setImageFromURL:NSURLwithString(md.cover) placeholderImage:UIImageWithName(@"default_book_cover")];
        } else if (md.isMoreItem) {
            _iconView.image = UIImageWithName(@"ranking_other");
        } else {
            _iconView.image = nil;
        }
        
        _titleLabel.text = md.title;
    }
}


@end
