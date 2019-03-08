//
//  UIImage+Tool.h
//  xx
//
//  Created by th on 2017/4/23.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

/** 提取对应图片的主要颜色 */
-(UIColor*)mostColor;

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize;


/**
 图片自适应
 */
- (UIImage *)rescaleImageToSize:(CGSize)size;

/**
 *  按图片的比例，根据宽取得 按比例的高
 *
 *  @param width 宽
 *
 *  @return 高
 */
- (CGFloat)InProportionAtWidth:(CGFloat)width;

/**
 *  取图片的比例，根据高取得 按比例的宽
 *
 *  @param height 高
 *
 *  @return 宽
 */
- (CGFloat)InProportionAtHeight:(CGFloat)height;

/** 压缩图片*/
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
/**
 *  压缩图片UIImageJPEGRepresentation
 */
+ (NSData *)imageData:(UIImage *)myimage;


/**
 传入颜色生成图片

 @param color 颜色
 @return UIImage
 */
+ (UIImage *) createImageWithColor:(UIColor *)color;

/**
 通过图片Data数据第一个字节 来获取图片扩展名

 @param data 数据
 @return 图片类型,eg.png、gif、jpg...
 */
+ (NSString *)contentTypeForImageData:(NSData *)data;

@end
