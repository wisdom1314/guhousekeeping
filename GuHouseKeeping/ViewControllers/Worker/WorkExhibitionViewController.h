//
//  WorkExhibitionViewController.h
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "BaseViewController.h"

@interface WorkExhibitionViewController : BaseViewController
@property (strong, nonatomic) NSString *caseID;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
- (IBAction)buttonClick:(id)sender;
@end
