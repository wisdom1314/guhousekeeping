//
//  NewHomeViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface NewHomeViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) BOOL isNewHome;
@property (strong, nonatomic) NSString *auntID;
@property (strong, nonatomic) IBOutlet UILabel *subTitlelabel;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIView *serviceTimeContainView;
@property (strong, nonatomic) IBOutlet UILabel *serviceTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *homeSquareContainView;
@property (strong, nonatomic) IBOutlet UIImageView *homeSquareIcon;
@property (strong, nonatomic) IBOutlet UILabel *homeSquareLabel;
@property (strong, nonatomic) IBOutlet UIView *addressContainView;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;
@property (strong, nonatomic) IBOutlet UIView *remarkContainView;
@property (strong, nonatomic) IBOutlet UITextField *remarkTF;
- (IBAction)buttonClick:(id)sender;

@end
