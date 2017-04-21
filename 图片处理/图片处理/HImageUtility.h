//
//  WhiteImageUtility.h
//  ps美白术
//
//  Created by 9188 on 2017/4/11.
//  Copyright © 2017年 朱同海. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface HImageUtility : NSObject

//////////////////////////////////////UIKit下的CGImage处理//////////////////////////////////////////////
/**
 *  美白图片
 *  @param imageName        图片名称
 *  @param whiteness        美白系数  10-150之间  越大越白
 */
+ (UIImage *)whiteImageWithName:(NSString *)imageName
                      Whiteness:(int)whiteness;

/**
 *  美白图片
 *  @param image            图片
 *  @param whiteness        美白系数  10-150之间  越大越白
 */
+ (UIImage *)whiteImage:(UIImage *)image
                      Whiteness:(int)whiteness;

/**
 *  磨皮美白图片
 *  @param image        图片
 *  @param touch        touch view上的点击点
 *  @param view         view 点击所在的View
 */
+ (UIImage *)dermabrasionImage:(UIImage *)image
                         touch:(UITouch *)touch
                          view:(UIView *)view;




//////////////////////////////////////灰色处理//////////////////////////////////////////////
/**
 *  return 灰色图片
 *  @param imageName        图片名称
 */
+ (UIImage *)imageToGraryWithImageName:(NSString *)imageName;
+ (UIImage *)imageToGraryWithImage:(UIImage *)image;



//////////////////////////////////////图片合成处理//////////////////////////////////////////////
/**
 *  return 合成后的图片 (以坐标为参考点，不准确)
 *  @param imageArray        图片数组  第一张图片位画布，所以最大
 *  @param frameArray        坐标数组  
 */
+ (UIImage *)composeImageWithArray:(NSArray<UIImage *> *)imageArray
                        frameArray:(NSArray *)frameArray;

/**
 *  return 合成后的图片 (以坐标为参考点，准确)
 *  @param mainImage        第一张图片位画布                          （必传，不可空）
 *  @param viewFrame        第一张图片所在View的frame（获取压缩比用）    （必传，不可空）
 *  @param imgArray         子图片数组                               （必传，不可空）
 *  @param frameArray       子图片坐标数组                            （必传，不可空）
 */
+ (UIImage *)composeImageOnMainImage:(UIImage *)mainImage
                  mainImageViewFrame:(CGRect)viewFrame
                      subImageArray:(NSArray *)imgArray
                 subImageFrameArray:(NSArray *)frameArray;



//////////////////////////////////////imageView旋转后的图片处理//////////////////////////////////////////////
/**
 *  return 旋转后的图片
 *  @param image              原始图片    （必传，不可空）
 *  @param orientation        旋转方向    （必传，不可空）
 */
+ (UIImage *)image:(UIImage *)image
          rotation:(UIImageOrientation)orientation ;



//////////////////////////////////////图片合成文字//////////////////////////////////////////////

/**
 图片合成文字
 @param text            文字
 @param fontSize        字体大小
 @param textColor       字体颜色
 @param textFrame       字体位置
 @param image           原始图片
 @param viewFrame       图片所在View的位置
 @return UIImage *
 */
+ (UIImage *)imageWithText:(NSString *)text
                  textFont:(NSInteger)fontSize
                 textColor:(UIColor *)textColor
                 textFrame:(CGRect)textFrame
               originImage:(UIImage *)image
    imageLocationViewFrame:(CGRect)viewFrame;


@end
