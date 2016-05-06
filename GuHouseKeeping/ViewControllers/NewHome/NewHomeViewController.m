//
//  NewHomeViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "NewHomeViewController.h"
#import "NewHomeAreaView.h"
#import "NewHomeServiceTimeView.h"
#import "NewHomeServiceDurationView.h"
#import "StandardFeeViewController.h"
#import "OrderDetailViewController.h"
#import "LoginViewController.h"

typedef enum {
    isOrder = 0
}LoginAction;

@interface NewHomeViewController ()
@property (nonatomic, assign) BOOL didLoginAction;
@property (nonatomic, assign) LoginAction loginAction;
@property (nonatomic, assign) BOOL isAddressFirst;
@property (nonatomic, assign) BOOL isRemarkFirst;
@property (nonatomic, strong) UIView *alterView;
@end

@implementation NewHomeViewController
@synthesize didLoginAction = _didLoginAction;
@synthesize loginAction = _loginAction;
@synthesize isNewHome = _isNewHome;
@synthesize auntID = _auntID;
@synthesize isAddressFirst = _isAddressFirst;
@synthesize isRemarkFirst = _isRemarkFirst;
@synthesize alterView = _alterView;

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

    _serviceTimeContainView.layer.borderWidth = 1.0f;
    _serviceTimeContainView.layer.cornerRadius = 3.0f;
    _serviceTimeContainView.layer.borderColor = [DARKGRAY CGColor];
    _serviceTimeContainView.layer.masksToBounds = YES;
   
    
    _homeSquareContainView.layer.borderWidth = 1.0f;
    _homeSquareContainView.layer.cornerRadius = 3.0f;
    _homeSquareContainView.layer.borderColor = [DARKGRAY CGColor];
    _homeSquareContainView.layer.masksToBounds = YES;
    if (_isNewHome) {
        
    }else{
        [_titleLabel setText:@"提交订单"];
        [_subTitlelabel setText:@"标准费用 ¥30.00/h"];

        [_homeSquareIcon setImage:[UIImage imageNamed:@"new_home_duration.png"]];
        [_homeSquareLabel setText:@"请选择服务时长"];
    }
    
    _addressContainView.layer.borderWidth = 1.0f;
    _addressContainView.layer.cornerRadius = 3.0f;
    _addressContainView.layer.borderColor = [DARKGRAY CGColor];
    _addressContainView.layer.masksToBounds = YES;
    
    _remarkContainView.layer.borderWidth = 1.0f;
    _remarkContainView.layer.cornerRadius = 3.0f;
    _remarkContainView.layer.borderColor = [DARKGRAY CGColor];
    _remarkContainView.layer.masksToBounds = YES;
    
    _isAddressFirst = YES;
    _isRemarkFirst = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


- (void)viewDidAppear:(BOOL)animated{
    if (animated) {
        DLog(@"HomeViewController animated");
        if (_didLoginAction) {
            _didLoginAction = NO;
            [self customButtonAction];
        }
    }else{
        DLog(@"HomeViewController");
    }
}

- (void)loginViewControllerDidSuccessLogin{
    _didLoginAction = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)customButtonAction{
    if ([HDM memberId]) {
        if (_loginAction == isOrder) {
            [self makeAnOrder];
        }
    }else{
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [login setDelegate:(id<LoginViewControllerDelegate>)self];
        [self.navigationController pushViewController:login animated:YES];
    }
}




- (void)keyWillChange:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    float dis = 0;
    if ([_addressTF isFirstResponder]) {
       dis = CGRectGetHeight(_myScrollView.frame) - _addressContainView.frame.origin.y - CGRectGetHeight(_addressContainView.frame) - CGRectGetHeight(keyboardRect);
    }else if ([_remarkTF isFirstResponder]){
      dis  = CGRectGetHeight(_myScrollView.frame) - _remarkContainView.frame.origin.y - CGRectGetHeight(_remarkContainView.frame) - CGRectGetHeight(keyboardRect);
    }
    
    if (dis < 0) {
        [_myScrollView setContentOffset:CGPointMake(0, fabsf(dis)) animated:YES];
    }
}

