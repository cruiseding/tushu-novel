//
//  ASBaseCellNode.h
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASBaseCellNode : ASCellNode

- (instancetype)initWithModel:(id)model;

@property (nonatomic, strong) id model;

@end
