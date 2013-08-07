//
//  NewsListController.m
//  BaseIOSProject
//
//  Created by xcode on 13-7-8.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "NewsListController.h"
#import "NewsContentController.h"
#import "NewsListCell.h"
#import "Parser.h"
#import "UMSocial.h"
#import "UIView+screenshot.h"

static const CGFloat kDefultRowHeight = 80.0;
static NSUInteger pageIndex = 1;

@interface NewsListController ()<LHSwipeCellDelegate>
@property (nonatomic, strong) NSMutableArray *newsListDataSource, *downlodedNewsList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *loadMoreNewsButton;
@property (strong, nonatomic) IBOutlet UIView *aboutMeView;


@end


@implementation NewsListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.newsListDataSource = [NSMutableArray new];
    
    CGRect frame = self.aboutMeView.bounds;
    frame.origin.y = - frame.size.height;
    self.aboutMeView.frame = frame;
    [self.tableView addSubview:self.aboutMeView];
    
    self.tableView.hidden = YES;
    self.tableView.tableFooterView = self.loadMoreNewsButton;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsListCell" bundle:nil] forCellReuseIdentifier:@"NewsListCell"];
    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing) forControlEvents:UIControlEventValueChanged];
    
    [self getNewsList];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.newsListDataSource removeAllObjects];
    [self dropViewDidBeginRefreshing];
}

- (void)dropViewDidBeginRefreshing
{
    if(self.isLoading)
    {
        [self.refreshControl endRefreshing];
        return;
    }
    
    pageIndex = 1;
    [Parser parseNewsTitleWithPageIndex:pageIndex OnSuccessed:^(NSMutableArray *listOfModelObject) {
        self.isLoading = NO;
        [self.refreshControl endRefreshing];
        [self.newsListDataSource removeAllObjects];
        [self.newsListDataSource addObjectsFromArray:listOfModelObject];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    } onError:^(NSError *error) {
        self.isLoading = NO;
        [self.refreshControl endRefreshing];
        ShowAlert();
    }];

}


- (void)getNewsList
{
    self.isLoading = YES;
    [self showLoadingViewAnimation:NO];
    
    [Parser parseNewsTitleWithPageIndex:pageIndex OnSuccessed:^(NSMutableArray *listOfModelObject) {
        self.isLoading = NO;
        [self hideLoadingViewAnimation:NO];
        [self.newsListDataSource addObjectsFromArray:listOfModelObject];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    } onError:^(NSError *error) {
        self.isLoading = NO;
        [self hideLoadingViewAnimation:NO];
        self.tableView.hidden = NO;
        ShowAlert();
    }];
}

- (IBAction)loadMoreNews:(id)sender
{
    if(self.isLoading){
        return;
    }
    
    ++pageIndex;
    [self getNewsList];
}


#pragma mark - UITableView DataSorce And Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsListDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell"];
    cell.delegate = self;
    
    News *news = self.newsListDataSource[indexPath.row];
    [cell updateCellContent:news];
    cell.tag = indexPath.row;
        
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.newsListDataSource objectAtIndex:indexPath.row];
    CGSize size = [news.title sizeWithFont:[UIFont systemFontOfSize:14] forWidth:MAXFLOAT lineBreakMode:NSLineBreakByWordWrapping];
    return size.height > kDefultRowHeight ? size.height + kDefultRowHeight : kDefultRowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NewsContentController *NCC = [[NewsContentController alloc] initWithNibName:@"NewsContentController" bundle:nil newsObject:self.newsListDataSource[indexPath.row]];
    [self.navigationController pushViewController:NCC animated:YES];
}


#pragma mark - LHSwipeDelegate
- (void)lhSwipeCellOffsetStateChanged:(LHSwipeCell *)cell offsetState:(LHSwipeCellOffsetState)offsetState
{
    News *news = self.newsListDataSource[cell.tag];
    
    if(offsetState == LHSwipeCellOffsetStateOn)
    {
        NSString *text = [NSString stringWithFormat:@"%@ 《贵州人事考试》下载:https://itunes.apple.com/cn/app/gui-zhou-ren-shi-kao-shi/id622339104?mt=8 考试信息:%@",news.title, news.contentURL];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"51451fe556240b6e59008ee2"
                                          shareText:text
                                         shareImage:[self.view screenshot]
                                    shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToRenren,UMShareToSms,UMShareToEmail]
                                           delegate:nil];
    }
}
- (void)viewDidUnload {
    [self setLoadMoreNewsButton:nil];
    [self setAboutMeView:nil];
    [super viewDidUnload];
}
@end
