//
//  SearchChoosePopTableViewCell.m
//  GuHouseKeeping
//
//  Created by luyun on 14-7-26.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "SearchChoosePopTableViewCell.h"

@interface SearchChoosePopTableViewCell ()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation SearchChoosePopTableViewCell

- (void)awakeFromNib
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(12, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame) - 24, 0.5)];
        [_lineView setBackgroundColor:GREENCOLO];
    }
    [self addSubview:_lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
