//
//  WhiteImageUtility.m
//  ps美白术
//
//  Created by 9188 on 2017/4/11.
//  Copyright © 2017年 朱同海. All rights reserved.
//

#import "HImageUtility.h"
#import "ColorUtils.h"
#import "NSString+StringSize.h"

@implementation HImageUtility
/////////////////////////////////////为了每个模块容易理解   代码不封装了//////////////////////////////////////////////////////////
/////////////////////////////////////图片美白//////////////////////////////////////////////////////////
/// 美白
+ (UIImage *)whiteImageWithName:(NSString *)imageName  Whiteness:(int)whiteness {

    return [HImageUtility whiteImage:[UIImage imageNamed:imageName] Whiteness:whiteness];
}

+ (UIImage *)whiteImage:(UIImage *)image
              Whiteness:(int)whiteness {
    
    if (!whiteness || whiteness < 10 ||  whiteness > 150) {
        return image;
    }
    
    // 1.拿到图片，获取宽高
    CGImageRef imageRef =image.CGImage;
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

+ (UIImage *)imageToGraryWithImageName:(NSString *)imageName {
    return [HImageUtility imageToGraryWithImage:[UIImage imageNamed:imageName]];
}


+ (UIImage *)imageToGraryWithImage:(UIImage *)image {
    // 1.拿到图片，获取宽高
    CGImageRef imageRef = image.CGImage;
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
        return image;
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

/////////////////////////////////////图片合成//////////////////////////////////////////////////////////
+ (UIImage *)composeImageWithArray:(NSArray<UIImage *> *)imageArray frameArray:(NSArray *)frameArray {
    if (imageArray.count == 0) {  return nil;  }
    if (imageArray.count == 1) {  return imageArray.firstObject;  }
    if (imageArray.count != frameArray.count) {  return nil;  }
    
    __block UIImage *image0;
    [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.size.width == 0) {
            *stop = YES;
            image0 = idx == 0 ? obj : [imageArray objectAtIndex:idx - 1];
        }
    }];
    if (image0) {
        return image0;
    }
    
    NSMutableArray *arrayImages = imageArray.mutableCopy;
    NSMutableArray *arrayFrames = frameArray.mutableCopy;
    
    NSString *string = arrayFrames.firstObject;
    CGRect fristRect = CGRectFromString(string);
    UIImage *img0 = arrayImages.firstObject;
    CGFloat w0 = fristRect.size.width;
    CGFloat h0 = fristRect.size.height;
    // 以第一张的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w0, h0));
    [img0 drawInRect:CGRectMake(0, 0, w0, h0)];// 先把第一张图片 画到上下文中
    
    
    for (int i = 1; i < arrayImages.count; i ++) {
        NSString *string2 = [arrayFrames objectAtIndex:i];
        CGRect secondRect = CGRectFromString(string2);
        UIImage *img1 = [arrayImages objectAtIndex:1];
        [img1 drawInRect:secondRect];// 再把小图放在上下文中
    }
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();// 从当前上下文中获得最终图片
    UIGraphicsEndImageContext();// 关闭上下文
    return resultImg;
}

+ (UIImage *)composeImageOnMainImage:(UIImage *)mainImage
                  mainImageViewFrame:(CGRect)viewFrame
                       subImageArray:(NSArray *)imgArray
                  subImageFrameArray:(NSArray *)frameArray {
    if (!mainImage) {   return nil; }
    if (viewFrame.size.width == 0 || viewFrame.size.height == 0) {   return nil; }
    if (imgArray.count == 0) {  return nil;  }
    if (imgArray.count == 1) {  return imgArray.firstObject;  }
    if (imgArray.count != frameArray.count) {  return nil;  }
    
    // 此处拿到缩放比例
    CGFloat widthScale = mainImage.size.width / viewFrame.size.width;
    CGFloat heightScale = mainImage.size.height / viewFrame.size.height;

    UIGraphicsBeginImageContext(CGSizeMake(mainImage.size.width, mainImage.size.height));
    [mainImage drawInRect:CGRectMake(0, 0, mainImage.size.width, mainImage.size.height)];
    int i = 0;
    for (UIImage *img in imgArray) {
        NSString *string = [frameArray objectAtIndex:i];
        CGRect fristRect = CGRectFromString(string);
        [img drawInRect:CGRectMake(fristRect.origin.x * widthScale, fristRect.origin.y * heightScale, fristRect.size.width, fristRect.size.height)];
        i+=1;
    }
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
        return resultImg == nil ? mainImage : resultImg;
}



/////////////////////////////////////图片旋转//////////////////////////////////////////////////////////
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}



//////////////////////////////////////图片合成文字//////////////////////////////////////////////


+ (UIImage *)imageWithText:(NSString *)text
                  textFont:(NSInteger)fontSize
                 textColor:(UIColor *)textColor
                 textFrame:(CGRect)textFrame
               originImage:(UIImage *)image
    imageLocationViewFrame:(CGRect)viewFrame {
    
    if (!text)      {  return image;   }
    if (!fontSize)  {  fontSize = 17;   }
    if (!textColor) {  textColor = [UIColor blackColor];   }
    if (!image)     {  return nil;  }
    if (viewFrame.size.height==0 || viewFrame.size.width==0 || textFrame.size.width==0 || textFrame.size.height==0 ){return nil;}

    NSString *mark = text;
    CGFloat height = [mark sizeWithPreferWidth:textFrame.size.width font:[UIFont systemFontOfSize:fontSize]].height; // 此分类方法要导入头文件
    if ((height + textFrame.origin.y) > viewFrame.size.height) { // 文字高度超出父视图的宽度
        height = viewFrame.size.height - textFrame.origin.y;
    }
    
//    CGFloat w = image.size.width;
//    CGFloat h = image.size.height;
    UIGraphicsBeginImageContext(viewFrame.size);
    [image drawInRect:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height)];
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName : textColor };
    //位置显示
    [mark drawInRect:CGRectMake(textFrame.origin.x, textFrame.origin.y, textFrame.size.width, height) withAttributes:attr];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

@end
