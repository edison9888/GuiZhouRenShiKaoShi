//
//  LHSwipeCell.m
//  BaseIOSProject
//
//  Created by xcode on 13-7-8.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "LHSwipeCell.h"
#import <QuartzCore/QuartzCore.h>

@interface LHSwipeCell()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *rightTextLabel;
@property (nonatomic, assign) LHSwipeCellOffsetState  offsetState;
@end

@implementation LHSwipeCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initializer];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initializer];
    }
    
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initializer];
    }
    return self;
}


- (void)initializer
{
    self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    self.rightTextLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.rightTextLabel.textAlignment = NSTextAlignmentRight;
    self.rightTextLabel.textColor = [UIColor whiteColor];
    self.rightTextLabel.backgroundColor = [UIColor colorWithRed:0.0 green:177.0/255.0 blue:106.0/255.0 alpha:1.0];;
    self.rightTextLabel.text = @"继续滑动 ";
    [self.rightTextLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight];

    [self insertSubview:self.rightTextLabel atIndex:0];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    [self bringSubviewToFront:self.contentView];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    gesture.delegate = self;
    [self.contentView addGestureRecognizer:gesture];
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)swipeGestureRecognizer
{
    UIGestureRecognizerState state = [swipeGestureRecognizer state];
    CGPoint translation = [swipeGestureRecognizer translationInView:self];
    
    if(state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint center = {self.contentView.center.x + translation.x, self.contentView.center.y};
        [self.contentView setCenter:center];
        [swipeGestureRecognizer setTranslation:CGPointZero inView:self];
        
        CGFloat triggerDistanceLimit = 80;
        CGFloat xAxisOffsetDistance = CGRectGetMinX(self.contentView.frame);
        
        if(xAxisOffsetDistance < -triggerDistanceLimit)
        {
            self.rightTextLabel.text = @"释放分享 ";
            self.offsetState = LHSwipeCellOffsetStateOn;
        }
        else
        {
            self.rightTextLabel.text = @"继续滑动 ";
            self.offsetState = LHSwipeCellOffsetStateOff;
        }
    }
    else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled)
    {
      [UIView animateWithDuration:0.5 animations:^{
          self.contentView.frame = self.contentView.bounds;

      } completion:^(BOOL finished) {
          self.rightTextLabel.text = @"继续滑动 ";
      }];
        
      if(self.delegate)
      {
          if([self.delegate respondsToSelector:@selector(lhSwipeCellOffsetStateChanged:offsetState:)])
          {
              [self.delegate lhSwipeCellOffsetStateChanged:self offsetState:self.offsetState];
          }
      }
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer class] == [UIPanGestureRecognizer class])
    {
        UIPanGestureRecognizer *g = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [g velocityInView:self];
        CGPoint translation = [g translationInView:self];
        if (fabsf(point.x) > fabsf(point.y) && translation.x < 0)
        {
            return YES;
        }
    }
    
    return NO;
}

@end
