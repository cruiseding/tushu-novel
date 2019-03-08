//
//  XXBookListCellNode.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#define spaceX xxAdaWidth(10)
#define coverW xxAdaWidth(50)

#import "XXBookListCellNode.h"
#import "BooksListModel.h"

@interface XXBookListCellNode()

@property (nonatomic, strong) ASNetworkImageNode *coverNode;

@property (nonatomic, strong) ASTextNode *titleNode;

@property (nonatomic, strong) ASTextNode *authorNode;

@property (nonatomic, strong) ASTextNode *shortNode;

@property (nonatomic, strong) ASTextNode *numberNode;

@property (nonatomic, strong) ASDisplayNode *bottomNode;

@end

@implementation XXBookListCellNode

- (void)setupNodes {
    
    BooksListItemModel *md = self.model;
    
    _coverNode = [ASNetworkImageNode newNetworkImageNodeWithURL:NSStringFormat(@"%@%@",statics_URL, md.cover) placeholderImageName:@"default_book_cover"];
    _coverNode.style.preferredSize = CGSizeMake(coverW, xxAdaWidth(65.f));
    [self addSubnode:_coverNode];
    
    _titleNode = [ASTextNode newTextNodeTile:md.title font:14 textColor:knormalColor maxnumberLine:1 lineSpace:0];
    [self addSubnode:_titleNode];
    
    NSString *author = @"";
    
    if (md.cat.length == 0) {
        author = [NSString stringWithFormat:@"%@",md.author];
    } else {
        author = [NSString stringWithFormat:@"%@ | %@",md.author,md.cat];
    }
    
    _authorNode = [ASTextNode newTextNodeTile:author font:13 textColor:klightGrayColor maxnumberLine:1 lineSpace:0];
    [self addSubnode:_authorNode];
    
    _shortNode = [ASTextNode newTextNodeTile:md.shortIntro font:13 textColor:klightGrayColor maxnumberLine:1 lineSpace:0];
    [self addSubnode:_shortNode];
    
    NSString *number = @"";
    if (md.retentionRatio == 0) {
        number = [NSString stringWithFormat:@"%@人在追",md.latelyFollower];
    } else {
        number = [NSString stringWithFormat:@"%@人在追 | %@%@读者存留",md.latelyFollower,md.retentionRatio,@"%"];
    }

    _numberNode = [ASTextNode newTextNodeTile:number font:13 textColor:UIColorHexAlpha(#666666, 0.7) maxnumberLine:1 lineSpace:0];
    [self addSubnode:_numberNode];
    
    _bottomNode = [[ASDisplayNode alloc] init];
    _bottomNode.backgroundColor = klineColor;
    [self addSubnode:_bottomNode];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    CGFloat titleWidth = constrainedSize.max.width - coverW - spaceX - kCellX*2;
    
    _titleNode.style.maxSize = CGSizeMake(titleWidth, HUGE);
    _authorNode.style.maxSize = CGSizeMake(titleWidth, HUGE);
    _shortNode.style.maxSize = CGSizeMake(titleWidth, HUGE);
    _numberNode.style.maxSize = CGSizeMake(titleWidth, HUGE);
    _bottomNode.style.preferredSize = CGSizeMake(constrainedSize.max.width - kCellX*2, klineHeight);
    
    ASStackLayoutSpec *rightSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:xxAdaWidth(4) justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[_titleNode, _authorNode, _shortNode, _numberNode]];
    
    ASStackLayoutSpec *topSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:spaceX justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_coverNode, rightSpec]];
    
    ASStackLayoutSpec *contentSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:kCellX justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[topSpec, _bottomNode]];
    
    ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(spaceX, kCellX, 0, kCellX) child:contentSpec];
    
    return inset;
}


@end
