//
//  TimeAuntServiceView.h
//  GuHouseKeeping
//
//  Created by David on 7/27/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeAuntServiceView : UIView
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) UIView *dropView;
@property (strong, nonatomic) NSArray *selectItems;
@property (strong, nonatomic) IBOutlet UILabel *selectLabel;

@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@end
