//
//  NewsContentController.m
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-7-10.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "NewsContentController.h"
#import "Parser.h"
#import "UIWebView+HideGradientBackground.h"
#import "AccessoryController.h"

#define PushAC(type) \
AC = [[AccessoryController alloc] initWithNibName:@"AccessoryController" bundle:nil urlRequest:request accessoryType:type];\
[self.navigationController pushViewController:AC animated:YES]

@interface NewsContentController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) News *news;
@property (strong, nonatomic) ODRefreshControl *refreshControl;
@end

@implementation NewsContentController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil newsObject:(News *)aNews
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.news= aNews;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView  hideGradientBackground:self.webView];
    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.webView.scrollView];
    [self.refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing) forControlEvents:UIControlEventValueChanged];
    
    if(self.news.hasContent)
    {
        [self.webView loadHTMLString:self.news.content baseURL:nil];
    }
    else
    {
        self.isLoading = YES;
        [self showLoadingViewAnimation:NO];
        [Parser parseNewsContentWithTargetURL:self.news.contentURL OnSuccessed:^(NSString *newsContent)
         {
             self.isLoading = NO;
             [self hideLoadingViewAnimation:NO];
             self.news.content = newsContent;
             self.news.hasContent = YES;
             [self.webView loadHTMLString:self.news.content baseURL:nil];
             
         } onError:^(NSError *error) {
             self.isLoading = NO;
             [self hideLoadingViewAnimation:NO];
             ShowAlert();
         }];
    }
}


- (void)dropViewDidBeginRefreshing
{
    if(self.isLoading)
    {
        [self.refreshControl endRefreshing];
        return;
    }

    self.isLoading = YES;
    [Parser parseNewsContentWithTargetURL:self.news.contentURL OnSuccessed:^(NSString *newsContent)
     {
         self.isLoading = NO;
         [self.refreshControl endRefreshing];
         self.news.content = newsContent;
         self.news.hasContent = YES;
         [self.webView loadHTMLString:self.news.content baseURL:nil];
         
     } onError:^(NSError *error) {
         self.isLoading = NO;
         [self.refreshControl endRefreshing];
         ShowAlert();
     }];
}


- (IBAction)backToParentView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Webview Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
    AccessoryController *AC = nil;
    NSString *extensionName = [request.URL pathExtension];
    extensionName = [extensionName lowercaseString];
    
    if([extensionName isEqualToString:@"xls"] || [extensionName isEqualToString:@"xlsx"])
    {
        PushAC(AccessoryTypeXls);
        return  NO;
    }
    else if([extensionName isEqualToString:@"doc"] || [extensionName isEqualToString:@"docx"])
    {
        PushAC(AccessoryTypeWord);
        return NO;
    }
    else if([extensionName isEqualToString:@"php"]   ||
            [extensionName isEqualToString:@"jsp"]   ||
            [extensionName isEqualToString:@"asp"]   ||
            [extensionName isEqualToString:@"aspx"]  ||
            [extensionName isEqualToString:@"com"]   ||
            [extensionName isEqualToString:@"cn"]    ||
            [extensionName isEqualToString:@"org"])
    {
        PushAC(AccessoryTypeWeb);
        return NO;
    }
    else if([extensionName isEqualToString:@"rar"] || [extensionName isEqualToString:@"zip"])
    {
        NSString *message = [NSString stringWithFormat:@"不能打开压缩文档[%@]", [request.URL absoluteString]];
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:message];
        [alertView addButtonWithTitle:@"关闭" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
            [alertView dismissAnimated:YES];
        }];
        [alertView show];
        
        return NO;
    }
    
    return YES;
}

@end
