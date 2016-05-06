//
//  MoreTableViewCell.m
//  GuHouseKeeping
//
//  Created by David on 7/13/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

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
    _containView.layer.borderWidth = 1.0f;
    _containView.layer.cornerRadius = 3.0f;
    _containView.layer.borderColor = [LIGHTGRAY CGColor];
    _containView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
