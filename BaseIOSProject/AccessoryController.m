//
//  AccessoryController.m
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-7-11.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "AccessoryController.h"
#import "UIWebView+HideGradientBackground.h"
#import "UMSocial.h"
#import "UIView+screenshot.h"

@interface AccessoryController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *accessoryURLRequest;
@property (assign, nonatomic) AccessoryType type;
@property (strong, nonatomic) ODRefreshControl *refreshControl;

@end

@implementation AccessoryController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
           urlRequest:(NSURLRequest *)request
        accessoryType:(AccessoryType)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.accessoryURLRequest = request;
        self.navigationController.navigationBarHidden = YES;
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.webView.scrollView];
    [self.refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing) forControlEvents:UIControlEventValueChanged];
    
    switch(self.type)
    {
        case AccessoryTypeXls:
            self.titleLabel.text = @"电子表格";
            break;
            
        case AccessoryTypeWord:
            self.titleLabel.text = @"Word文档";
            break;
            
        default:
            self.titleLabel.text = @"网页";
            break;
    }
    
    [self.webView hideGradientBackground:self.webView];
    [self.webView loadRequest:self.accessoryURLRequest];
}


- (void)dropViewDidBeginRefreshing
{
    if(self.isLoading)
    {
        [self.refreshControl endRefreshing];
        return;
    }
    
    [self.refreshControl beginRefreshing];
    [self.webView loadRequest:self.accessoryURLRequest];
}


- (IBAction)backToParentView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.isLoading = YES;
    [self showLoadingViewAnimation:NO];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.isLoading = NO;
    [self hideLoadingViewAnimation:NO];
    [self.refreshControl endRefreshing];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.isLoading = NO;
    [self hideLoadingViewAnimation:NO];
    [self.refreshControl endRefreshing];
    
    ShowAlert();
}

#pragma mark - Action
- (IBAction)shareAccessory:(id)sender
{
    if(self.type == AccessoryTypeXls || self.type == AccessoryTypeWord)
    {
        NSString *text = [NSString stringWithFormat:@"来自《贵州人事考试(https://itunes.apple.com/cn/app/gui-zhou-ren-shi-kao-shi/id622339104?mt=8)》，附件下载地址:%@",[self.accessoryURLRequest.URL  absoluteString]];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"51451fe556240b6e59008ee2"
                                          shareText:text
                                         shareImage:[self.view screenshot]
                                    shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToRenren,UMShareToSms,UMShareToEmail]
                                           delegate:nil];
    }
    else
    {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"只能分享电子表格和Word文档"];
        [alertView addButtonWithTitle:@"关闭" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
            [alertView dismissAnimated:YES];
        }];
        [alertView show];
        return;
    }
    
 
}

@end
