//
//  BaseController.m
//  BaseIOSProject
//
//  Created by xcode on 13-7-1.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "BaseController.h"

@interface BaseController()
@property (nonatomic, strong) UIView *errorView,*loadingView;

- (void)showView:(UIView *)view animation:(BOOL)animation;
- (void)hideView:(UIView *)view animation:(BOOL)animation;

@end

@implementation BaseController

#pragma mark - ErrorView
- (UIView *)errorView
{
    return nil;
}


- (void)showErrorViewAnimation:(BOOL)animation
{
    [self showView:[self errorView] animation:animation];
}


- (void)hideErrorViewAnimation:(BOOL)animation
{
    [self hideView:[self errorView] animation:animation];
}


#pragma mark - LoadingView
- (UIView *)loadingView
{
    if(_loadingView)
    {
        return _loadingView;
    }
    
    NSMutableArray *animationImages = [NSMutableArray new];
    for(NSUInteger i = 0; i <= 24; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"loading%d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [animationImages addObject:image];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    imageView.center = self.view.center;
    imageView.animationImages = animationImages;
    imageView.animationDuration = 1.5;
    [imageView startAnimating];
    
    _loadingView = imageView;
    return _loadingView;
}


- (void)showLoadingViewAnimation:(BOOL)animation
{
    [self showView:[self loadingView] animation:animation];
}


- (void)hideLoadingViewAnimation:(BOOL)animation
{
    [self hideView:[self loadingView] animation:animation];
}


#pragma mark - Private Method
- (void)showView:(UIView *)view animation:(BOOL)animation
{
    if(view == nil)
    {
        return;
    }
    
    view.alpha = 0.0;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    NSTimeInterval duration = animation ? 0.5 : 0.0;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1.0;
    }];
}


- (void)hideView:(UIView *)view animation:(BOOL)animation
{
    if(view == nil)
    {
        return;
    }
    
    NSTimeInterval duration = animation ? 0.5 : 0.0;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}


@end
