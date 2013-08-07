//
//  UIView+screenshot.m
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-7-10.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "UIView+screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (screenshot)

- (UIImage *)screenshot
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, NO, [UIScreen mainScreen].scale);
    }
    else
    {
        UIGraphicsBeginImageContext([UIApplication sharedApplication].keyWindow.bounds.size);
    }
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
