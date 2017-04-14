//
//  WhiteImageUtility.m
//  ps美白术
//
//  Created by 9188 on 2017/4/11.
//  Copyright © 2017年 朱同海. All rights reserved.
//

#import "HImageUtility.h"
#import "ColorUtils.h"

@implementation HImageUtility
/////////////////////////////////////为了每个模块容易理解   代码不封装了//////////////////////////////////////////////////////////
/////////////////////////////////////图片美白//////////////////////////////////////////////////////////
/// 美白
+ (UIImage *)whiteImageWithName:(NSString *)imageName  Whiteness:(int)whiteness {

    if (!whiteness || whiteness < 10 ||  whiteness > 150) {
        return [UIImage imageNamed:imageName];
    }
    
    // 1.拿到图片，获取宽高
    CGImageRef imageRef = [UIImage imageNamed:imageName].CGImage;
    NSInteger width = CGImageGetWidth(imageRef);
    NSInteger height = CGImageGetHeight(imageRef);
    
    // 2:创建颜色空间（灰色空间， 彩色空间）->  开辟一块内存空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();

    
    // 3:创建图片上下文
    // 为什么是UInt32类型，即是无符号32为int型 取值范围就是0-255之间
    // inputPixels是像素点集合的首地址
    UInt32 * inputPixels = (UInt32*)calloc(width * height, sizeof(UInt32));

    CGContextRef contextRef = CGBitmapContextCreate(inputPixels,
                                                    width,
                                                    height,
                                                    8, // 固定写法  8位
                                                    width * 4, // 每一行的字节  宽度 乘以32位 = 4字节
                                                    colorSpaceRef,
                                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big); // 自己查咯
    
    // 4:根据图片上线纹绘制图片
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    
    // 5：循环遍历每个像素点进行修改
    for (int i = 0; i < height; i ++) {
        for (int j = 0; j <  width; j ++) {
            UInt32 * currentPixels = inputPixels + (i * width) + j; // 改变指针的指向  每一个像素点都能遍历到了
            UInt32 color = *currentPixels;
            
            UInt32 colorA,colorR,colorG,colorB;
            
            colorR = R(color);   // 此处宏定义  计算RGBA的值  是通过位运算算的  自己百度咯
            colorR = colorR + whiteness;
            colorR = colorR > 255 ? 255 : colorR;
            
            colorG = G(color);
            colorG = colorG + whiteness;
            colorG = colorG > 255 ? 255 : colorG;
            
            colorB = B(color);
            colorB = colorB + whiteness;
            colorB = colorB > 255 ? 255 : colorB;
            
            colorA = A(color);
            *currentPixels = RGBAMake(colorR, colorG, colorB, colorA);
        }
    }
    
    
    // 6：创建Image对象
    CGImageRef newImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage * newImage = [UIImage imageWithCGImage:newImageRef];
    
    // 7：释放内存
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRelease(contextRef);
    CGImageRelease(newImageRef);
    free(inputPixels);
    
    return newImage;
}

/////////////////////////////////////图片磨皮//////////////////////////////////////////////////////////
+ (UIImage *)dermabrasionImage:(UIImage *)image  touch:(UITouch *)touch view:(UIView *)view {
    int whiteness = 20; // 越大美白月明显
    // 1.拿到图片，获取宽高
    CGImageRef imageRef = image.CGImage;
    NSInteger width = CGImageGetWidth(imageRef);
    NSInteger height = CGImageGetHeight(imageRef);
    
    // 2:创建颜色空间（灰色空间， 彩色空间）->  开辟一块内存空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    
    // 3:创建图片上下文
    UInt32 * inputPixels = (UInt32*)calloc(width * height, sizeof(UInt32));
    
    CGContextRef contextRef = CGBitmapContextCreate(inputPixels,
                                                    width,
                                                    height,
                                                    8,
                                                    width * 4,
                                                    colorSpaceRef,
                                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // 4:根据图片上线纹绘制图片
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    
    
    // 5.0 获取点击的坐标
    CGPoint currentPoint = [touch locationInView:touch.view];
    
    // 图片大小  和imageView的大小不一致   且能获取到的坐标为imageView的坐标  而不是像素点
    // 此处拿到缩放比例
    CGFloat widthScale = width / view.frame.size.width;
    CGFloat heightScale = height / view.frame.size.height;

    int x = ceilf(currentPoint.x * widthScale);  // imageView的x 乘以缩放比例   就成了像素点
    int y = ceilf(currentPoint.y * heightScale);
    
    
    // 5.1：修改当前像素点
    int magin = 15;
    for (int i = y - magin; i < y + magin; i ++) {  // 操作像素点附近区域的像素点
        for (int j = x - magin; j < x + magin ; j ++) {
            if (i != j) { // 这里想着  4个拐角不处理  就不会那么方
                UInt32 * currentPixels = inputPixels + (i * width) + j;
                UInt32 color = *currentPixels;
                
                UInt32 colorA,colorR,colorG,colorB;
                
                colorR = R(color);
                colorR = colorR + whiteness;
                colorR = colorR > 255 ? 255 : colorR;
                
                colorG = G(color);
                colorG = colorG + whiteness;
                colorG = colorG > 255 ? 255 : colorG;
                
                colorB = B(color);
                colorB = colorB + whiteness;
                colorB = colorB > 255 ? 255 : colorB;
                
                colorA = A(color);
                *currentPixels = RGBAMake(colorR, colorG, colorB, colorA);
            }
        }
    }
    // 6：创建Image对象
    CGImageRef newImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage * newImage = [UIImage imageWithCGImage:newImageRef];
    
    // 7：释放内存
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRelease(contextRef);
    CGImageRelease(newImageRef);
    free(inputPixels);
    
    return newImage;
}


/////////////////////////////////////灰色头像//////////////////////////////////////////////////////////
+ (UIImage *)imageToGrary:(NSString *)imageName {
    // 1.拿到图片，获取宽高
    CGImageRef imageRef = [UIImage imageNamed:imageName].CGImage;
    NSInteger width = CGImageGetWidth(imageRef);
    NSInteger height = CGImageGetHeight(imageRef);
    
    // 2:创建颜色空间（灰色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    
    CGContextRef contextRef = CGBitmapContextCreate(nil,
                                                    width,
                                                    height,
                                                    8, // 固定写法  8位
                                                    width * 4, // 每一行的字节  宽度 乘以32位 = 4字节
                                                    colorSpaceRef,
                                                    kCGImageAlphaNone); // 无透明度
    if (!contextRef) {
        return [UIImage imageNamed:imageName];
    }
 
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    
    CGImageRef grayImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage * graryImage = [UIImage imageWithCGImage:grayImageRef];
    //释放内存
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRelease(contextRef);
    CGImageRelease(grayImageRef);
    return graryImage;
}


@end
