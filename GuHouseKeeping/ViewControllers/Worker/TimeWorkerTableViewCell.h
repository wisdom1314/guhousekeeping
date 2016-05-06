//
//  TimeWorkerTableViewCell.h
//  GuHouseKeeping
//
//  Created by David on 7/24/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeWorkerTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avataImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *certificateImageView;
@property (strong, nonatomic) IBOutlet UILabel *certificateLabel;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dealLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstStar;
@property (strong, nonatomic) IBOutlet UIImageView *secondStar;
@property (strong, nonatomic) IBOutlet UIImageView *thirdStar;
@property (strong, nonatomic) IBOutlet UIImageView *forthStar;
@property (strong, nonatomic) IBOutlet UIImageView *fifthStar;

- (void)starLevel:(int)level;
@end
