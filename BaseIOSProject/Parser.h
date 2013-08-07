//
//  Parser.h
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-3-15.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

typedef void(^ArrayBlock)(NSMutableArray *listOfModelObject);
typedef void(^ErrorBlock)(NSError *error);
typedef void(^NewsContentBlock)(NSString *newsContent);

@interface Parser : NSObject

// 解析新闻标题
+ (void)parseNewsTitleWithPageIndex:(NSUInteger)index
                        OnSuccessed:(ArrayBlock)successedBlock
                          onError:(ErrorBlock)errorBlock;


// 解析新闻内容
+ (void)parseNewsContentWithTargetURL:(NSString *)urlStr
                          OnSuccessed:(NewsContentBlock)successedBlock
                              onError:(ErrorBlock)errorBlock;

@end
