//
//  LHSwipeCell.h
//  BaseIOSProject
//
//  Created by xcode on 13-7-8.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LHSwipeCellOffsetState)
{
    LHSwipeCellOffsetStateOn,
    LHSwipeCellOffsetStateOff
};

@protocol LHSwipeCellDelegate;
@interface LHSwipeCell : UITableViewCell
@property (nonatomic, weak) IBOutlet id<LHSwipeCellDelegate> delegate;

@end


@protocol LHSwipeCellDelegate <NSObject>
@optional
- (void)lhSwipeCellOffsetStateChanged:(LHSwipeCell *)cell offsetState:(LHSwipeCellOffsetState)offsetState;
@end
