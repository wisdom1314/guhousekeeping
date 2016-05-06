//
//  ViPViewController.h
//  GuHouseKeeping
//
//  Created by luyun on 14-7-13.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface ViPViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)backBtn:(id)sender;
@end
