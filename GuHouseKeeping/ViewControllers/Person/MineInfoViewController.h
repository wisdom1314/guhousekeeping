//
//  MineInfoViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface MineInfoViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
//@property (strong, nonatomic) IBOutlet UIView *topView;
//@property (strong, nonatomic) IBOutlet UILabel *topLabel;
//@property (strong, nonatomic) IBOutlet UIImageView *topArrow;
@property (strong, nonatomic) IBOutlet UIImageView *iconIV;
@property (strong, nonatomic) IBOutlet UIView *telContainView;
@property (strong, nonatomic) IBOutlet UITextField *telTF;
@property (strong, nonatomic) IBOutlet UIView *nickContainView;
@property (strong, nonatomic) IBOutlet UITextField *nickTF;
@property (strong, nonatomic) IBOutlet UIView *nameContainView;
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UIView *addressContainView;
@property (strong, nonatomic) IBOutlet UITextView *addressTV;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;
@property (strong, nonatomic) IBOutlet UIButton *editButton;

- (IBAction)buttonClick:(id)sender;
@end
