//
//  RegExpValidateFormat.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/7.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegExpValidateFormat : NSObject

/** 传递一个UITextField的指针，限制成金钱的字符串格式。 */
+ (void)formatToPriceStringWithTextField:(UITextField *)textField;

@end
