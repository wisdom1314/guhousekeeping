//
//  CycleScrollView.h
//  Holter
//
//  Created by David on 4/30/14.
//  Copyright (c) 2014 HLEH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CycleScrollView;

@protocol CycleScrollViewDelegate <NSObject>
@optional
- (void)CycleScrollViewCurrent:(int)current;
- (void)willBeginDraggingWithView:(CycleScrollView *)cycleScrollView;
- (void)didEndDeceleratingWithView:(CycleScrollView *)cycleScrollView;
- (void)didClickPage:(CycleScrollView *)cycleScrollView atIndex:(NSInteger)index;
@end

@protocol CycleScrollViewDataSource <NSObject>
- (NSInteger)numberOfPagesWithView:(CycleScrollView *)cycleScrollView;
- (UIView *)pageAtIndex:(NSInteger)index WithView:(CycleScrollView *)cycleScrollView;
@end

@interface CycleScrollView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) id<CycleScrollViewDelegate>delegate;
@property (nonatomic, assign) id<CycleScrollViewDataSource>datasource;

- (void)reloadData;
- (void)autoWithIndex:(int)index;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
@end
