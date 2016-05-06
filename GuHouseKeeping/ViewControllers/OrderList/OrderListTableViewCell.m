//
//  OrderListTableViewCell.m
//  GuHouseKeeping
//
//  Created by David on 7/13/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "OrderListTableViewCell.h"

@interface OrderListTableViewCell()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation OrderListTableViewCell
@synthesize lineView = _lineView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(39/2.0, CGRectGetHeight(self.frame) - 0.5, 570 /2.0, 0.5)];
        [_lineView setBackgroundColor:LIGHTGRAY];
    }
    
    [self addSubview:_lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
