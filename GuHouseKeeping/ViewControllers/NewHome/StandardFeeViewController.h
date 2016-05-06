//
//  StandardFeeViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/30/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface StandardFeeViewController : BaseViewController
@property (assign, nonatomic) BOOL isNewHome;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *subTitlelabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)buttonClick:(id)sender;
@end
