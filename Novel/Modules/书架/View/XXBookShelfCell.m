//
//  xxBookShelfCell.m
//  Novel
//
//  Created by xth on 2018/1/10.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookShelfCell.h"
#import "BookShelfModel.h"

@interface XXBookShelfCell()

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *chapterLabel;

@property (nonatomic, strong) UIImageView *updateView;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation XXBookShelfCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)handleLongPressGuesture:(UILongPressGestureRecognizer *)guesture {
    self.cellLongPress(guesture);
}

- (void)setupViews {
    
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGuesture:)];
    
    [self.contentView addGestureRecognizer:longPress];
    
    _coverView = [[UIImageView alloc] init];
    [self.contentView addSubview:_coverView];
    
    _titleLabel = [UILabel newLabel:@"" andTextColor:kblackColor andFontSize:15];
    [self.contentView addSubview:_titleLabel];
    
    _chapterLabel = [UILabel newLabel:@"" andTextColor:kgrayColor andFontSize:12];
    [self.contentView addSubview:_chapterLabel];
    
    _updateView = [[UIImageView alloc] initWithImage:UIImageWithName(@"update_image")];
    [self.contentView addSubview:_updateView];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = klineColor;
    [self.contentView addSubview:_bottomLine];
}

- (void)setupLayout {
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(kCellX);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kCellX);
        make.size.mas_equalTo(CGSizeMake(xxAdaWidth(40), xxAdaWidth(50)));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_coverView);
        make.left.mas_equalTo(_coverView.mas_right).offset(xxAdaWidth(15));
        make.right.mas_equalTo(_updateView.mas_left).offset(-xxAdaWidth(4));
    }];
    
    [_updateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(xxAdaWidth(4)).priorityHigh();
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kCellX).priorityLow(); //必须设置优先级低
    }];
    
    //宽度不够时，可以被压缩
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                forAxis:UILayoutConstraintAxisHorizontal];

    //不可以被压缩，尽量显示完整
    [_updateView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [_chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(kCellX);
        make.left.equalTo(_titleLabel);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kCellX);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(klineHeight);
        make.top.mas_equalTo(_coverView.mas_bottom).offset(kCellX);
        make.left.equalTo(_coverView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kCellX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)configWithModel:(id)model {
    
    if ([model isKindOfClass:[BookShelfModel class]]) {
        
        BookShelfModel *md = model;
        
        [_coverView pin_setImageFromURL:NSURLwithString(md.coverURL) placeholderImage:UIImageWithName(@"default_book_cover")];
        
        _titleLabel.text = md.title;
        
        //updateView status=0 -->NO 不显示  status=1 -->YES 显示
        if (1 == [md.status integerValue]) {
            _updateView.hidden = NO;
        } else {
            _updateView.hidden = YES;
        }
        
        _chapterLabel.text = NSStringFormat(@"%@ %@",[[[DateTools shareDate] getUpdateStringWith:[DateTools dateFromString:md.updated dateformatter:kCustomDateFormat]] stringByAppendingString:@"更新"],md.lastChapter);
    }
}


@end
