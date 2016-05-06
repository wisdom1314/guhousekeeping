//
//  OrderListTableViewCell.h
//  GuHouseKeeping
//
//  Created by David on 7/13/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconIV;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@end
