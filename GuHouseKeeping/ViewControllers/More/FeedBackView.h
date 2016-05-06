//
//  FeedBackView.h
//  GuHouseKeeping
//
//  Created by David on 7/27/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackView : UIView
@property (strong, nonatomic) IBOutlet UITextView *tfView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@end
