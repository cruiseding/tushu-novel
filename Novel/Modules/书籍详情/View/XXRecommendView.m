//
//  XXRecommendView.m
//  Novel
//
//  Created by app on 2018/1/16.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXRecommendView.h"

@interface XXRecommendView() <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation XXRecommendView

// 注意const的位置
static NSString *const cellId = @"RecommendViewID";
static NSString *const headerId = @"RecommendViewHeaderID";
static NSString *const footerId = @"RecommendViewFooterID";


- (void)configDatas:(NSArray *)datas {
    
    _datas = datas;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //自定义布局对象
        UICollectionViewFlowLayout *customLaout = [[UICollectionViewFlowLayout alloc] init];
        
        //每个cell格子的宽高
        customLaout.itemSize = CGSizeMake(kRecomentItemW, kRecomentItemH);
        
        customLaout.minimumLineSpacing = xxAdaWidth(10); //行间距
        customLaout.minimumInteritemSpacing = 0; //列间距
        
        //滚动方向
        customLaout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:customLaout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //是否可以滚动
        //        _collectionView.scrollEnabled = NO;
        
        _collectionView.dataSource = self;
        
        _collectionView.delegate = self;
        
        [self addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //注册cell、sectionHeader、sectionFooter
        [_collectionView registerClass:[XXRecommendCell class] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XXRecommendCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.model = _datas[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
//选中某个item时触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate) {
        [_delegate sendNext:_datas[indexPath.item]];
    }
}

- (void)dealloc {
    if (_delegate) {
        [_delegate sendCompleted];
    }
}


@end
