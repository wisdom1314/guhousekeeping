//
//  MineOrderListViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface MineOrderListViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *noPayLabel;
@property (strong, nonatomic) IBOutlet UIButton *noPayButton;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;

- (IBAction)buttonClick:(id)sender;
- (IBAction)payButton:(id)sender;
- (IBAction)cancelClick:(id)sender;

@end
