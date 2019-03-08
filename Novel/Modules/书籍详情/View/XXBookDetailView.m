//
//  XXBookDetailView.m
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#define kLeftX xxAdaWidth(20.f)

#import "XXBookDetailView.h"
#import "BookDetailModel.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface XXBookDetailView()

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UIView *introView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *authorLabel;

@property (nonatomic, strong) UILabel *updateLabel;

/** after update */
@property (nonatomic, strong) XXHighLightButton *afterBtn;

/** read */
@property (nonatomic, strong) XXHighLightButton *readingBtn;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UILabel *followerLabel;

@property (nonatomic, strong) UILabel *retentionLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) TTGTextTagCollectionView *tagsView;

@property (nonatomic, strong) NSMutableArray *colors;

@property (nonatomic, strong) UILabel *shortLabel;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UILabel *interestLabel;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) XXRecommendView *recommendView;

@property (nonatomic, strong) BookDetailModel *model;

@end

@implementation XXBookDetailView

- (NSMutableArray *)colors {
    if (!_colors) {
        
        _colors = [[NSMutableArray alloc] init];
        
        NSArray *temps = @[kcolorWithRGB(146, 197, 238), kcolorWithRGB(192, 104, 208), kcolorWithRGB(245, 188, 120), kcolorWithRGB(145, 206, 213), kcolorWithRGB(103, 204, 183), kcolorWithRGB(231, 143, 143)];
        
        for (int i = 0; i < 10; i++) {
            [_colors addObjectsFromArray:temps];
        }
    }
    return _colors;
}

- (void)setupViews {
    
    _coverView = [[UIImageView alloc] init];
    [self.contentView addSubview:_coverView];
    
    _introView = [[UIView alloc] init];
    [self.contentView addSubview:_introView];
    
    _titleLabel = [UILabel newLabel:@"" andTextColor:kblackColor andFontSize:16];
    [_introView addSubview:_titleLabel];
    
    _authorLabel = [[UILabel alloc] init];
    [_introView addSubview:_authorLabel];
    
    _updateLabel = [UILabel newLabel:@"" andTextColor:kgrayColor andFontSize:12];
    [_introView addSubview:_updateLabel];
    
//    _afterBtn = [XXHighLightButton newButtonTitle:@"+ 追更新" font:15 normarlColor:knormalColor];
    _afterBtn = [[XXHighLightButton alloc] init];
    [_afterBtn setTitle:@"+ 加入书架" forState:0];
    _afterBtn.titleLabel.font = fontSize(15);
    [_afterBtn setTitleColor:knormalColor forState:0];
    _afterBtn.layer.cornerRadius = xxAdaWidth(5);
    _afterBtn.layer.borderWidth = klineHeight;
    _afterBtn.layer.borderColor = [UIColor colorWithRed:0.36 green:0.27 blue:0.34 alpha:1.00].CGColor;
    [self.contentView addSubview:_afterBtn];
    
    _readingBtn = [XXHighLightButton newButtonTitle:@"开始阅读" font:16 normarlColor:kwhiteColor];
    _readingBtn.layer.cornerRadius = xxAdaWidth(5);
    _readingBtn.layer.borderWidth = klineHeight;
    _readingBtn.backgroundColor = [UIColor colorWithRed:0.36 green:0.27 blue:0.34 alpha:1.00];
    [self.contentView addSubview:_readingBtn];
    
    _topLine = [UIView newLine];
    [self.contentView addSubview:_topLine];
    
    _followerLabel = [UILabel newLabel:@"暂无数据" andTextColor:kgrayColor andFontSize:15];
    _followerLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_followerLabel];
    
    _retentionLabel = [UILabel newLabel:@"暂无数据" andTextColor:kgrayColor andFontSize:15];
    _retentionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_retentionLabel];
    
    _countLabel = [UILabel newLabel:@"暂无数据" andTextColor:kgrayColor andFontSize:15];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_countLabel];
    
    _tagsView = [[TTGTextTagCollectionView alloc] init];
    [self.contentView addSubview:_tagsView];
    
    _shortLabel = [UILabel newLabel:@"" andTextColor:knormalColor andFontSize:13];
    _shortLabel.numberOfLines = 0;
    [self.contentView addSubview:_shortLabel];
    
    _bottomLine = [UIView newLine];
    [self.contentView addSubview:_bottomLine];
    
    _interestLabel = [UILabel newLabel:@"你可能感兴趣" andTextColor:kblackColor andFontSize:14];
    [self.contentView addSubview:_interestLabel];
    
    _moreBtn = [UIButton newButtonTitle:@"更多" font:14 normarlColor:kgrayColor];
    [self.contentView addSubview:_moreBtn];
    
    _recommendView = [[XXRecommendView alloc] init];
    [self.contentView addSubview:_recommendView];
}


