//
//  AuntCommitView.h
//  GuHouseKeeping
//
//  Created by David on 8/8/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuntCommitView : UIView
@property (strong, nonatomic) IBOutlet UILabel *perfectLabel;
@property (strong, nonatomic) IBOutlet UIButton *perfectButton;
@property (strong, nonatomic) IBOutlet UILabel *fineLabel;
@property (strong, nonatomic) IBOutlet UIButton *fineButton;
@property (strong, nonatomic) IBOutlet UILabel *badLabel;
@property (strong, nonatomic) IBOutlet UIButton *badButton;
@property (strong, nonatomic) IBOutlet UITextView *myTextView;
@end
