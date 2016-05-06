//
//  ViPDetailViewController.h
//  GuHouseKeeping
//
//  Created by luyun on 14-7-13.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface ViPDetailViewController : BaseViewController<UIAlertViewDelegate>
@property (nonatomic, assign) int indexRow;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *first_dot;
@property (strong, nonatomic) IBOutlet UIImageView *second_dot;
@property (strong, nonatomic) IBOutlet UIImageView *third_dot;

- (IBAction)buttonClick:(id)sender;
@end
