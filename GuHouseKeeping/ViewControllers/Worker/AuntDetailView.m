//
//  AuntDetailView.m
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "AuntDetailView.h"

@interface AuntDetailView()
@property (nonatomic, strong) UIImage *starHover;
@property (nonatomic, strong) UIImage *starNormal;
@end

@implementation AuntDetailView
@synthesize starHover = _starHover;
@synthesize starNormal = _starNormal;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)starLevel:(int)level{
    _starHover = [UIImage imageNamed:@"time_hover.png"];
    _starNormal = [UIImage imageNamed:@"time_normal.png"];
    [_firstStar setImage:(level > 0 ? _starHover : _starNormal)];
    [_secondStar setImage:(level > 1 ? _starHover : _starNormal)];
    [_thirdStar setImage:(level > 2 ? _starHover : _starNormal)];
    [_forthStar setImage:(level > 3 ? _starHover : _starNormal)];
    [_fifthStar setImage:(level > 4 ? _starHover : _starNormal)];
}

@end
