//
//  NSString+UrlEncode.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//


#import "NSString+UrlEncode.h"

@implementation NSString (UrlEncode)

- (NSString *)urlEncode {
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                (__bridge CFStringRef)self,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)urlDecode {
    return [self urlDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding {
	return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
             (__bridge CFStringRef)self,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSDictionary *)dictionaryFromURLParameters
{
    NSMutableDictionary * parametersDictionary = [NSMutableDictionary dictionary];
    NSURL *url =[[NSURL alloc]initWithString:self];
    NSArray *queryComponents = [url.query componentsSeparatedByString:@"&"];
    for (NSString * queryComponent in queryComponents) {
        NSString * key = [queryComponent componentsSeparatedByString:@"="].firstObject;
        NSString * value = [queryComponent substringFromIndex:(key.length + 1)];
        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [parametersDictionary setObject:value forKey:key];
    }
    
    
    return parametersDictionary;

   
}

@end


@implementation NSString (url)

-(NSString *)strUTF8String{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    return [NSString stringWithCString:[self UTF8String] encoding:NSUnicodeStringEncoding];
}

-(NSURL *)onURLByStrig{
    NSURL *url = [NSURL URLWithString:self];
    return url?url:nil;
}


@end


@implementation NSString (data)

-(NSData *)dataUTF8String{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}


@end


@implementation NSURL (string)

-(NSString *)onStringByURL{
    NSString *string = self.absoluteString;
    return string?string:nil;
}

@end


@implementation NSString (Separated)
-(NSArray *)onArraybyString:(NSString *)string{
    NSArray *array = [self componentsSeparatedByString:string];
    return array?array:nil;
}

@end
