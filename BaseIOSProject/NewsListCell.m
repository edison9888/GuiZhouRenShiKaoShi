//
//  NewsListCell.m
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-7-10.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "NewsListCell.h"
#import "UIColor+HexString.h"

@implementation NewsListCell

- (void)updateCellContent:(News *)news
{
    self.titleLabel.text = news.title;
    self.titleLabel.textColor = [UIColor colorWithHexString:news.color];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    
    if([today isEqualToString:news.date])
    {
        self.dateLabel.textColor = [UIColor colorWithRed:20.0/255.0 green:162.0/255.0 blue:212.0/255.0 alpha:1.0];
        self.dateLabel.text = @"今天";
    }
    else
    {
        self.dateLabel.text = news.date;
    }
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.dateLabel setTextColor:[UIColor lightGrayColor]];
}
@end
