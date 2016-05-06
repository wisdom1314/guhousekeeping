//
//  LoginViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidSuccessLogin;

@end

@interface LoginViewController : BaseViewController
@property (strong, nonatomic) id<LoginViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *phoneContainView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIView *verifyContainView;
@property (strong, nonatomic) IBOutlet UITextField *verifyTextField;
@property (strong, nonatomic) IBOutlet UIButton *authCodeSubmitButton;
@property (strong, nonatomic) IBOutlet UILabel *authCodeStatusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *verifyBubbleImageView;
@property (strong, nonatomic) IBOutlet UIButton *protocolButton;
- (IBAction)buttonClick:(id)sender;
@end
