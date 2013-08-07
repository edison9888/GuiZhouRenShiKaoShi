//
//  UIWebView+HideGradientBackground.m
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-7-11.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "UIWebView+HideGradientBackground.h"

@implementation UIWebView (HideGradientBackground)
- (void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
        {
            subview.hidden = YES;
        }
        
        [self hideGradientBackground:subview];
    }
}
@end
