//
//  AuntDetailViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface AuntDetailViewController : BaseViewController
@property (nonatomic, strong) NSString *auntID;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)buttonClick:(id)sender;
@end
