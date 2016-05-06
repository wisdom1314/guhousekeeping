//
//  HomeViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/10/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"
#import "CycleScrollView.h"

@interface HomeViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIImageView *bottomHoverImageView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topBottomView;
@property (strong, nonatomic) IBOutlet UIView *centerContainView;

@property (strong, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (strong, nonatomic) IBOutlet UILabel *bubbleLabel;
- (IBAction)categoryButtonClick:(id)sender;
- (IBAction)buttonClick:(id)sender;


@end