- (void)setupLayout {
    
    CGFloat introverSpace = xxAdaWidth(6);
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(kLeftX);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kLeftX);
        make.size.mas_equalTo(CGSizeMake(xxAdaWidth(60), xxAdaWidth(80)));
    }];
    
    [_introView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_coverView);
        make.left.mas_equalTo(_coverView.mas_right).offset(kLeftX);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kLeftX);
        make.bottom.mas_equalTo(_updateLabel.mas_bottom);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_introView);
    }];
    
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(introverSpace);
        make.left.right.equalTo(_introView);
    }];
    
    [_updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_authorLabel.mas_bottom).offset(introverSpace);
        make.left.right.equalTo(_introView);
    }];
    
    [_afterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverView.mas_bottom).offset(kLeftX);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kLeftX);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5).offset(-kLeftX-kLeftX*0.5);
        make.height.mas_equalTo(xxAdaWidth(50));
    }];
    
    [_readingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_afterBtn);
        make.left.mas_equalTo(_afterBtn.mas_right).offset(kLeftX);
        make.size.equalTo(_afterBtn);
    }];
    
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_afterBtn.mas_bottom).offset(xxAdaWidth(30));
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(xxAdaWidth(10));
    }];
    
    UIView *tempView = nil;
    
    for (int i = 0; i < 3; i++) {
        
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        
        UILabel *titleLabel = [UILabel newLabel:@"" andTextColor:kgrayColor andFontSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topLine.mas_bottom);
            make.left.mas_equalTo(tempView ? tempView.mas_right : self.contentView.mas_left);
            make.width.mas_equalTo(self.contentView.mas_width).dividedBy(3);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(kLeftX);
            make.left.right.equalTo(view);
        }];
        
        if (i == 0) {
            
            titleLabel.text = @"追书人数";
            
            [view addSubview:_followerLabel];
            
            [_followerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(titleLabel.mas_bottom).offset(xxAdaWidth(6));
                make.left.right.equalTo(view);
            }];
            
        } else if (i == 1) {
            
            titleLabel.text = @"读者留存率";
            
            [view addSubview:_retentionLabel];
            [_retentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(titleLabel.mas_bottom).offset(xxAdaWidth(6));
                make.left.right.equalTo(view);
            }];
            
        } else if (i == 2) {
            
            titleLabel.text = @"更新字数/天";
            
            [view addSubview:_countLabel];
            [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(titleLabel.mas_bottom).offset(xxAdaWidth(6));
                make.left.right.equalTo(view);
            }];
        }
        
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_followerLabel.mas_bottom).offset(kLeftX);
        }];
        
        tempView = view;
    }
    
    UIView *line_1 = [UIView newLine];
    [self.contentView addSubview:line_1];
    
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kLeftX);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kLeftX);
        make.height.mas_equalTo(klineHeight);
    }];
    
    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_1.mas_bottom).offset(kCellX);
        make.left.right.equalTo(line_1);
    }];
    
    UIView *line_2 = [UIView newLine];
    [self.contentView addSubview:line_2];
    
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tagsView.mas_bottom).offset(kCellX);
        make.left.right.equalTo(line_1);
        make.height.mas_equalTo(klineHeight);
    }];
    
    [_shortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_2.mas_bottom).offset(kCellX);
        make.left.right.equalTo(line_2);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shortLabel.mas_bottom).offset(xxAdaWidth(8));
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(xxAdaWidth(10));
    }];
    
    [_interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomLine.mas_bottom).offset(kLeftX);
        make.left.equalTo(line_2);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_interestLabel);
        make.right.equalTo(line_2);
    }];
    [_moreBtn setEnlargeEdgeWithTop:kLeftX right:kLeftX bottom:kLeftX left:kLeftX];
    
    [_recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_interestLabel.mas_bottom).offset(kCellX);
        make.left.right.equalTo(line_2);
        make.height.mas_equalTo(kRecomentItemH);
        make.bottom.equalTo(self.contentView).offset(-kLeftX);
    }];
    
    self.contentView.hidden = YES;
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
    
    _tagsView.enableTagSelection = NO;
    
    //外边距
    _tagsView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //间距
    _tagsView.horizontalSpacing = xxAdaWidth(15);
    
    _tagsView.verticalSpacing = xxAdaHeight(10);
    
    _tagsView.alignment = TTGTagCollectionAlignmentLeft;
    _tagsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSUInteger location = 0;
    NSUInteger length = 1;
    
    //移除所有的标签
    [_tagsView removeAllTags];
    
    for (int i = 0; i < _model.tags.count; i++) {
        
        textConfig.tagBackgroundColor = self.colors[i];
        
        [_tagsView addTags:[_model.tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[textConfig copy]];
        location += length;
    }
    
    [_tagsView reload];
}

