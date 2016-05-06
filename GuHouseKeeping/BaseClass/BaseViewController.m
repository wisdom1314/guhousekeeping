//
//  BaseViewController.m
//  GuHouseKeeping
//
//  Created by David on 4/25/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (IS_IPHONE5) {
        self = [super initWithNibName:[nibNameOrNil stringByAppendingString:@"_iP5"] bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:[nibNameOrNil stringByAppendingString:@"_iP4"] bundle:nibBundleOrNil];
    }
    
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllNoti:) name:@"removeAllNoti" object:nil];
    }
    return self;
}

- (void)removeAllNoti:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    [self.view setBackgroundColor:COLORRGBA(211, 211, 211, 1.0)];
    UIImageView *backGround = nil;
    if (IS_IPHONE5) {
        backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        [backGround setImage:[UIImage imageNamed:@"app_background_ip5.png"]];
    }else{
        backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [backGround setImage:[UIImage imageNamed:@"app_background_ip4.png"]];
    }
    
    [self.view addSubview:backGround];
    [self.view sendSubviewToBack:backGround];


//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

// IOS6默认支持竖屏
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
