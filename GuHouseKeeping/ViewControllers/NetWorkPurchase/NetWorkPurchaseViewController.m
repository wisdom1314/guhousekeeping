//
//  NetWorkPurchaseViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/21/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "NetWorkPurchaseViewController.h"

@interface NetWorkPurchaseViewController ()

@end

@implementation NetWorkPurchaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
