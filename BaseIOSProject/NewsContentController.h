//
//  NewsContentController.h
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-7-10.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "BaseController.h"
#import "News.h"

@interface NewsContentController : BaseController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil newsObject:(News *)aNews;
@end