- (void)configEvent {
    
    xxWeakify(self)

    [[_afterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {

        [weakself afterAction];
    }];
    
    [[_readingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (weakself.didClickDelegate) {
            [weakself.didClickDelegate sendNext:[NSNumber numberWithInteger:kBookDetailType_read]];
        }
    }];
    
    [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (weakself.didClickDelegate) {
            [weakself.didClickDelegate sendNext:[NSNumber numberWithInteger:kBookDetailType_recommendMore]];
        }
    }];
    
    _recommendView.delegate = [RACSubject subject];
    
    [_recommendView.delegate subscribeNext:^(id  _Nullable x) {
        
        BooksListItemModel *md = x;
        if (weakself.didClickDelegate) {
            [weakself.didClickDelegate sendNext:md];
        }
    }];
}

#pragma mark - 添加/移除 操作
- (void)afterAction {
    //    加入书架，包含id,coverURL,title, lastChapter, updated, chapter，page
    
    BOOL res = [SQLiteTool isTableOK:self.model._id];
    
    if (res) {
        //存在，则删除
        [SQLiteTool deleteTableName:self.model._id indatabasePath:kShelfPath];
        
        [self.afterBtn setTitle:@"+ 加入书架" forState:UIControlStateNormal];
        [self.readingBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
        
    } else {
        //不存在，则添加
        BookShelfModel *model = [BookShelfModel new];
        model.id = self.model._id;
        model.coverURL = NSStringFormat(@"%@%@",statics_URL,self.model.cover);
        model.title = self.model.title;
        model.lastChapter = self.model.lastChapter;
        model.updated = self.model.updated;
        model.status = @"1";
        model.chapter = @"0";
        model.page = @"0";
        model.summaryId = @"";
        
        [SQLiteTool addShelfWithModel:model];
        
        [self.afterBtn setTitle:@"- 不追了" forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBookShelf" object:nil];
}

- (void)configWithModel:(id)model {
    if ([model isKindOfClass:[BookDetailModel class]]) {
        
        [self removeEmpty];
        
        _model = model;
        
        self.contentView.hidden = NO;
        
        BOOL res = [SQLiteTool isTableOK:_model._id];
        
        if (res) {
            [_afterBtn setTitle:@"- 移除书架" forState:UIControlStateNormal];
            
            BookShelfModel *shelfModel = [SQLiteTool getBookWithTableName:_model._id];
            
            if ([shelfModel.chapter integerValue] > 0 || [shelfModel.page integerValue] > 0) {
                [_readingBtn setTitle:@"继续阅读" forState:UIControlStateNormal];
            }
        }
        
        [_coverView pin_setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", statics_URL, _model.cover]] placeholderImage:UIImageWithName(@"default_book_cover")];
        
        _titleLabel.text = _model.title;
        
        NSString *str = [NSString stringWithFormat:@"%@ | %@ | %@", _model.author, _model.cat, [_model getBookWordCount]];
        
        NSMutableAttributedString *titleAttri = [[NSMutableAttributedString alloc] initWithString:str];
        titleAttri.font = fontSize(14);
        titleAttri.color = kgrayColor;
        [titleAttri setColor:[UIColor colorWithRed:0.71 green:0.13 blue:0.13 alpha:1.00] range:NSMakeRange(0, _model.author.length)];
        
        _authorLabel.attributedText = titleAttri;
        
        if (_model.isSerial) {
            _updateLabel.text = [[[DateTools shareDate] getUpdateStringWith:[DateTools dateFromString:_model.updated dateformatter:kCustomDateFormat]] stringByAppendingString:@"更新"];
        } else {
            _updateLabel.text = @"已完结";
        }
        
        _followerLabel.text = NSStringFormat(@"%zi", _model.latelyFollower);
        _retentionLabel.text = NSStringFormat(@"%@", _model.retentionRatio.length > 0 ? _model.retentionRatio : @"暂未统计");
        
        if (_model.serializeWordCount > 0) {
            _countLabel.text = [NSString stringWithFormat:@"%zi", _model.serializeWordCount];
        } else {
            _countLabel.text = @"暂未统计";
        }
        
        [self configTag];
        
        NSMutableAttributedString *shortAtt = [[NSMutableAttributedString alloc] initWithString:_model.longIntro];
        shortAtt.font = fontSize(13);
        shortAtt.color = knormalColor;
        shortAtt.lineSpacing = xxAdaWidth(3);
        
        _shortLabel.attributedText = shortAtt;
    }
}

- (void)configRecommendDatas:(NSArray *)datas {
    [self.recommendView configDatas:datas];
}

- (void)dealloc {
    [_didClickDelegate sendCompleted];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
