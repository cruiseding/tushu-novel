//
//  RegExp.m
//  SeafoodHome
//
//  Created by btw on 15/1/4.
//  Copyright (c) 2015年 beautyway. All rights reserved.
//

#import "RegExpValidate.h"

@implementation RegExpValidate

// 判断空格，只能全部是空格
+ (BOOL)validateSpace:(NSString *)str {
    NSString *passwordRegex = @"\\s+";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:str];
}
//验证n-m位数字和字符密码
+ (BOOL)validatePassword:(NSString *)password from:(NSInteger)from to:(NSInteger)to; {
    
    NSString *passwordRegex = [NSString stringWithFormat:@"^[a-zA-Z0-9]{%ld,%ld}$",(long)from, (long)to];
    
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    
    return [passwordTest evaluateWithObject:password];
}

//6位数字密码
+ (BOOL)validateSixPassword:(NSString *)password {
    NSString *passwordRegex = @"\\d{6}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:password];
}

//6-12位数字密码
+ (BOOL)validateSixAndTwePassword:(NSString *)password {
    NSString *passwordRegex = @"\\d{6,12}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:password];
}

//正浮点数 >0
+ (BOOL)validateNum:(NSString *)num {
    NSString *number = @"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [passwordTest evaluateWithObject:num];
}
//非负浮点数（正浮点数 + 0）
+ (BOOL)validateZeroNum:(NSString *)num {
    NSString *number = @"^\\d+(\\.\\d+)?$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [passwordTest evaluateWithObject:num];
}

//邮箱
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

// 电话号码
+ (BOOL)validatePhoneNumber:(NSString *)phoneNum {
    //验证输入的固话中不带 "-"符号
    
    NSString * strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$)";
    
    //验证输入的固话中带 "-"符号
    
    //NSString * strNum = @"^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    
    return [checktest evaluateWithObject:phoneNum];
}

//车牌号验证
+ (BOOL)validateCarNo:(NSString *)carNo {
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

//车型
+ (BOOL)validateCarType:(NSString *)CarType {
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}

//用户名
+ (BOOL)validateUserName:(NSString *)name {
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//密码
+ (BOOL)validatePassword:(NSString *)passWord {
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//昵称
+ (BOOL)validateNickname:(NSString *)nickname {
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard {
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

// 金钱
+ (BOOL)validateMoney:(NSString *)money {
    NSString *reg1 = @"^[0-9]+\\.[0-9]{0,2}$";
    NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg1];
    
    NSString *reg2 = @"^\\d+$";
    NSPredicate *pre2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg2];
    
    NSString *reg3 = @"^0{2,}$";
    NSPredicate *pre3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg3];
    
    if (([pre1 evaluateWithObject:money] || [pre2 evaluateWithObject:money]) && (![pre3 evaluateWithObject:money])) {
        return YES;
    }

    return NO;
}

// 腾讯QQ号 (腾讯QQ号从10000开始)
+ (BOOL)validateQQNumber:(NSString *)QQNumber {
    NSString *regex = @"^[1-9][0-9]{4,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:QQNumber];
}

// 中国邮政编码 (中国邮政编码为6位数字)
+ (BOOL)validateZipCode:(NSString *)zipCode {
    NSString *regex = @"^[1-9]\\d{5}(?!\\d)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:zipCode];
}

// IP地址 (提取IP地址时有用)
+ (BOOL)validateIPAddress:(NSString *)IPAddress {
    NSString *regex = @"^\\d+\\.\\d+\\.\\d+\\.\\d+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:IPAddress];
}


// InternetURL
+ (BOOL)validateInternetURL:(NSString *)internetURL {
    NSString *regex = @"([a-zA-z]+://[^\\s]*)|(^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:internetURL];
}

// 验证银行卡号
+ (BOOL)validateBankAccountNumber:(NSString *)bankAccountNumber {
    NSString *regex = @"^(\\d{16}|\\d{19})$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:bankAccountNumber];
}

@end
