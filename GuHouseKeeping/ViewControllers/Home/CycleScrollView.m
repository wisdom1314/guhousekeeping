//
//  CycleScrollView.m
//  Holter
//
//  Created by David on 4/30/14.
//  Copyright (c) 2014 HLEH. All rights reserved.
//

#import "CycleScrollView.h"

@interface CycleScrollView()
@property (nonatomic, assign) NSUInteger totalPages;
@property (nonatomic, strong) NSMutableArray *currentViews;

@end


@implementation CycleScrollView
@synthesize scrollView = _scrollView;
//@synthesize pageControl = _pageControl;
@synthesize currentPage = _currentPage;
@synthesize delegate = _delegate;
@synthesize datasource = _datasource;
@synthesize totalPages = _totalPages;
@synthesize currentViews = _currentViews;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setDelegate:(id<UIScrollViewDelegate>)self];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3.0, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
//        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
//        _pageControl.userInteractionEnabled = NO;
        
//        [self addSubview:_pageControl];
        _currentPage = 0;
        
    }
    return self;
}


- (void)setDatasource:(id<CycleScrollViewDataSource>)datasource{
    _datasource = datasource;
    [self reloadData];
}


- (void)reloadData{
    _totalPages = [_datasource numberOfPagesWithView:self];
    if (_totalPages == 0) {
        return;
    }
//    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData{
//    _pageControl.currentPage = _currentPage;
    if (_delegate && [_delegate respondsToSelector:@selector(CycleScrollViewCurrent:)]) {
        [_delegate CycleScrollViewCurrent:_currentPage];
    }
    NSArray *subViews = [_scrollView subviews];
    if ([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self getDisplayImagesWithCurpage:_currentPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [_currentViews objectAtIndex:i];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [view addGestureRecognizer:singleTap];
        view.frame = CGRectOffset(view.frame, view.frame.size.width * i, 0);
        [_scrollView addSubview:view];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(int)page {
    int pre = [self validPageValue:_currentPage - 1];
    int last = [self validPageValue:_currentPage + 1];
    if (!_currentViews) {
        _currentViews = [[NSMutableArray alloc] init];
    }
    [_currentViews removeAllObjects];
    
    [_currentViews addObject:[_datasource pageAtIndex:pre WithView:self]];
    [_currentViews addObject:[_datasource pageAtIndex:page WithView:self]];
    [_currentViews addObject:[_datasource pageAtIndex:last WithView:self]];
    
    
}


- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}


- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_currentPage];
    }
}
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index{
    if (index == _currentPage) {
        [_currentViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_currentViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

- (void)autoWithIndex:(int)index{
    _currentPage = index;
    [self loadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([_delegate respondsToSelector:@selector(willBeginDraggingWithView:)]) {
        [_delegate willBeginDraggingWithView:self];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int x = scrollView.contentOffset.x;
    if (x >= (2 * self.frame.size.width)) {
        _currentPage = [self validPageValue:_currentPage + 1];
        [self loadData];
    }
    if (x <= 0) {
        _currentPage = [self validPageValue:_currentPage - 1];
        [self loadData];
        
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([_delegate respondsToSelector:@selector(didEndDeceleratingWithView:)]) {
        [_delegate didEndDeceleratingWithView:self];
    }
      //[_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
