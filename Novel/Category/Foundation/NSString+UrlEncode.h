//
//  NSString+UrlEncode.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (UrlEncode)

- (NSString *)urlEncode;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)urlDecode;
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding;

- (NSDictionary *)dictionaryFromURLParameters;

@end

@interface NSString (url)
/** <字符串编码> */
-(NSString *)strUTF8String;
/** <将字符串转URL> */
-(NSURL *)onURLByStrig;
@end


@interface NSString (data)
/** <将字符串转data> */
-(NSData *)dataUTF8String;
@end


@interface NSURL (string)
/** <将URL转字符串> */
-(NSString *)onStringByURL;
@end



@interface NSString (Separated)

-(NSArray *)onArraybyString:(NSString *)string;

@end
















