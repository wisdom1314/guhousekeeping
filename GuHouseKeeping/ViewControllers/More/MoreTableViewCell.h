//
//  MoreTableViewCell.h
//  GuHouseKeeping
//
//  Created by David on 7/13/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *leftIconIV;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrow;
@end
