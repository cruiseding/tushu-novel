//
//  UtilsMacro.h
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

/* ---------------------------------------- 常用封装  --------------------------------------------- */

#define UIImageWithName(imageName) [UIImage imageNamed:imageName]

#define NSURLwithString(urlString) [NSURL URLWithString:urlString]

#define MainThreadPerformBlock(block) dispatch_async(dispatch_get_main_queue(),block)

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//判断数据是否为空
static inline BOOL IsEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}


/* ---------------------------------------- 颜色 --------------------------------------------- */

#define UIColorHexAlpha(hex, alpha) [UIColorHex(hex) colorWithAlphaComponent:alpha]

#define kcolorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1.0f]

//导航栏颜色--蓝色
#define knavigationBarColor kcolorWithRGB(0.0, 153.0, 217.0)

//白色
#define kwhiteColor [UIColor whiteColor]

//黑色
#define kblackColor [UIColor blackColor]

// 一般文本色
#define knormalColor UIColorHex(#333333)

//灰色
#define kgrayColor UIColorHex(#666666)

#define klightGrayColor [UIColor lightGrayColor]

//淡黄色
#define klightYellowColor UIColorHex(#ffe5c1)

//线条颜色
#define klineColor [UIColor colorWithWhite:0.90 alpha:1]

//背景颜色
#define KbackgroundColor kcolorWithRGB(249, 249, 249)

//红色，调试
#define kredColor [UIColor redColor]

//随机颜色
#define kRandomColor ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f])

//清除颜色
#define  kclearColor [UIColor clearColor]


/* ---------------------------------------- 尺寸  --------------------------------------------- */

//获取真实屏幕宽高度
#define xxScreenWidth [UIScreen mainScreen].bounds.size.width
#define xxScreenHeight [UIScreen mainScreen].bounds.size.height

#define MINFLOAT 0.00000000001f

//不同屏幕尺寸适配（375,667是因为效果图为iPhone6plus如果不是则根据实际情况修改）
#define xxWidthRatio  (kScreenWidth / 375.0)
#define xxHeightRatio (kScreenHeight / 667.0)
#define xxAdaWidth(x)  ceilf((x) * xxWidthRatio)
#define xxAdaHeight(x) ceilf((x) * xxHeightRatio)

//字体适配(目前统一使用系统默认字体)
#define fontSize(R) [UIFont systemFontOfSize:R]

#define fontBoldSize(R) [UIFont boldSystemFontOfSize:R]

#define klineHeight (1.0f / [UIScreen mainScreen].scale)

// 获取状态栏的高度
#define STATUS_BAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)

// 获取导航栏的高度
#define NavigationBar_HEIGHT 44.0f

//tabbar高
#define TabBar_HEIGHT (STATUS_BAR_HEIGHT > 20.f ? 83.f : 49.f)

#define kSpaceX xxAdaWidth(12.0f)

//cell距离左边
#define kCellX xxAdaWidth(12.f)

//cell上下
#define kCellY xxAdaWidth(12.f)

//cell里边的图片宽度
#define kPicWidth_cell xxAdaWidth(50.0f)
//cell里边的图片高度
#define kPicHeight_cell xxAdaWidth(65.0f)

//文本之间的间隔
#define kTextInterval xxAdaWidth(5.0f)

//文字高度最大值
#define kMaxTextHeight xxAdaWidth(20.0f)

//小说内容据屏幕左右边的距离
#define kReadSpaceX xxAdaWidth(20.0f)

#define kReadingTopH xxAdaWidth(40.f)

#define kReadingBottomH xxAdaWidth(35.f)

#define kReadingFrame CGRectMake(kReadSpaceX, kReadingTopH, xxScreenWidth - kReadSpaceX*2, xxScreenHeight - kReadingTopH - kReadingBottomH)


/* ---------------------------------------- 机型 iOS版本判断 --------------------------------------------- */

/** 操作系统版本号 */
#define xx_iOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define screen_Max_length (MAX(kScreenWidth, kScreenHeight))
#define screen_Min_length (MAX(kScreenWidth, kScreenHeight))

#define xx_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define xx_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define xx_retina ([[UIScreen mainScreen] scale] >= 2.0)

/** 是否iPhone4或以下版本 */
#define xx_iPhone4_Less (xx_iPhone && screen_Max_length < 568.0)

/** 是否iPhone5或5s */
#define xx_iPhone5 (xx_iPhone && screen_Max_length == 568.0)

/** 是否iPhone6 或iPhone7 或iPhone8 */
#define xx_iPhone6 (xx_iPhone && screen_Max_length == 667.0)

/** 是否iPhone6Plus 或 iPhone7Plus 或 iPhone8Plus */
#define xx_iPhone6p (xx_iPhone && screen_Max_length == 736.0)

/** 判断是否iPhoneX */
#define xx_iPhoneX (xx_iPhone && screen_Max_length == 812.0)


/**
 *    @brief    调试输出
 */

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

#define kStart   NSDate *startTime = [NSDate date]

#define kEnd   -[startTime timeIntervalSinceNow]

#define xxWeakify(type)  __weak typeof(type) weak##type = type;

//释放
#define kDealloc(objc) objc = nil;

/*************************
 序列化和反序列化
 *************************/
#define YYModelSynthCoderAndHash \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder]; } \
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; } \
- (NSUInteger)hash { return [self modelHash]; } \
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }

#endif /* UtilsMacro_h */
