//
//  Parser.m
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-3-15.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import "Parser.h"

@implementation Parser

+ (void)parseNewsTitleWithPageIndex:(NSUInteger)index
                        OnSuccessed:(ArrayBlock)successedBlock
                            onError:(ErrorBlock)errorBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^
    {
        NSMutableArray *newsContainer = [NSMutableArray new];

        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSURL *url = nil;
        if(index == 1){
            url = [NSURL URLWithString:@"http://www.163gz.com/gzzp8/zkxx/"];
        }else{
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.163gz.com/gzzp8/zkxx/zkxx_%d.shtml",index]];
        }
        NSError *error = nil;
        NSString *webPageStr = [NSString stringWithContentsOfURL:url encoding:enc error:&error];
        
        if(error || webPageStr == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        //1.抓取一条新闻
        NSString *patternNews = @"<a.*http://www.163gz.com/gzzp8/zkxx/.+shtml.*</a>";
        NSRegularExpression *reExNews = [NSRegularExpression regularExpressionWithPattern:patternNews
                                                                            options:NSRegularExpressionAllowCommentsAndWhitespace
                                                                              error:nil];
        NSArray *newsArray = [reExNews matchesInString:webPageStr options:NSMatchingReportProgress range:NSMakeRange(0, webPageStr.length-1)];
        for (NSTextCheckingResult *newsMatch in newsArray)
        {
            News *news = [[News alloc] init];
            
            NSRange range = [newsMatch range];
            NSString *newsStr = [webPageStr substringWithRange:range];
            
            //1.抓取新闻内容地址
            NSString * patternURL = @"http.+shtml";
            NSRegularExpression *reExURL = [NSRegularExpression regularExpressionWithPattern:patternURL
                                                                                     options:NSRegularExpressionAllowCommentsAndWhitespace
                                                                                       error:nil];
            NSArray *urlArray = [reExURL matchesInString:newsStr options:NSMatchingReportProgress range:NSMakeRange(0, newsStr.length-1)];
            NSTextCheckingResult *urlCR = urlArray[0];
            NSRange urlRange = [urlCR range];
            NSString *urlStr = [newsStr substringWithRange:urlRange];
            news.contentURL = urlStr;
          
            //2.抓取日期
            NSString * patternDate = @"[0-9]{2}-[0-9]{2}";
            NSRegularExpression *reExDate = [NSRegularExpression regularExpressionWithPattern:patternDate
                                                                                      options:NSRegularExpressionAllowCommentsAndWhitespace
                                                                                        error:nil];
            NSArray *dataArray = [reExDate matchesInString:newsStr options:NSMatchingReportProgress range:NSMakeRange(0, newsStr.length-1)];
            NSTextCheckingResult *dateCR = dataArray[0];
            NSRange dateRange = [dateCR range];
            NSString *dateStr = [newsStr substringWithRange:dateRange];
            news.date = [Parser makeDate:dateStr];
            
            //3.抓取新闻标题文字的颜色 
            NSString * patternColor = @"color.*=.*[0-9a-fA-f]{6}";
            NSRegularExpression *reExColor = [NSRegularExpression regularExpressionWithPattern:patternColor
                                                                                       options:NSRegularExpressionAllowCommentsAndWhitespace
                                                                                         error:nil];
            NSInteger macthCount = [reExColor numberOfMatchesInString:newsStr options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, newsStr.length-1)];
            NSArray *colorArray = [reExColor matchesInString:newsStr options:NSMatchingReportProgress range:NSMakeRange(0, newsStr.length-1)];
            if(macthCount != 0)  // 有些标题没有指定的颜色,所以匹配数可能为0
            {
                NSTextCheckingResult *colorCR = colorArray[0];
                NSRange colorRange = [colorCR range];
                NSString *colorStr = [newsStr substringWithRange:colorRange];
                news.color = [colorStr substringFromIndex:8];
            }else{
                news.color = @"000000";
            }
            
            //4.抓取标题 (忽略此处编译器的警告,\用来转义正则表达式元字符.)
            NSString *patternNewTitle = (macthCount == 0 ? @"[0-9]{2}-[0-9]{2}.*\..*<" : @"color=.*>.*</font>");
            NSRegularExpression *reExTitle = [NSRegularExpression regularExpressionWithPattern:patternNewTitle
                                                                                       options:NSRegularExpressionAllowCommentsAndWhitespace
                                                                                         error:nil];
            NSArray *titleArray = [reExTitle matchesInString:newsStr options:NSMatchingReportProgress range:NSMakeRange(0, newsStr.length-1)];
            NSTextCheckingResult *titleCR = titleArray[0];
            NSRange titleRange = [titleCR range];
            NSString *titleStr = [newsStr substringWithRange:titleRange];
            news.title = [Parser subString:titleStr color:(macthCount != 0 ? YES : NO)];
          
            [newsContainer addObject:news];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            successedBlock(newsContainer);
        });
    });
}


+ (void)parseNewsContentWithTargetURL:(NSString *)urlStr
                          OnSuccessed:(NewsContentBlock)successedBlock
                              onError:(ErrorBlock)errorBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^
    {
        NSString *newsContent = nil;
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSURL *url = [NSURL URLWithString:urlStr];
        NSError *error = nil;
        NSString *webPageStr = [NSString stringWithContentsOfURL:url encoding:enc error:&error];
        
        if(error || !webPageStr)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        NSString *newsContentPattern = @"<!--Content Start-->.*<!--Content End-->";
        NSRegularExpression *reExNewsContent = [NSRegularExpression regularExpressionWithPattern:newsContentPattern
                                                                                   options:NSRegularExpressionDotMatchesLineSeparators
                                                                                     error:nil];
        NSArray *titleArray = [reExNewsContent matchesInString:webPageStr options:NSMatchingReportProgress range:NSMakeRange(0, webPageStr.length-1)];
        
        if(titleArray.count > 0)
        {
            NSTextCheckingResult *newsContentCR = titleArray[0];
            NSRange newsContentRange = [newsContentCR range];
            NSString *newsContentFullStr = [webPageStr substringWithRange:newsContentRange];
            newsContent = [newsContentFullStr substringWithRange:NSMakeRange(20, newsContentFullStr.length-(20+18))];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            successedBlock(newsContent);
        });
    });
}


+ (NSString *)makeDate:(NSString *)shortDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@-%@", date,shortDate];
}


+ (NSString *)subString:(NSString *)str color:(BOOL)aBool
{
    NSRange range;
    if(aBool)
        range = NSMakeRange(16, str.length - (16+7));
    else
        range = NSMakeRange(7, str.length - 8);
    
    return [str substringWithRange:range];
}

@end
