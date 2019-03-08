//
//  xxBookShelfCell.h
//  Novel
//
//  Created by xth on 2018/1/10.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface XXBookShelfCell : BaseTableViewCell

@property (nonatomic, copy) void(^cellLongPress)(UILongPressGestureRecognizer *longPress);

@end
