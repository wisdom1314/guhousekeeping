//
//  SearchAuntCell.m
//  GuHouseKeeping
//
//  Created by David on 8/14/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "SearchAuntCell.h"

@implementation SearchAuntCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SearchAuntCell" owner:self options:nil] objectAtIndex:0];
        _circleView.layer.cornerRadius = CGRectGetHeight(_circleView.frame) /2.0;
        _circleView.layer.masksToBounds = YES;
        _circleView.clipsToBounds = YES;
        
        [self bringSubviewToFront:_delButton];
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

@end
