//
//  LaunchViewController.m
//  GuHouseKeeping
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "LaunchViewController.h"
//#import "LoginViewController.h"
#import "HomeViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

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
//    UIImage *normalImage = [UIImage imageNamed:@"slide.png"];
//    UIImage *selectImage = [UIImage imageNamed:@"slide-select.png"];
//    
//    [_firstButton setImage:normalImage forState:UIControlStateNormal];
//    [_secondButton setImage:normalImage forState:UIControlStateNormal];
//    [_thirdButton setImage:normalImage forState:UIControlStateNormal];
//    
//    [_firstButton setImage:selectImage forState:UIControlStateSelected];
//    [_secondButton setImage:selectImage forState:UIControlStateSelected];
//    [_thirdButton setImage:selectImage forState:UIControlStateSelected];
//
//    [_firstButton setSelected:YES];
    
    UIColor *selectColor = COLORRGBA(148, 21, 104, 1);
    UIColor *normalColor = [UIColor whiteColor];
    [_firstButton setBackgroundColor:selectColor];
    [_secondButton setBackgroundColor:normalColor];
    [_thirdButton setBackgroundColor:normalColor];
    
    
    for (int i = 1; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * (i - 1), 0 , 320, 568)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"launch_0%d.png", i]]];
        [_myScrollView addSubview:imageView];
        if (i == 3) {
            [imageView setUserInteractionEnabled:YES];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            if (IS_IPHONE5) {
                [button setFrame:CGRectMake(640 + 59, 472, 202, 40)];
            }else{
                [button setFrame:CGRectMake(640 + 59, 400, 202, 40)];
            }
            [button setTitle:@"点击欢乐体验吧" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
            [button setBackgroundImage:[UIImage imageNamed:@"click_experience.png"] forState:UIControlStateNormal];
            [_myScrollView addSubview:button];
            [button addTarget:self action:@selector(startButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [_myScrollView setContentSize:CGSizeMake(CGRectGetWidth(_myScrollView.frame) * 3, CGRectGetHeight(_myScrollView.frame))];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)startButton:(id)sender{
//    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    [self.navigationController pushViewController:login animated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRSTLAUNCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:home animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self resetButtonState];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self resetButtonState];
    }
}

- (void)resetButtonState{
    int tag = (int)(_myScrollView.contentOffset.x / CGRectGetWidth(_myScrollView.frame));
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:tag];
    [self buttonClick:btn];
}

- (IBAction)buttonClick:(id)sender {
    if ([_myScrollView isDragging] || [_myScrollView isDecelerating]) {
        return;
    }
    UIButton *button = (UIButton *)sender;
    UIColor *selectColor = COLORRGBA(148, 21, 104, 1);
    UIColor *normalColor = [UIColor whiteColor];

    
    switch ([button tag]) {
        case 0:{
//            [_firstButton setSelected:YES];
//            [_secondButton setSelected:NO];
//            [_thirdButton setSelected:NO];
            
            [_firstButton setBackgroundColor:selectColor];
            [_secondButton setBackgroundColor:normalColor];
            [_thirdButton setBackgroundColor:normalColor];
            
        }
            break;
            
        case 1:{
//            [_firstButton setSelected:NO];
//            [_secondButton setSelected:YES];
//            [_thirdButton setSelected:NO];
            
            [_firstButton setBackgroundColor:normalColor];
            [_secondButton setBackgroundColor:selectColor];
            [_thirdButton setBackgroundColor:normalColor];

        }
            break;
        case 2:{
//            [_firstButton setSelected:NO];
//            [_secondButton setSelected:NO];
//            [_thirdButton setSelected:YES];
            
            [_firstButton setBackgroundColor:normalColor];
            [_secondButton setBackgroundColor:normalColor];
            [_thirdButton setBackgroundColor:selectColor];
        }
            break;
        default:
            break;
    }
    [_myScrollView setContentOffset:CGPointMake([button tag] * CGRectGetWidth(_myScrollView.frame), 0) animated:YES];

}
@end
