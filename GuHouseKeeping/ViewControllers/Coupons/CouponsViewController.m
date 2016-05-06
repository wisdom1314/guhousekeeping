//
//  CouponsViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "CouponsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZBarSDK/Headers/ZBarSDK/ZBarReaderController.h"
#import "ZBarSDK/Headers/ZBarSDK/ZBarImageScanner.h"
#import "ZBarSDK/Headers/ZBarSDK/ZBarReaderViewController.h"

@interface CouponsViewController ()
@property (nonatomic, strong) ZBarReaderViewController *reader;
@end

@implementation CouponsViewController
@synthesize reader = _reader;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(id)initWithBlock:(void(^)(NSString*,BOOL))a{
//    if (self=[super init]) {
//        self.ScanResult=a;
//        
//    }
//    
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_horizontalLine1 setFrame:CGRectMake(_horizontalLine1.frame.origin.x, _horizontalLine1.frame.origin.y, CGRectGetWidth(_horizontalLine1.frame), 0.5)];
    [_horizontalLine2 setFrame:CGRectMake(_horizontalLine2.frame.origin.x, _horizontalLine2.frame.origin.y, CGRectGetWidth(_horizontalLine2.frame), 0.5)];

    [_myScrollView setContentSize:CGSizeMake(CGRectGetWidth(_myScrollView.frame), 504)];
    
    
    _serialNumberTF.layer.borderWidth = 1.0f;
    _serialNumberTF.layer.cornerRadius = 3.0f;
    _serialNumberTF.layer.borderColor = [DARKGRAY CGColor];
    _serialNumberTF.layer.masksToBounds = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [tap setDelegate:(id<UIGestureRecognizerDelegate>)self];
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",[[touch view] class]);
    if ([[touch view] isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer{
    if ([_serialNumberTF isFirstResponder]) {
        [_serialNumberTF resignFirstResponder];
    }
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}







#pragma mark Notification

- (void)keyWillChange:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    float dis = fabsf(CGRectGetHeight(_myScrollView.frame) - _serialNumberTF.frame.origin.y - CGRectGetHeight(_serialNumberTF.frame) - CGRectGetHeight(keyboardRect));
    
    [_myScrollView setContentOffset:CGPointMake(0, dis) animated:YES];
    
    
    
}

- (void)keyWillHide:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [_myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([_serialNumberTF isFirstResponder]) {
        [_serialNumberTF resignFirstResponder];
    }
    [self didEnterSerialNumber];
    
    return YES;
}

- (void)didEnterSerialNumber{
    if ([_serialNumberTF.text length]) {
        [HDM popHlintMsg:@"暂未开放！"];
    }else{
        [HDM popHlintMsg:@"请输入序列号！"];
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
            DLog(@"scan");
            if (!_reader) {

                _reader = [ZBarReaderViewController new];
                
                _reader.readerDelegate = (id<ZBarReaderDelegate>)self;//self;
                _reader.supportedOrientationsMask = ZBarOrientationMaskAll;
                _reader.wantsFullScreenLayout = NO;
                _reader.cameraMode = ZBarReaderControllerCameraModeSampling;
                
                _reader.showsZBarControls = YES;
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
                    _reader.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;//
                }else{
                    _reader.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;//
                }
                
                ZBarImageScanner *scanner = _reader.scanner;
                
                [scanner setSymbology: ZBAR_I25
                               config: ZBAR_CFG_ENABLE
                                   to: 0];
                UIView *topView;
                if (IS_IOS7) {
                    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
                }else{
                    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
                    
                }
                
                [topView setBackgroundColor:COLORRGBA(244, 244, 244, 1)];
                
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
                
                if (IS_IOS7) {
                    [label setCenter:CGPointMake(label.center.x, label.center.y + 20)];
                }
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setFont:[UIFont systemFontOfSize:17.0]];
                [label setText:@"二维码扫描"];
                [label setTextColor:[UIColor whiteColor]];
                [label setBackgroundColor:PURPLECOLOR];
                
                [topView addSubview:label];

                
                UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [backButton setFrame:CGRectMake(0, 0, 60, 44)];
                if (IS_IOS7) {
                    [backButton setCenter:CGPointMake(backButton.center.x, backButton.center.y + 20)];
                }
                [topView addSubview:backButton];
                [backButton addTarget:self action:@selector(readerDismiss:) forControlEvents:UIControlEventTouchUpInside];
                [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
                
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 50, 280, 280)];
                
                [topView addSubview:imageView];
                
                UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(20, 356, 280, 68)];
                [topView addSubview:label1];
               
                

                [_reader.view addSubview:topView];
            }
            
            
            [self presentViewController:_reader animated:YES completion:^{
                
            }];
        }
            break;
        case 2:{
        

            DLog(@"Input");
        }
            break;
        default:
            break;
    }
}




- (void)readerDismiss:(id)sender{
    if (_reader) {
        [_reader dismissViewControllerAnimated:YES completion:^{

        }];
    }
    NSLog(@"shit");
}

- (void)imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
     [symbol.data stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"%@", [symbol.data stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
