//
//  ProtocolViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/6/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()

@end

@implementation ProtocolViewController

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
    
    UIImageView *protocolLicense = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 571/2.0, 1585/2.0)];
    [protocolLicense setImage:[UIImage imageNamed:@"protocolLicense.png"]];
    [protocolLicense setBackgroundColor:[UIColor clearColor]];
    [_myScrollView addSubview:protocolLicense];
    [_myScrollView setBackgroundColor:[UIColor whiteColor]];
    [_myScrollView setContentSize:CGSizeMake(CGRectGetWidth(_myScrollView.frame), 1585/2.0)];
    
    _myScrollView.layer.borderWidth = 1.0f;
    _myScrollView.layer.cornerRadius = 3.0f;
    _myScrollView.layer.borderColor = [DARKGRAY CGColor];
    _myScrollView.layer.masksToBounds = YES;
    
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
