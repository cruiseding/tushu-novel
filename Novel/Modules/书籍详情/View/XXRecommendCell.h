//
//  XXRecommendCell.h
//  Novel
//
//  Created by app on 2018/1/16.
//  Copyright © 2018年 th. All rights reserved.
//

#define kCoverW 60
#define kCoverH 80
#define RlineSpace 5
#define RlabelH 20

#define kRecomentItemW kCoverW
#define kRecomentItemH kCoverH + RlabelH + 1

#import <UIKit/UIKit.h>
#import "BooksListModel.h"

@interface XXRecommendCell : UICollectionViewCell

@property (nonatomic, strong) BooksListItemModel *model;

@end
