//
//  NewsListCell.h
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-7-10.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "LHSwipeCell.h"
#import "News.h"

@interface NewsListCell : LHSwipeCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)updateCellContent:(News *)news;

@end
