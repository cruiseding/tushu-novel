//
//  ASNetworkImageNode+NewNetworkImageNode.m
//  Novel
//
//  Created by xth on 2018/1/13.
//  Copyright © 2018年 th. All rights reserved.
//

#import "ASNetworkImageNode+NewNetworkImageNode.h"

@implementation ASNetworkImageNode (NewNetworkImageNode)

+ (ASNetworkImageNode *)newNetworkImageNodeWithURL:(NSString *)urlString placeholderImageName:(NSString *)imageName {
    
    ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc] init];
    imageNode.URL = NSURLwithString(urlString);
    imageNode.defaultImage = UIImageWithName(imageName);
    imageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
    return imageNode;
}

@end
