//
//  TimeWorkerViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface TimeWorkerViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIView *subTitleView;
@property (strong, nonatomic) IBOutlet UILabel *standardLabel;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableDictionary *auntInfoDic;
- (IBAction)buttonClick:(id)sender;
@end
