//
//  ViewController.m
//  图片处理
//
//  Created by 9188 on 2017/4/14.
//  Copyright © 2017年 朱同海. All rights reserved.
//

#import "ViewController.h"
#import "HImageUtility.h"

#define ScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight  ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@property (nonatomic, strong) UIImageView *photoImageVIew;
@property (nonatomic, assign) BOOL isNeedDermabrasion;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.photoImageVIew];
    self.isNeedDermabrasion = NO;
}

#pragma mark - private

/// 磨皮or马赛克具体实现代码
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isNeedDermabrasion) {
        UITouch *touch = [[event touchesForView:self.photoImageVIew] anyObject];
        if (touch) {
            self.photoImageVIew.image =[HImageUtility dermabrasionImage:self.photoImageVIew.image touch:touch view:self.photoImageVIew];
        }
    }
}

#pragma mark - IBAction

/// 还原
- (IBAction)reductionBtnClick:(id)sender {
    self.photoImageVIew.image =[UIImage imageNamed:@"456"];
}

/// 美白
- (IBAction)whiteSkinClick:(id)sender {
    self.photoImageVIew.image =[HImageUtility whiteImageWithName:@"456" Whiteness:30]; // 使用UIKit
    NSLog(@"美白.....");
}

/// 超级美白
- (IBAction)superWhiteSkinClick:(id)sender {
    self.photoImageVIew.image =[HImageUtility whiteImageWithName:@"456" Whiteness:120];// 使用UIKit
}

/// 是否点击了磨皮
- (IBAction)DermabrasionBtnClick:(id)sender {
    self.isNeedDermabrasion = !self.isNeedDermabrasion;
}

/// 灰色头像
- (IBAction)graryBtnClick:(id)sender {
    self.photoImageVIew.image = [HImageUtility imageToGraryWithImageName:@"456"];// 使用UIKit
}

#pragma mark - lazy
- (UIImageView *)photoImageVIew{
    if (!_photoImageVIew) {
        CGFloat leftMargin = 55;
        _photoImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, 30, ScreenWidth - 2 * leftMargin, 450)];
        _photoImageVIew.userInteractionEnabled = YES;
        _photoImageVIew.image = [UIImage imageNamed:@"456"];
    }
    return _photoImageVIew;
}

@end
