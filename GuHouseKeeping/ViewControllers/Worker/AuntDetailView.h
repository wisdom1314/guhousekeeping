//
//  AuntDetailView.h
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuntDetailView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *avataImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *certificateImageView;
@property (strong, nonatomic) IBOutlet UILabel *certificateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstStar;
@property (strong, nonatomic) IBOutlet UIImageView *secondStar;
@property (strong, nonatomic) IBOutlet UIImageView *thirdStar;
@property (strong, nonatomic) IBOutlet UIImageView *forthStar;
@property (strong, nonatomic) IBOutlet UIImageView *fifthStar;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;
@property (strong, nonatomic) IBOutlet UIButton *callService;
@property (strong, nonatomic) IBOutlet UIButton *cleanButton;
@property (strong, nonatomic) IBOutlet UIButton *laundryButton;
@property (strong, nonatomic) IBOutlet UIButton *cookButton;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;

- (void)starLevel:(int)level;

@end
