//
//  BaseController.h
//  BaseIOSProject
//
//  Created by xcode on 13-7-1.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIAlertView.h"
#import "ODRefreshControl.h"

#define ShowAlert() \
SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"获取数据失败,执行下拉操作重新获取"];\
[alertView addButtonWithTitle:@"关闭" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {\
[alertView dismissAnimated:YES];\
}];\
[alertView show]

@interface BaseController : UIViewController
@property (assign, nonatomic) BOOL isLoading;
@property (strong, nonatomic) ODRefreshControl *refreshControl;

#pragma mark - ErrorView
/* 提供显示错误信息的视图，默认返回nil。
 * 子类可以重写这个方法来提供自定义视图或者修改默认返回值来提供统一的错误信息视图。
 */
- (UIView *)errorView;
- (void)showErrorViewAnimation:(BOOL)animation;
- (void)hideErrorViewAnimation:(BOOL)animation;

#pragma mark - LoadingView
- (UIView *)loadingView;
- (void)showLoadingViewAnimation:(BOOL)animation;
- (void)hideLoadingViewAnimation:(BOOL)animation;

@end
