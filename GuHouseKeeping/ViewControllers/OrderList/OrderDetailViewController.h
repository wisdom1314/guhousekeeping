//
//  OrderDetailViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@protocol OrderDetailViewControllerDelegate <NSObject>

- (void)OrderDetailViewControllerUpdateRefresh;

@end

@interface OrderDetailViewController : BaseViewController
@property (assign, nonatomic) id<OrderDetailViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSString *orderId;
- (IBAction)buttonClick:(id)sender;
@end
