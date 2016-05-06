//
//  LoginViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "LoginViewController.h"
#import "ProtocolViewController.h"
#import "ObtainVerifyCodeModel.h"

@interface LoginViewController ()
@property (nonatomic, strong) NSTimer *animateTimer;
@property (nonatomic, assign) int secLeft;
@property (nonatomic, strong) ObtainVerifyCodeModel *codeModel;
@end

@implementation LoginViewController
@synthesize delegate = _delegate;
@synthesize animateTimer = _animateTimer;
@synthesize secLeft = _secLeft;
@synthesize codeModel = _codeModel;

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
   
    _phoneContainView.layer.borderWidth = 1.0f;
    _phoneContainView.layer.cornerRadius = 3.0f;
    _phoneContainView.layer.borderColor = [DARKGRAY CGColor];
    _phoneContainView.layer.masksToBounds = YES;
    
    _verifyContainView.layer.borderWidth = 1.0f;
    _verifyContainView.layer.cornerRadius = 3.0f;
    _verifyContainView.layer.borderColor = [DARKGRAY CGColor];
    _verifyContainView.layer.masksToBounds = YES;
    
    [_authCodeStatusLabel setText:@"获取\n验证码"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [_protocolButton setSelected:YES];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",[[touch view] class]);
    if ([[touch view] isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    [_phoneTextField resignFirstResponder];
    [_verifyTextField resignFirstResponder];
    
    if (![_verifyBubbleImageView isHidden]) {
        [_verifyBubbleImageView setHidden:YES];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (![_verifyBubbleImageView isHidden]) {
        [_verifyBubbleImageView setHidden:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    DLog(@"%@", textField.text);
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    DLog(@"%@", newString);
    if (textField == _phoneTextField && [newString length] >= 12) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    switch ([btn tag]) {
        case 0:{
            
            if (_animateTimer && [_animateTimer isValid]) {
                [_animateTimer invalidate];
                _animateTimer = nil;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:{
            [_phoneTextField resignFirstResponder];
            [_verifyTextField resignFirstResponder];
            if (![_phoneTextField.text length]) {
                [HDM popHlintMsg:@"请输入手机号码！"];
                break;
            }
            
            if (![HDM isPhoneNum:_phoneTextField.text]) {
                [HDM popHlintMsg:@"请输入正确的手机号码!"];
                break;
            }
            
            _codeModel = nil;
            
            _authCodeSubmitButton.userInteractionEnabled = NO;
            [HHM postUserServiceObtainVerifyCode:@{@"mobile": _phoneTextField.text} success:^(ObtainVerifyCodeModel *codeModel) {
                if (codeModel) {
                    _codeModel = codeModel;
                    [_verifyBubbleImageView setHidden:NO];
                    _secLeft = 90;
                    if (!_animateTimer) {
                        _animateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animateTimer:) userInfo:nil repeats:YES];
                    }
//                    [HDM popHlintMsg:[NSString stringWithFormat:@"验证码:%@", _codeModel.token]];
//                    [HDM popHlintMsg:@"验证码已发送！"];
                }else{
                    [HDM popHlintMsg:@"获取验证码失败！"];
                    _authCodeSubmitButton.userInteractionEnabled = YES;
                }
            } failure:^(NSError *error) {
                [HDM errorPopMsg:error];
                _authCodeSubmitButton.userInteractionEnabled = YES;
            }];
            
            
        }
            break;
        case 2:{
            if ([btn isSelected]) {
                [btn setSelected:NO];
            }else{
                [btn setSelected:YES];
            }
        }
            break;
        case 3:{
            DLog(@"Protocol");
//            [_protocolButton setSelected:!_protocolButton.selected];
            
            ProtocolViewController *protocol = [[ProtocolViewController alloc] initWithNibName:@"ProtocolViewController" bundle:nil];
            [self.navigationController pushViewController:protocol animated:YES];

        }
            break;
        case 4:{
            DLog(@"Login");
            
            if (!_codeModel) {
                [HDM popHlintMsg:@"请获取验证码！"];
                break;
            }
            if (![_phoneTextField.text length]) {
                [HDM popHlintMsg:@"请输入手机号码！"];
                break;
            }
            if (![HDM isPhoneNum:_phoneTextField.text]) {
                [HDM popHlintMsg:@"请输入正确的手机号码!"];
                break;
            }
            
            if (![_verifyTextField.text length]) {
                [HDM popHlintMsg:@"请输入验证码！"];
                break;
            }
            
            if (![_codeModel.token isEqualToString:_verifyTextField.text]) {
                [HDM popHlintMsg:@"请输入正确的验证码！"];
                break;
            }
            
            if (![_protocolButton isSelected]) {
                [HDM popHlintMsg:@"请阅读许可协议并同意！"];
                break;
            }
            
            
            [HHM postUserServiceCheckVerifyCode:@{@"code": [HDM jsonStringFromOjb:@{
                                                                                    @"mobile": _phoneTextField.text,
                                                                                    @"token": _verifyTextField.text
                                                                                    }]} success:^(NSString *info) {
                if (info) {
                    if ([info isEqualToString:@"FAULT"]) {
                        [HDM popHlintMsg:@"错误"];
                    }else if ([info isEqualToString:@"PAST"]){
                        [HDM popHlintMsg:@"过期"];
                    }else{
                        [HDM setMemberId:info];
                        [TMC storeWithObject:info forKey:MEMBERID];
                        if ([_delegate respondsToSelector:@selector(loginViewControllerDidSuccessLogin)]) {
                            [_delegate loginViewControllerDidSuccessLogin];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    [HDM popHlintMsg:@"登录失败"];
                }
            } failure:^(NSError *error) {
                [HDM errorPopMsg:error];
            }];
            
        }
            break;
        default:
            break;
    }
}


- (void)animateTimer:(id)sender{
    _secLeft --;
    if (_secLeft == 0) {
        if (_animateTimer && [_animateTimer isValid]) {
            [_animateTimer invalidate];
            _animateTimer = nil;
        }
        _authCodeSubmitButton.userInteractionEnabled = YES;
        [_authCodeStatusLabel setTextColor:[UIColor darkGrayColor]];
        [_authCodeStatusLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_authCodeStatusLabel setText:@"获取\n验证码"];
    }else{
        if (_secLeft == 85) {
            [_verifyBubbleImageView setHidden:YES];
        }
        
        if (_secLeft <= 30) {
            [_authCodeStatusLabel setTextColor:[UIColor redColor]];
        }else{
            [_authCodeStatusLabel setTextColor:[UIColor darkGrayColor]];
        }
        [_authCodeStatusLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_authCodeStatusLabel setText:[NSString stringWithFormat:@"%ds", _secLeft]];
        
    }
}

@end
