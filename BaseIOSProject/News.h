//
//  News.h
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-3-15.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property(nonatomic, copy) NSString *title,        // 新闻标题
                                    *date,         // 发布日期
                                    *contentURL,   // 新闻内容地址
                                    *content,      // 新闻内容
                                    *color;        // FF00FF

@property(nonatomic, assign) BOOL hasReaded,       // 是否已经已阅读
                                  hasContent,      // 是否已下载了新闻内容
                                  hasAccessory;    // 是否有附件


@end
