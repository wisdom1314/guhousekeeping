//
//  TimeWorkerDifferTableViewCell.m
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "TimeWorkerDifferTableViewCell.h"

@implementation TimeWorkerDifferTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [_differImageView setCenter:CGPointMake(_differImageView.center.x + 1.5, _differImageView.center.y)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
