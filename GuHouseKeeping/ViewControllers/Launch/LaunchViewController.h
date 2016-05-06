//
//  LaunchViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface LaunchViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (strong, nonatomic) IBOutlet UIButton *firstButton;
@property (strong, nonatomic) IBOutlet UIButton *secondButton;
@property (strong, nonatomic) IBOutlet UIButton *thirdButton;
- (IBAction)buttonClick:(id)sender;
@end
