//
//  AppDelegate.m
//  BaseIOSProject
//
//  Created by xcode on 13-7-1.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "AppDelegate.h"
#import "NewsListController.h"
#import "UMSocial.h"
#import "MobClick.h"
#import "Crackify.h"
#import "SIAlertView.h"

#define kUMAppKey @"51451fe556240b6e59008ee2"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if([Crackify isCracked]){
        [SIAlertView showWithMessage:@"你使用的是破解版，请到AppStore下载正版，程序将在5秒后关闭!" text1:@"知道了" okBlock:^{}];
        [self performSelector:@selector(exitApp) withObject:nil afterDelay:5];
    }
    
    [MobClick startWithAppkey:kUMAppKey];
    [MobClick checkUpdate];
    [UMSocialData setAppKey:kUMAppKey];
    
    [application setStatusBarHidden:YES];
    
    NewsListController *NLC = [[NewsListController alloc] initWithNibName:@"NewsListController" bundle:nil];
    UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:NLC];
    NC.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = NC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)exitApp
{
    exit(EXIT_FAILURE);
}



@end
