//
//  AccessoryController.h
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-7-11.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "BaseController.h"

typedef NS_ENUM(NSUInteger, AccessoryType){
    AccessoryTypeNone,
    AccessoryTypeXls,
    AccessoryTypeWord,
    AccessoryTypeWeb,
    AccessoryTypeCompress
};

@interface AccessoryController : BaseController
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
           urlRequest:(NSURLRequest *)request
        accessoryType:(AccessoryType)type;
@end
