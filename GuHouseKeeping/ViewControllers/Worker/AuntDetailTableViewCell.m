//
//  AuntDetailTableViewCell.m
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "AuntDetailTableViewCell.h"

@interface AuntDetailTableViewCell ()
@end

@implementation AuntDetailTableViewCell

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
        _lineView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 285) /2.0, CGRectGetHeight(self.frame) - 0.5, 285, 0.5)];
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
