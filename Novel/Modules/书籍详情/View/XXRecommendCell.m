//
//  XXRecommendCell.m
//  Novel
//
//  Created by app on 2018/1/16.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXRecommendCell.h"

@interface XXRecommendCell()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *coverView;

@end

@implementation XXRecommendCell

- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
    }
    return _coverView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel newLabel:@"" andTextColor:kblackColor andFontSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.coverView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(BooksListItemModel *)model {
    _model = model;
    
    self.coverView.frame = CGRectMake(0, 0, kCoverW, kCoverH);
    
    [_coverView pin_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", statics_URL, model.cover]] placeholderImage:UIImageWithName(@"default_book_cover")];
    
    _titleLabel.frame = CGRectMake(0, _coverView.bottom + RlineSpace, kCoverW, RlabelH);
    
    _titleLabel.text = model.title;
}

@end
