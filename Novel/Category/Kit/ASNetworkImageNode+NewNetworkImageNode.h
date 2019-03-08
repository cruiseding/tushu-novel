//
//  ASNetworkImageNode+NewNetworkImageNode.h
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASNetworkImageNode (NewNetworkImageNode)

+ (ASNetworkImageNode *)newNetworkImageNodeWithURL:(NSString *)urlString placeholderImageName:(NSString *)imageName;

@end