- (void)keyWillHide:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [_myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _addressTF && _isAddressFirst) {
            _isAddressFirst = NO;
            [_addressTF setText:@""];
    }else if (textField == _remarkTF && _isRemarkFirst){
        _isRemarkFirst = NO;
        [_remarkTF setText:@""];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _addressTF) {
        if ([_addressTF.text length]) {
            
        }else{
            _isAddressFirst = YES;
            [_addressTF setText:@"请填写服务地址（含门牌号）"];
        }
    }else if (textField == _remarkTF){
        if ([_remarkTF.text length]) {
            
        }else{
            _isRemarkFirst = YES;
            [_remarkTF setText:@"请填写您的特殊要求"];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _addressTF) {
        [_addressTF resignFirstResponder];
        [_remarkTF becomeFirstResponder];
    }else if (textField == _remarkTF){
        [_remarkTF resignFirstResponder];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",[[touch view] class]);
    if ([[touch view] isKindOfClass:[UIButton class]] || [[[[touch view] class] description] isEqualToString:@"NewHomeAreaView"] || [[[[touch view] class] description] isEqualToString:@"UITableViewCellContentView"]|| [[[[touch view] class] description] isEqualToString:@"NewHomeServiceTimeView"] || [[[[touch view] class] description] isEqualToString:@"UITableViewWrapperView"]){
        return NO;
    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    if ([_addressTF isFirstResponder]) {
        [_addressTF resignFirstResponder];
    }else if ([_remarkTF isFirstResponder]){
        [_remarkTF resignFirstResponder];
    }
    
    if (_alterView) {
        [_alterView removeFromSuperview];
        _alterView = nil;
    }
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
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:{
            DLog(@"选择时间");
            [self tap:nil];
            [_myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self createNewHomeServiceTime];
        }
            break;
        case 2:{
            DLog(@"选择面积");
            [self tap:nil];
            [_myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            if (_isNewHome) {
                [self createNewHomeAreaView];
            }else{
                [self createNewHomeServiceDuration];
            }
        }
            break;
        case 3:{
            [self tap:nil];
            DLog(@"提交订单");
            if ([_serviceTimeLabel.text isEqualToString:@"请选择服务时间"]) {
                [HDM popHlintMsg:@"请选择服务时间"];
                break;
            }
            
            if (_isNewHome) {
                if ([_homeSquareLabel.text isEqualToString:@"请选择房屋面积"]) {
                    [HDM popHlintMsg:@"请选择房屋面积"];
                    break;
                }
            }else{
                if ([_homeSquareLabel.text isEqualToString:@"请选择服务时长"]) {
                    [HDM popHlintMsg:@"请选择服务时长"];
                    break;
                }
            }

            DLog(@"%@====", _addressTF.text);
            if ([_addressTF.text isEqualToString:@"请填写服务地址（含门牌号）"]) {
                [HDM popHlintMsg:@"请填写服务地址"];
                break;
            }
            
            
            _loginAction = isOrder;
            [self customButtonAction];
        }
            break;
        case 4:{
            StandardFeeViewController *stand = [[StandardFeeViewController alloc] initWithNibName:@"StandardFeeViewController" bundle:nil];
            stand.isNewHome = _isNewHome;
            [self.navigationController pushViewController:stand animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)makeAnOrder {
    NSString *string = nil;
    
    
    if ([_homeSquareLabel.text rangeOfString:@"m²"].location != NSNotFound) {
        string = [NSString stringWithString:[_homeSquareLabel.text substringToIndex:[_homeSquareLabel.text rangeOfString:@"m²"].location]];
    }else{
        string = [NSString stringWithString:_homeSquareLabel.text];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDictionary *dic = @{@"actualPrice": @"",
                          @"address": _addressTF.text,
                          @"auntId": (_isNewHome ? @"" : _auntID),
                          @"contactWay": @"",
                          @"description": @"",
                          @"floorSpace": (_isNewHome ? string : @""),
                          @"optTime": [formatter stringFromDate:[NSDate date]],
                          @"orderId": @"",
                          @"orderStatus": @"NOT_PAY",
                          @"orderUse": (_isNewHome ? @"NEW_HOUSE" : @"HOURLY_WORKER"),
                          @"specialNeed": _remarkTF.text,
                          @"totalPrice": (_isNewHome ? [NSString stringWithFormat:@"%d", 6 * [string integerValue]] : [NSString stringWithFormat:@"%d", 30 * [string integerValue]]),
                          @"unitPrice": (_isNewHome ? @"6" : @"30"),
                          @"useCouponCount": @"0",
                          @"userId": HDM.memberId,
                          @"workLength": (_isNewHome ? @"" : _homeSquareLabel.text),
                          @"workTime": _serviceTimeLabel.text};
    
    [HHM postOrderServiceSaveUserOrder:@{@"order":[HDM jsonStringFromOjb:dic]} success:^(UserOrderModel *info) {
        DLog(@"info:%@", info);
        if (info) {
            [_serviceTimeLabel setText:@"请选择服务时间"];
            
            if (_isNewHome) {
                [_homeSquareLabel setText:@"请选择服务时间"];
            }else{
                [_homeSquareLabel setText:@"请选择服务时长"];
            }
            
            
            [_addressTF setText:@"请填写服务地址（含门牌号）"];
            [_remarkTF setText:@"请填写您的特殊要求"];
            _isAddressFirst = NO;
            _isRemarkFirst = NO;
            OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
            detail.orderId = info.orderId;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            [HDM popHlintMsg:@"订单提交失败!"];
        }
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];
}


- (void)createAlphaView{
    _alterView = [[UIView alloc] initWithFrame:_myScrollView.bounds];
    [_alterView setBackgroundColor:[UIColor clearColor]];
    [_myScrollView addSubview:_alterView];
    
    UIView * alphaView = [[UIView alloc] initWithFrame:_myScrollView.bounds];
    [alphaView setBackgroundColor:[UIColor blackColor]];
    [alphaView setAlpha:0.3];
    [_alterView addSubview:alphaView];
}

- (void)createNewHomeServiceTime{
    [self createAlphaView];
    NewHomeServiceTimeView *homeService = (NewHomeServiceTimeView *)[[[NSBundle mainBundle] loadNibNamed:@"NewHomeServiceTimeView" owner:self options:nil] objectAtIndex:0];
    [homeService setDelegate:(id<NewHomeServiceTimeViewDelegate>)self];
    [homeService setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
    [homeService setBackgroundColor:COLORRGBA(219, 219, 219, 1.0)];
    [_alterView addSubview:homeService];
    
    NSDictionary *dic = nil;
    if ([_serviceTimeLabel.text isEqualToString:@"请选择服务时间"]) {
        NSDate *today = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy"];
        NSString *year = [formatter stringFromDate:today];
        
        [formatter setDateFormat:@"MM"];
        
        NSString *moth = [formatter stringFromDate:today];
        
        [formatter setDateFormat:@"dd"];
        
        NSString *day = [formatter stringFromDate:today];
        
        dic = @{
                @"_firstTableView": year,
                @"_secondTableView": moth,
                @"_thirdTableView": [NSString stringWithFormat:@"%d", [day integerValue]]
                };
    }else{
        NSArray *tmp = [_serviceTimeLabel.text componentsSeparatedByString:@"-"];
        
        if ([tmp count] == 3) {
            dic = @{
                    @"_firstTableView": tmp[0],
                    @"_secondTableView": tmp[1],
                    @"_thirdTableView": tmp[2]
                    };
            
        }
    }
    [homeService reloadInputData:dic];
}

- (void)newHomeServiceTimeViewSelect:(NSString *)area{
    [_serviceTimeLabel setText:area];
    if (_alterView) {
        [_alterView removeFromSuperview];
        _alterView = nil;
    }
}

- (void)createNewHomeAreaView{
    [self createAlphaView];
    NewHomeAreaView *homeArea = (NewHomeAreaView *)[[[NSBundle mainBundle] loadNibNamed:@"NewHomeAreaView" owner:self options:nil] objectAtIndex:0];
    [homeArea setDelegate:(id<NewHomeAreaViewDelegate>)self];
    [homeArea setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
    [homeArea setBackgroundColor:COLORRGBA(219, 219, 219, 1.0)];
    [_alterView addSubview:homeArea];
    
    NSString *string = nil;
    
    
    if ([_homeSquareLabel.text rangeOfString:@"m²"].location != NSNotFound) {
        string = [NSString stringWithString:[_homeSquareLabel.text substringToIndex:[_homeSquareLabel.text rangeOfString:@"m²"].location]];
    }else{
        string = [NSString stringWithString:_homeSquareLabel.text];
    }
    
    NSMutableDictionary *dic  = nil;
    
    if (![string isEqualToString:@"请选择房屋面积"] && [string length] >= 4) {
        dic = [[NSMutableDictionary alloc] init];
        
        float final = 0;
        int first = [[string substringWithRange:NSMakeRange(0, 1)] integerValue];
        final += first * 1000;
        [dic setObject:[NSNumber numberWithInt:first] forKey:@"_firstTableView"];
        
        int second = [[string substringWithRange:NSMakeRange(1, 1)] integerValue];
        final += second * 100;
        [dic setObject:[NSNumber numberWithInt:second] forKey:@"_secondTableView"];

        int third = [[string substringWithRange:NSMakeRange(2, 1)] integerValue];
        final += third * 10;
        [dic setObject:[NSNumber numberWithInt:third] forKey:@"_thirdTableView"];

        int forth = [[string substringWithRange:NSMakeRange(3, 1)] integerValue];
        final += forth;
        [dic setObject:[NSNumber numberWithInt:forth] forKey:@"_forthTableView"];

        if (final == [string integerValue]) {
            
        }else{
            dic = nil;
        }
    }
    [homeArea reloadInputData:dic];

}

- (void)newHomeAreaViewSelect:(NSString *)area{
    [_homeSquareLabel setText:[NSString stringWithFormat:@"%@m²", area]];
    if (_alterView) {
        [_alterView removeFromSuperview];
        _alterView = nil;
    }
}

- (void)createNewHomeServiceDuration{
    [self createAlphaView];
    NewHomeServiceDurationView *homeService = (NewHomeServiceDurationView *)[[[NSBundle mainBundle] loadNibNamed:@"NewHomeServiceDurationView" owner:self options:nil] objectAtIndex:0];
    [homeService setDelegate:(id<NewHomeServiceDurationViewDelegate>)self];
    [homeService setCenter:CGPointMake(CGRectGetWidth(_alterView.frame) / 2.0, CGRectGetHeight(_alterView.frame) / 2.0)];
    [homeService setBackgroundColor:COLORRGBA(219, 219, 219, 1.0)];
    [_alterView addSubview:homeService];

    [homeService reloadInputData:@{@"_firstTableView": _homeSquareLabel.text}];
}

- (void)newHomeServiceDurationViewSelect:(NSString *)time{
    [_homeSquareLabel setText:time];
    if (_alterView) {
        [_alterView removeFromSuperview];
        _alterView = nil;
    }
}

@end
