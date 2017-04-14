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
 *  磨皮美白图片
 *  @param image        图片
 *  @param touch        touch view上的点击点
 *  @param view         view 点击所在的View
 */
+ (UIImage *)dermabrasionImage:(UIImage *)image
                         touch:(UITouch *)touch
                          view:(UIView *)view;


/**
 *  return 灰色图片
 *  @param imageName        图片名称
 */
+ (UIImage *)imageToGrary:(NSString *)imageName;

@end
