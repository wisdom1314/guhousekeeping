//
//  MoreViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)buttonClick:(id)sender;
@end
