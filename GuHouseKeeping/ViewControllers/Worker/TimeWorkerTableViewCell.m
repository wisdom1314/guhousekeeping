//
//  TimeWorkerTableViewCell.m
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "TimeWorkerTableViewCell.h"

@interface TimeWorkerTableViewCell()
@property (nonatomic, strong) UIImage *starHover;
@property (nonatomic, strong) UIImage *starNormal;
@end

@implementation TimeWorkerTableViewCell
@synthesize starHover = _starHover;
@synthesize starNormal = _starNormal;


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
    // Initialization code
    _avataImageView.layer.borderWidth = 1.0f;
    _avataImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _avataImageView.layer.cornerRadius = CGRectGetHeight(_avataImageView.frame) / 2.0;
    _avataImageView.layer.masksToBounds = YES;
    _starHover = [UIImage imageNamed:@"time_hover.png"];
    _starNormal = [UIImage imageNamed:@"time_normal.png"];
}

- (void)starLevel:(int)level{
    [_firstStar setImage:(level > 0 ? _starHover : _starNormal)];
    [_secondStar setImage:(level > 1 ? _starHover : _starNormal)];
    [_thirdStar setImage:(level > 2 ? _starHover : _starNormal)];
    [_forthStar setImage:(level > 3 ? _starHover : _starNormal)];
    [_fifthStar setImage:(level > 4 ? _starHover : _starNormal)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
